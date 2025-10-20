#!/usr/bin/env python3
"""
Test: Find LookML Views Without Primary Keys Defined

Usage:
    python find_views_without_pk.py --files views/general_views/taxi_trips.view.lkml
"""

import re
import argparse
import os

def find_views_without_primary_keys(files):
    """
    Returns a list of (file, view_name) where the view has no primary_key defined.
    """
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
    parser = argparse.ArgumentParser(
        description='Find LookML views without primary keys'
    )
    parser.add_argument('--files', nargs='+', required=True,
                        help='List of LookML files to audit')
    args = parser.parse_args()

    missing_pks = find_views_without_primary_keys(args.files)
    if missing_pks:
        print("Views missing primary keys:")
        for file_path, view_name in missing_pks:
            print(f"  {file_path}: '{view_name}' has no primary_key defined")
        exit(1)
    else:
        print("All views have primary_key defined.")
        exit(0)

if __name__ == '__main__':
    main()
