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


# --- Renamed core counting logic (Robust for YAML Dashboards) ---
def _get_query_counts(dashboard_body, verbose=False):
    """
    Core logic to count query executions (named + inline) in a dashboard body.
    Finds elements by searching for the YAML list item structure (- title: or - name:).
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
    # Use non-greedy match to capture everything after 'elements:' up to the next top-level block.
    # The [^\]]*? part is still problematic for LookML braces, using re.DOTALL and non-greedy instead.
    elements_section_match = re.search(r'elements:\s*\n(.+?)(?=\n\s*\w+:|\n\s*filters:|\Z)', dashboard_body, re.DOTALL)

    if elements_section_match:
        elements_body = elements_section_match.group(1)
        
        # 3. COUNT QUERY-GENERATING ELEMENTS (by splitting on the YAML list item start)
        
        # Pattern to find the start of a new element: '- title:' or '- name:'
        element_start_pattern = r'\n\s*-\s*(title|name):\s*.*?\n'
        
        # Split the elements section into individual tile definitions
        elements_list = re.split(element_start_pattern, elements_body, flags=re.DOTALL)
        
        # The list is [junk, title/name key, element_content, title/name key, element_content, ...]
        # Iterate over the content items (elements_list[i+1])
        for i in range(1, len(elements_list), 2):
            element_content = elements_list[i+1]
            
            # Check for fields or explore, indicating a query element (not text/button/etc)
            is_query_tile = re.search(r'\b(fields|explore):\s*', element_content)

            if is_query_tile:
                counts['total_elements'] += 1
                
                # Check for query reference first (element references a named query)
                query_ref_pattern = r'\bquery:\s*(\w+)\s*(?!\{)'
                query_ref_match = re.search(query_ref_pattern, element_content)
                
                if query_ref_match:
                    # Element references a named query (already counted in Step 1)
                    continue
                
                # If it's a query tile AND it doesn't reference a named query, it's an inline query
                counts['inline_queries'] += 1
    
    # 4. CALCULATE TOTAL EXECUTIONS
    counts['total_executions'] = counts['named_queries'] + counts['inline_queries']
    
    return counts


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


def count_dashboard_queries(files, max_queries=5, verbose=False): 
    """
    Count queries/elements in each dashboard and flag those exceeding the limit.
    """
    violations = []
    dashboards_checked = 0 # This count is now accurate and returned
    
    # ... (verbose prints omitted for brevity)

    for file_path in files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # Find all dashboard definitions
            dashboard_pattern = r'dashboard:\s*(\w+)\s*\{'
            
            for dashboard_match in re.finditer(dashboard_pattern, content):
                dashboard_name = dashboard_match.group(1)
                
                # Find the matching closing brace
                dashboard_end = find_matching_brace(content, dashboard_match.end() - 1)
                
                if dashboard_end == -1:
                    continue
                
                dashboard_body = content[dashboard_match.end():dashboard_end]
                
                # Increment the checked count for every successfully parsed dashboard
                dashboards_checked += 1 
                
                # Call the correct, renamed counting function
                query_count = _get_query_counts(dashboard_body, verbose=verbose) 
                
                # ... (Reporting logic remains the same)
                if query_count['total_executions'] > max_queries:
                    violations.append({
                        'file': file_path,
                        'dashboard': dashboard_name,
                        'query_executions': query_count['total_executions'],
                        'max_allowed': max_queries,
                        'breakdown': query_count
                    })
                
        except Exception as e:
            # ... (Exception handling remains the same)
            continue
    
    return violations, dashboards_checked # Return the count


def main():
    parser = argparse.ArgumentParser(
        description='Check that LookML dashboards do not exceed query limit'
    )
    # ... (argparse setup remains the same)
    parser.add_argument('--project-name', default='.', help='Project root directory (default: current directory)')
    parser.add_argument('--max-queries', type=int, default=5, help='Maximum allowed queries per dashboard (default: 5)')
    parser.add_argument('--verbose', action='store_true', help='Enable verbose output for debugging')
    parser.add_argument('--files', help='Space-separated list of specific files to check')
    parser.add_argument('--output-json', help='Save results to JSON file')
    
    args = parser.parse_args()
    
    # FILE DISCOVERY
    files_to_audit = []
    
    # ... (File discovery logic remains the same)
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
    
    # RUN AUDIT: Capture the returned count
    violations, dashboards_checked = count_dashboard_queries(
        files_to_audit,
        max_queries=args.max_queries,
        verbose=args.verbose
    )
    
    # ... (JSON output logic remains the same)
    
    # REPORTING
    if violations:
        # ... (Violation reporting remains the same)
        sys.exit(1)
    
    else:
        print(f"\n{'='*70}")
        print("✅ Dashboard Query Limit Audit Passed")
        print(f"{'='*70}")
        # FIX: Use the correctly returned and captured count
        print(f"📊 Total dashboards checked: {dashboards_checked}") 
        print(f"All dashboards have ≤ {args.max_queries} queries.")
        print(f"{'='*70}\n")
        
        sys.exit(0)


if __name__ == '__main__':
    main()
