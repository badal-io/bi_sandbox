#!/usr/bin/env python3
"""
Find LookML Views Without Primary Keys Defined

Usage:
  python lookml-audit.py --project-name="."
  # or: --project-name path/to/repo/root
"""

import re
import argparse
import os
import glob
import sys
import json  # <-- ADDED

VIEW_BLOCK_RE = re.compile(r'view:\s*(\w+)\s*\{([^}]*(?:\{[^}]*\}[^}]*)*)\}', re.DOTALL)
PRIMARY_KEY_RE = re.compile(r'primary_key:\s*yes\b')

def collect_lookml_files(project_root: str) -> list[str]:
    patterns = [
        os.path.join(project_root, "views", "**", "*.view.lkml"),
        os.path.join(project_root, "views", "**", "*.view"),
    ]
    files: list[str] = []
    for p in patterns:
        files.extend(glob.glob(p, recursive=True))
    # de-dupe & sort for stable output
    return sorted(set(files))

def find_views_without_primary_keys(files: list[str]) -> list[tuple[str, str]]:
    missing_pk: list[tuple[str, str]] = []
    for file_path in files:
        if not os.path.exists(file_path):
            print(f"File not found: {file_path}")
            continue
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()
        for match in VIEW_BLOCK_RE.finditer(content):
            view_name = match.group(1)
            view_body = match.group(2)
            if not PRIMARY_KEY_RE.search(view_body):
                missing_pk.append((file_path, view_name))
    return missing_pk

def main():
    parser = argparse.ArgumentParser(description="Find LookML views without primary keys in a project")
    parser.add_argument("--project-name", required=True, help="Path to the Looker project root (use '.' for repo root)")
    args = parser.parse_args()

    # If a folder named exactly as project-name doesn't exist, assume current dir
    project_root = args.project_name if os.path.isdir(args.project_name) else "."

    files_to_audit = collect_lookml_files(project_root)

    # --- ADDED: Always write a valid JSON file, even if no files found ---
    if not files_to_audit:
        summary = {
            "views_missing_primary_key": 0,
            "total_views_checked": 0,
            "missing_primary_keys": []
        }
        with open("primary_key_results.json", "w") as f:
            json.dump(summary, f, indent=2)
        print(f"No LookML files found under {project_root}/views (looked for *.view.lkml and *.view)")
        sys.exit(1)
    # ---------------------------------------------------------------------

    print(f"Auditing {len(files_to_audit)} LookML files in project root '{project_root}'...")
    missing_pks = find_views_without_primary_keys(files_to_audit)

    # Write summary JSON before exit
    summary = {
        "views_missing_primary_key": len(missing_pks),
        "total_views_checked": len(files_to_audit),
        "missing_primary_keys": [
            {"file": file_path, "view": view_name} for file_path, view_name in missing_pks
        ]
    }
    with open("primary_key_results.json", "w") as f:
        json.dump(summary, f, indent=2)
      
    if missing_pks:
        print("Views missing primary_key:")
        for file_path, view_name in missing_pks:
            print(f"  {file_path}: '{view_name}' has no primary_key: yes")
        sys.exit(1)
    else:
        print("All views have primary_key defined.")
        sys.exit(0)

if __name__ == "__main__":
    main()
