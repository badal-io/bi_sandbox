#!/usr/bin/env python3
"""
LookML Dashboard Query Limit Checker
Checks that dashboards don't exceed the maximum allowed queries (default: 5)
Too many queries can cause performance issues and slow dashboard load times
"""

import re
import sys
import os
import glob
import argparse
import json


def find_matching_brace(text, start_pos):
    """
    Find the position of the matching closing brace.
    start_pos should be the position of the opening brace.
    Returns the position of the matching closing brace, or -1 if not found.
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


def count_dashboard_queries(files, max_queries=2, verbose=False): 
    """
    Count queries/elements in each dashboard and flag those exceeding the limit.
    This function wraps the logic for file iteration and final reporting.
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
            # Pattern: dashboard: dashboard_name {
            dashboard_pattern = r'dashboard:\s*(\w+)\s*\{'
            
            for dashboard_match in re.finditer(dashboard_pattern, content):
                dashboard_name = dashboard_match.group(1)
                dashboards_checked += 1
                
                # Use the helper function to find the matching closing brace
                dashboard_end = find_matching_brace(content, dashboard_match.end() - 1)
                
                if dashboard_end == -1:
                    if verbose:
                        print(f"  ⚠️ Warning: Could not find closing brace for dashboard '{dashboard_name}'")
                    continue
                
                # Extract the dashboard body
                dashboard_body = content[dashboard_match.end():dashboard_end]
                
                # Call the core counting logic
                query_count = _get_query_counts(dashboard_body, verbose=verbose)
                
                if verbose:
                    print(f"  📊 Dashboard: '{dashboard_name}'")
                    print(f"      Total elements (tiles): {query_count['total_elements']}")
                    print(f"      Named queries: {query_count['named_queries']}")
                    print(f"      Inline queries: {query_count['inline_queries']}")
                    print(f"      ⚡ Actual query EXECUTIONS: {query_count['total_executions']}")
                
                # Check if exceeds limit
                if query_count['total_executions'] > max_queries:
                    violations.append({
                        'file': file_path,
                        'dashboard': dashboard_name,
                        'query_executions': query_count['total_executions'],
                        'max_allowed': max_queries,
                        'breakdown': query_count
                    })
                    
                    if verbose:
                        print(f"      ❌ VIOLATION: {query_count['total_executions']} query executions exceeds limit of {max_queries}")
                elif verbose:
                    print(f"      ✅ OK: Within limit")
                
                if verbose:
                    print()
        
        except FileNotFoundError:
            print(f"⚠️ Warning: File not found at {file_path}. Skipping.")
            continue
        except Exception as e:
            print(f"❌ Error processing file {file_path}: {e}")
            if verbose:
                import traceback
                traceback.print_exc()
            continue
    
    # NOTE: The final summary print is handled in main() using len(files_to_audit)
    return violations, dashboards_checked


