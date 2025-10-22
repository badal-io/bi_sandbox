#!/usr/bin/env python3
"""
LookML Dashboard Query Limit Checker
Checks that dashboards don't exceed the maximum allowed queries (default: 5)
"""

import re
import sys
import os
import glob
import argparse
import json

def _get_query_counts(dashboard_body, verbose=False):
    # ... (counts and named queries logic) ...

    # 2. ISOLATE THE 'elements:' SECTION BODY 
    # This block is still necessary to avoid counting fields/explores in filters or other blocks.
    elements_section_match = re.search(r'(elements:\s*\n)(.+?)(?=\n\s*\w+:|\n\s*filters:|\Z)', 
                                        dashboard_body, re.DOTALL)
    
    if elements_section_match:
        # We only search the content *after* the 'elements:' declaration
        elements_body = elements_section_match.group(2) 
        
        # 3. ROBUST ELEMENT COUNTING:
        # Pattern finds a list item marker ('-\s*') followed by a title/name and *eventually* a query marker.
        # It's less strict about line beginnings than the '^\s*' anchor.
        
        query_element_pattern = r'-\s*(?:title|name):\s*.*?\b(fields|explore):\s*'
        
        # We count occurrences of the unique signature of a query tile within the elements_body
        query_elements = re.findall(query_element_pattern, elements_body, re.DOTALL)
        
        # query_elements now contains tuples of matches; the length is the count.
        counts['total_elements'] = len(query_elements)
        counts['inline_queries'] = counts['total_elements']

    # ... (rest of the function)
    return counts

def find_matching_brace(text, start_pos):
    """
    Find the position of the matching closing brace.
    """
    brace_count = 1
    pos = start_pos + 1
    
    while pos < len(text) and brace_count > 0:
        if text[pos] == '{':
            brace_count += 1
        elif text[pos] == '}':
            brace_count -= 1
        pos += 1
    
    if brace_count == 0:
        return pos - 1
    else:
        return -1


def count_dashboard_queries(files, max_queries=5, verbose=False): 
    """
    Iterates through files, extracts dashboards, and calls the core counting function.
    """
    violations = []
    dashboards_checked = 0
    
    if verbose:
        print(f"\n{'='*70}")
        print("🔍 Starting Dashboard Query Count Audit")
        print(f"{'='*70}")
        print(f"Maximum allowed queries per dashboard: {max_queries}\n")
    
    for file_path in files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if verbose:
                print(f"📄 Processing: {file_path}")
            
            # Find all dashboard definitions
            dashboard_pattern = r'dashboard:\s*(\w+)\s*\{'
            
            for dashboard_match in re.finditer(dashboard_pattern, content):
                dashboard_name = dashboard_match.group(1)
                
                # Find the matching closing brace
                dashboard_end = find_matching_brace(content, dashboard_match.end() - 1)
                
                if dashboard_end == -1:
                    if verbose:
                        print(f"  ⚠️ Warning: Could not find closing brace for dashboard '{dashboard_name}'")
                    continue
                
                dashboard_body = content[dashboard_match.end():dashboard_end]
                
                dashboards_checked += 1 
                
                query_count = _get_query_counts(dashboard_body, verbose=verbose) 
                
                if verbose:
                    print(f"  📊 Dashboard: '{dashboard_name}'")
                    print(f"    ⚡ Actual query EXECUTIONS: {query_count['total_executions']}")
                
                # Check if exceeds limit
                if query_count['total_executions'] > max_queries:
                    violations.append({
                        'file': file_path,
                        'dashboard': dashboard_name,
                        'query_executions': query_count['total_executions'],
                        'max_allowed': max_queries,
                        'breakdown': query_count
                    })
        
        except Exception as e:
            if verbose:
                print(f"❌ Error processing file {file_path}: {e}")
            continue
    
    return violations, dashboards_checked


def main():
    parser = argparse.ArgumentParser(
        description='Check that LookML dashboards do not exceed query limit'
    )
    parser.add_argument('--project-name', default='.', help='Project root directory (default: current directory)')
    parser.add_argument('--max-queries', type=int, default=5, help='Maximum allowed queries per dashboard (default: 5)')
    parser.add_argument('--verbose', action='store_true', help='Enable verbose output for debugging')
    parser.add_argument('--files', help='Space-separated list of specific files to check')
    parser.add_argument('--output-json', help='Save results to JSON file')
    
    args = parser.parse_args()
    
    # FILE DISCOVERY
    files_to_audit = []
    
    if args.files:
        files_to_audit = args.files.split()
    else:
        project_root = args.project_name
        patterns = ['**/*.dashboard.lookml', '**/*.dashboard.lkml', '**/dashboard*.lkml', '**/dashboards/*.lkml']
        for pattern in patterns:
            for filename in glob.iglob(os.path.join(project_root, pattern), recursive=True):
                if filename not in files_to_audit: files_to_audit.append(filename)

    if not files_to_audit:
        print("⚠️ No dashboard files found to audit.")
        sys.exit(0)
    
    if args.verbose:
        print(f"Dashboard files to audit ({len(files_to_audit)}):")
        for f in files_to_audit:
            print(f"  - {f}")
    
    # RUN AUDIT
    violations, dashboards_checked = count_dashboard_queries(
        files_to_audit,
        max_queries=args.max_queries,
        verbose=args.verbose
    )
    
    # REPORTING
    if violations:
        print(f"\n{'='*70}")
        print("❌ Dashboard Query Limit Audit Failed")
        print(f"{'='*70}")
        print(f"Found {len(violations)} dashboard(s) exceeding query limit:\n")
        
        for v in violations:
            message = f"Dashboard '{v['dashboard']}' has {v['query_executions']} query executions (max: {v['max_allowed']})"
            print(f"::warning file={v['file']},title=Too Many Dashboard Queries::{message}")
            print(f"  📍 {v['file']}")
            print(f"    Dashboard: {v['dashboard']}")
            print(f"    ⚡ Query EXECUTIONS: {v['query_executions']}")
            print(f"    Limit: {v['max_allowed']}")
            print(f"    Breakdown:")
            print(f"      - Total tiles/elements: {v['breakdown']['total_elements']}")
            print(f"      - Named queries: {v['breakdown']['named_queries']}")
            print(f"      - Inline queries: {v['breakdown']['inline_queries']}")
            print()
        
        print(f"{'='*70}")
        print("💡 Recommendations: (see above)")
        print(f"{'='*70}\n")
        
        sys.exit(1)
    
    else:
        print(f"\n{'='*70}")
        print("✅ Dashboard Query Limit Audit Passed")
        print(f"{'='*70}")
        print(f"📊 Total dashboards checked: {dashboards_checked}") 
        print(f"All dashboards have ≤ {args.max_queries} queries.")
        print(f"{'='*70}\n")
        
        sys.exit(0)


if __name__ == '__main__':
    main()
