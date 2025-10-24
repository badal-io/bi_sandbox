#!/usr/bin/env python3
"""
LookML Dashboard Query Limit Checker (YAML Format)
Checks that dashboards don't exceed the maximum allowed queries (default: 5)
"""
import re
import sys
import os
import glob
import argparse
import json

import yaml

def _get_query_counts_yaml(dashboard_body, verbose=False):
    counts = {
        'named_queries': 0,
        'inline_queries': 0,
        'total_elements': 0,
        'total_executions': 0
    }
    try:
        data = yaml.safe_load(dashboard_body)
        elements = data.get('elements', [])
        counts['total_elements'] = len(elements)
        for element in elements:
            if 'query' in element:
                counts['named_queries'] += 1
            elif any(k in element for k in ['model', 'explore', 'fields']):
                counts['inline_queries'] += 1
        counts['total_executions'] = counts['named_queries'] + counts['inline_queries']
    except Exception as e:
        if verbose:
            print(f"YAML parsing error: {e}")
    return counts


def count_dashboard_queries(files, max_queries=5, verbose=False):
    """
    Iterates through files, extracts dashboards, and calls the core counting function.
    """
    violations = []
    dashboards_checked = 0

    if verbose:
        print(f"\n{'='*70}")
        print("\n Starting Dashboard Query Count Audit")
        print(f"{'='*70}")
        print(f"Maximum allowed queries per dashboard: {max_queries}\n")

    for file_path in files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()

            if verbose:
                print(f"\n Processing: {file_path}")

            # Check if it's a YAML file (starts with ---)
            is_yaml = content.strip().startswith('---')

            if is_yaml:
                # YAML format: - dashboard: name
                dashboard_pattern = r'-\s*dashboard:\s*(\w+)'
                matches = list(re.finditer(dashboard_pattern, content))

                if verbose:
                    print(f"   Found {len(matches)} YAML dashboard(s)")

                for dashboard_match in matches:
                    dashboard_name = dashboard_match.group(1)
                    dashboards_checked += 1

                    # For YAML, the whole file is typically one dashboard
                    # Extract from the dashboard declaration to the end
                    dashboard_body = content[dashboard_match.start():]

                    query_count = _get_query_counts_yaml(dashboard_body, verbose=verbose)

                    if verbose:
                        print(f"   \n Dashboard: '{dashboard_name}'")
                        print(f"       \n Actual query EXECUTIONS: {query_count['total_executions']}")

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
                            print(f"       \n VIOLATION: {query_count['total_executions']} exceeds {max_queries}")
                    elif verbose:
                        print(f"       \n OK: Within limit")

            else:
                # LookML format: dashboard: name {
                dashboard_pattern = r'dashboard:\s*(\w+)\s*\{'
                matches = list(re.finditer(dashboard_pattern, content))

                if verbose:
                    print(f"   Found {len(matches)} LookML dashboard(s)")

                for dashboard_match in matches:
                    dashboard_name = dashboard_match.group(1)
                    dashboards_checked += 1

                    # Find matching closing brace
                    dashboard_end = find_matching_brace(content, dashboard_match.end() - 1)

                    if dashboard_end == -1:
                        if verbose:
                            print(f"   \n  Warning: Could not find closing brace for '{dashboard_name}'")
                        continue

                    dashboard_body = content[dashboard_match.end():dashboard_end]
                    query_count = _get_query_counts_yaml(dashboard_body, verbose=verbose)

                    if verbose:
                        print(f"   \n Dashboard: '{dashboard_name}'")
                        print(f"       \n Actual query EXECUTIONS: {query_count['total_executions']}")

                    if query_count['total_executions'] > max_queries:
                        violations.append({
                            'file': file_path,
                            'dashboard': dashboard_name,
                            'query_executions': query_count['total_executions'],
                            'max_allowed': max_queries,
                            'breakdown': query_count
                        })

                        if verbose:
                            print(f"       \n VIOLATION: {query_count['total_executions']} exceeds {max_queries}")
                    elif verbose:
                        print(f"       \n OK: Within limit")

        except Exception as e:
            if verbose:
                print(f"\n Error processing file {file_path}: {e}")
            continue

    return violations, dashboards_checked


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
                if filename not in files_to_audit:
                    files_to_audit.append(filename)

    if not files_to_audit:
        print("\n  No dashboard files found to audit.")
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
        print("\n Dashboard Query Limit Audit Failed")
        print(f"{'='*70}")
        print(f"Found {len(violations)} dashboard(s) exceeding query limit:\n")

        for v in violations:
            message = f"Dashboard '{v['dashboard']}' has {v['query_executions']} query executions (max: {v['max_allowed']})"
            print(f"::warning file={v['file']},title=Too Many Dashboard Queries::{message}")
            print(f"   \n {v['file']}")
            print(f"      Dashboard: {v['dashboard']}")
            print(f"       \n Query EXECUTIONS: {v['query_executions']}")
            print(f"      Limit: {v['max_allowed']}")
            print(f"      Breakdown:")
            print(f"         - Total tiles/elements: {v['breakdown']['total_elements']}")
            print(f"         - Named queries: {v['breakdown']['named_queries']}")
            print(f"         - Inline queries: {v['breakdown']['inline_queries']}")
            print()
        
        print(f"{'='*70}")
        print("\n Recommendations:")
        print("   1. Split large dashboards into multiple smaller dashboards")
        print("   2. Remove unnecessary tiles/queries")
        print("   3. Combine related visualizations")
        print("   4. Use named queries and reference them (more efficient)")
        print(f"{'='*70}\n")
        
        sys.exit(1)
    else:
        print(f"\n{'='*70}")
        print("\n Dashboard Query Limit Audit Passed")
        print(f"{'='*70}")
        print(f"\n Total dashboards checked: {dashboards_checked}")
        print(f"All dashboards have ≤ {args.max_queries} queries.")
        print(f"{'='*70}\n")
        
        sys.exit(0)


if __name__ == '__main__':
    main()
