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


def count_dashboard_queries(files, max_queries=4, verbose=False):
    """
    Count queries/elements in each dashboard and flag those exceeding the limit.
   
    Counts:
    - elements: (tiles with queries)
    - queries: (named queries)
    - filters: (dashboard filters that generate queries)
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
                dashboard_start = dashboard_match.start()
               
                # Find the matching closing brace
                dashboard_end = find_matching_brace(content, dashboard_match.end() - 1)
               
                if dashboard_end == -1:
                    if verbose:
                        print(f"   ⚠️  Warning: Could not find closing brace for dashboard '{dashboard_name}'")
                    continue
               
                dashboard_body = content[dashboard_match.end():dashboard_end]
                dashboards_checked += 1
               
                # Count different types of query elements
                query_count = count_queries_in_dashboard(dashboard_body)
               
                if verbose:
                    print(f"   📊 Dashboard: '{dashboard_name}'")
                    print(f"      Elements: {query_count['elements']}")
                    print(f"      Named queries: {query_count['queries']}")
                    print(f"      Total query count: {query_count['total']}")
               
                # Check if exceeds limit
                if query_count['total'] > max_queries:
                    violations.append({
                        'file': file_path,
                        'dashboard': dashboard_name,
                        'query_count': query_count['total'],
                        'max_allowed': max_queries,
                        'breakdown': query_count
                    })
                   
                    if verbose:
                        print(f"      ❌ VIOLATION: {query_count['total']} queries exceeds limit of {max_queries}")
                elif verbose:
                    print(f"      ✅ OK: Within limit")
               
                if verbose:
                    print()
       
        except FileNotFoundError:
            print(f"⚠️  Warning: File not found at {file_path}. Skipping.")
            continue
        except Exception as e:
            print(f"❌ Error processing file {file_path}: {e}")
            if verbose:
                import traceback
                traceback.print_exc()
            continue
   
    if verbose:
        print(f"{'='*70}")
        print(f"📊 Total dashboards checked: {dashboards_checked}")
        print(f"{'='*70}\n")
   
    return violations


def count_queries_in_dashboard(dashboard_body):
    """
    Count the number of queries in a dashboard body.
   
    Returns a dictionary with:
    - elements: number of element blocks (tiles/visualizations)
    - queries: number of named query blocks
    - total: total count
    """
    counts = {
        'elements': 0,
        'queries': 0,
        'total': 0
    }
   
    # Count element blocks (each element typically represents a tile with a query)
    # Pattern: element: element_name {
    element_pattern = r'\belement:\s*\w+\s*\{'
    counts['elements'] = len(re.findall(element_pattern, dashboard_body))
   
    # Count named query blocks
    # Pattern: query: query_name {
    query_pattern = r'\bquery:\s*\w+\s*\{'
    counts['queries'] = len(re.findall(query_pattern, dashboard_body))
   
    # Total is the sum (elements are the main queries)
    # Named queries can be referenced by elements, so we count unique queries
    # For simplicity, we'll count elements as the primary metric
    counts['total'] = counts['elements']
   
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


def main():
    parser = argparse.ArgumentParser(
        description='Check that LookML dashboards do not exceed query limit'
    )
    parser.add_argument(
        '--project-name',
        default='.',
        help='Project root directory (default: current directory)'
    )
    parser.add_argument(
        '--max-queries',
        type=int,
        default=5,
        help='Maximum allowed queries per dashboard (default: 5)'
    )
    parser.add_argument(
        '--verbose',
        action='store_true',
        help='Enable verbose output for debugging'
    )
    parser.add_argument(
        '--files',
        help='Space-separated list of specific files to check'
    )
    parser.add_argument(
        '--output-json',
        help='Save results to JSON file'
    )
   
    args = parser.parse_args()
   
    # FILE DISCOVERY
    files_to_audit = []
   
    if args.files:
        # Use specific files provided
        files_to_audit = args.files.split()
    else:
        # Find all dashboard files recursively
        project_root = args.project_name
       
        # Look for .dashboard.lookml, .dashboard.lkml, and files with 'dashboard' in name
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
        print("⚠️  No dashboard files found to audit.")
        sys.exit(0)
   
    if args.verbose:
        print(f"Dashboard files to audit ({len(files_to_audit)}):")
        for f in files_to_audit:
            print(f"  - {f}")
   
    # RUN AUDIT
    violations = count_dashboard_queries(
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
                    'dashboards_checked': len(files_to_audit),
                    'violations_found': len(violations)
                },
                'violations': violations
            }
           
            with open(args.output_json, 'w') as f:
                json.dump(output_data, f, indent=2)
           
            print(f"📄 Results saved to: {args.output_json}")
        except Exception as e:
            print(f"⚠️  Warning: Could not save JSON output: {e}")
   
    # REPORTING
    if violations:
        print(f"\n{'='*70}")
        print("❌ Dashboard Query Limit Audit Failed")
        print(f"{'='*70}")
        print(f"Found {len(violations)} dashboard(s) exceeding query limit:\n")
       
        for v in violations:
            message = f"Dashboard '{v['dashboard']}' has {v['query_count']} queries (max: {v['max_allowed']})"
           
            # GitHub Actions annotation format
            print(f"::warning file={v['file']},title=Too Many Dashboard Queries::{message}")
           
            # Also print readable format
            print(f"   📍 {v['file']}")
            print(f"      Dashboard: {v['dashboard']}")
            print(f"      Query count: {v['query_count']}")
            print(f"      Limit: {v['max_allowed']}")
            print(f"      Elements (tiles): {v['breakdown']['elements']}")
            print(f"      Named queries: {v['breakdown']['queries']}")
            print()
       
        print(f"{'='*70}")
        print("💡 Recommendations:")
        print("   1. Split large dashboards into multiple smaller dashboards")
        print("   2. Remove unnecessary tiles/queries")
        print("   3. Combine related visualizations")
        print("   4. Consider using dashboard filters instead of multiple queries")
        print(f"{'='*70}\n")
       
        sys.exit(1)  # Fail the check
   
    else:
        print(f"\n{'='*70}")
        print("✅ Dashboard Query Limit Audit Passed")
        print(f"{'='*70}")
        print(f"All dashboards have ≤ {args.max_queries} queries.")
        print(f"{'='*70}\n")
       
        sys.exit(0)  # Pass the check


if __name__ == '__main__':
    main()
