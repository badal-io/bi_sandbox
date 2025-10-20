#!/usr/bin/env python3
"""
Test: Find LookML Views Without Primary Keys Defined
Usage: python find_views_without_pk.py --files views/general_views/taxi_trips.view.lkml
"""

import re
import argparse
import os
import glob
import sys

def find_views_without_primary_keys(files):
    missing_pk = []
    view_pattern = r'view:\s*(\w+)\s*\{([^}]*(?:\{[^}]*\}[^}]*)*)\}'
    pk_pattern = r'primary_key:\s*yes'

    for file_path in files:
        if not os.path.exists(file_path):
            print(f"File not found: {file_path}")
            continue

        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()

        for match in re.finditer(view_pattern, content, re.DOTALL):
            view_name = match.group(1)
            view_body = match.group(2)
            if not re.search(pk_pattern, view_body):
                missing_pk.append((file_path, view_name))
    return missing_pk

def main():
    parser = argparse.ArgumentParser(description='Find LookML views without primary keys in a project')
    parser.add_argument('--project-name', required=True, help='Looker project name to audit')
    args = parser.parse_args()

    project_name = args.project_name

    # Assume project name corresponds to a directory structure,
    # e.g. project "bi_sandbox" has views in "bi_sandbox/views/*.lkml"
    base_path = os.path.join(project_name, 'views')
    pattern = os.path.join(base_path, '**', '*.view.lkml')

    files_to_audit = glob.glob(pattern, recursive=True)
    if not files_to_audit:
        print(f"No LookML files found for project '{project_name}' at {pattern}")
        sys.exit(1)

    print(f"Auditing {len(files_to_audit)} LookML files in project '{project_name}'...")
    missing_pks = find_views_without_primary_keys(files_to_audit)

    if missing_pks:
        print(f"Views missing primary keys:")
        for file_path, view_name in missing_pks:
            print(f"  {file_path}: '{view_name}' has no primary_key defined")
        sys.exit(1)
    else:
        print("All views have primary_key defined.")
        sys.exit(0)

if __name__ == '__main__':
    main()