# --- Renamed and fixed core counting logic ---
def _get_query_counts(dashboard_body, verbose=False):
    """
    Core logic to count query executions (named + inline) in a dashboard body.
    """
    counts = {
        'named_queries': 0,
        'inline_queries': 0,
        'total_elements': 0,
        'total_executions': 0
    }
    
    # 1. FIND NAMED QUERIES 
    named_query_pattern = r'\bquery:\s*(\w+)\s*\{'
    named_queries = re.finditer(named_query_pattern, dashboard_body)
    named_query_names = set(match.group(1) for match in named_queries)
    counts['named_queries'] = len(named_query_names)
    
    # 2. FIND THE 'elements:' SECTION BODY
    # This is the most crucial part for YAML-style dashboards
    elements_section_match = re.search(r'\s*elements:\s*\[?([^\]]*?)', dashboard_body, re.DOTALL)

    if elements_section_match:
        elements_body = elements_section_match.group(1)
        
        # 3. COUNT QUERY-GENERATING ELEMENTS (by splitting on the YAML list item start)
        
        # Pattern to find the start of a new element: '- title:' or '- name:'
        # Using a newline and minimum indentation to reliably separate YAML list items
        element_start_pattern = r'\n\s*-\s*(title|name):\s*.*?\n'
        
        # Split the elements section into individual tile definitions
        elements_list = re.split(element_start_pattern, elements_body, flags=re.DOTALL)
        
        # The list is [junk, title/name key, element_content, title/name key, element_content, ...]
        # Iterate over the content items (elements_list[i+1])
        for i in range(1, len(elements_list), 2):
            element_content = elements_list[i+1] # The content is always the item after the key
            
            # Check for fields or explore, indicating a query element (not text/button/etc)
            # This is key for identifying query-generating tiles
            is_query_tile = re.search(r'\b(fields|explore):\s*', element_content)

            if is_query_tile:
                counts['total_elements'] += 1
                
                # Check for query reference first (element references a named query)
                query_ref_pattern = r'\bquery:\s*(\w+)\s*(?!\{)'
                query_ref_match = re.search(query_ref_pattern, element_content)
                
                if query_ref_match:
                    # Element references a named query (already counted in Step 1)
                    if verbose: print(f"DEBUG: Element references named query")
                    continue
                
                # If it's a query tile AND it doesn't reference a named query, it's an inline query
                counts['inline_queries'] += 1
                if verbose: print(f"DEBUG: Element has inline query")
            
    # 4. CALCULATE TOTAL EXECUTIONS
    counts['total_executions'] = counts['named_queries'] + counts['inline_queries']
    
    return counts


def main():
    parser = argparse.ArgumentParser(
        description='Check that LookML dashboards do not exceed query limit'
    )
    # ... (rest of argparse setup remains the same)
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
        patterns = [
            '**/*.dashboard.lookml',
            '**/*.dashboard.lkml',
            '**/dashboard*.lkml',
            '**/dashboards/*.lkml'
        ]
        
        for pattern in patterns:
            for filename in glob.iglob(os.path.join(project_root, pattern), recursive=True):
                if filename not in files_to_audit:
                    files_to_audit.append(filename)
    
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
    
    # SAVE JSON OUTPUT if requested
    if args.output_json:
        try:
            output_data = {
                'summary': {
                    'max_queries_allowed': args.max_queries,
                    'dashboards_checked': dashboards_checked, # Use the returned count
                    'violations_found': len(violations)
                },
                'violations': violations
            }
            
            with open(args.output_json, 'w') as f:
                json.dump(output_data, f, indent=2)
            
            print(f"📄 Results saved to: {args.output_json}")
        except Exception as e:
            print(f"⚠️ Warning: Could not save JSON output: {e}")
    
    # REPORTING
    # ... (Reporting logic remains the same, using dashboards_checked)
    if violations:
        print(f"\n{'='*70}")
        print("❌ Dashboard Query Limit Audit Failed")
        print(f"{'='*70}")
        print(f"Found {len(violations)} dashboard(s) exceeding query limit:\n")
        
        for v in violations:
            message = f"Dashboard '{v['dashboard']}' has {v['query_executions']} query executions (max: {v['max_allowed']})"
            
            # GitHub Actions annotation format
            print(f"::warning file={v['file']},title=Too Many Dashboard Queries::{message}")
            
            # Also print readable format
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
        print("💡 Recommendations:")
        print("  1. Split large dashboards into multiple smaller dashboards")
        print("  2. Remove unnecessary tiles/queries")
        print("  3. Combine related visualizations")
        print("  4. Use named queries and reference them (more efficient)")
        print(f"{'='*70}\n")
        
        sys.exit(1)  # Fail the check
    
    else:
        print(f"\n{'='*70}")
        print("✅ Dashboard Query Limit Audit Passed")
        print(f"{'='*70}")
        print(f"📊 Total dashboards checked: {dashboards_checked}")
        print(f"All dashboards have ≤ {args.max_queries} queries.")
        print(f"{'='*70}\n")
        
        sys.exit(0)  # Pass the check


if __name__ == '__main__':
    main()
