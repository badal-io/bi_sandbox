#!/usr/bin/env python3
"""
LookML Dashboard Filter Validator
Checks that YAML dashboards have at least one filter defined
"""

import re
import sys
import os
import glob
import argparse
import yaml


def check_dashboard_has_filters(files, verbose=False):
    """
    Checks that YAML dashboard files have at least one filter defined.
    Returns list of dashboards without filters.
    """
    violations = []
    dashboards_checked = 0
    
    if verbose:
        print(f"\n{'='*70}")
        print("🔍 Starting Dashboard Filter Validation")
        print(f"{'='*70}\n")
    
    for file_path in files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if verbose:
                print(f"📄 Processing: {file_path}")
            
            # Check if it's a YAML file (starts with ---)
            is_yaml = content.strip().startswith('---')
            
            if not is_yaml:
                if verbose:
                    print(f"   ⏭️  Skipping: Not a YAML dashboard file")
                continue
            
            # Parse YAML content
            try:
                # Remove the --- prefix if present
                yaml_content = content.strip()
                if yaml_content.startswith('---'):
                    yaml_content = yaml_content[3:].strip()
                
                # Parse YAML
                dashboard_data = yaml.safe_load(yaml_content)
                
                if not dashboard_data:
                    if verbose:
                        print(f"   ⚠️  Warning: Could not parse YAML content")
                    continue
                
                # Handle both list format and dict format
                if isinstance(dashboard_data, list):
                    dashboards = dashboard_data
                elif isinstance(dashboard_data, dict):
                    # Single dashboard in dict format
                    dashboards = [dashboard_data]
                else:
                    if verbose:
                        print(f"   ⚠️  Warning: Unexpected YAML structure")
                    continue
                
                # Check each dashboard
                for dashboard in dashboards:
                    if not isinstance(dashboard, dict):
                        continue
                    
                    # Get dashboard name
                    dashboard_name = dashboard.get('dashboard', 'Unknown')
                    dashboards_checked += 1
                    
                    if verbose:
                        print(f"   🔎 Dashboard: '{dashboard_name}'")
                    
                    # Check for filters section
                    filters = dashboard.get('filters', [])
                    
                    if not filters or len(filters) == 0:
                        # No filters defined
                        violations.append({
                            'file': file_path,
                            'dashboard': dashboard_name,
                            'issue': 'No filters defined'
                        })
                        
                        if verbose:
                            print(f"      ⚠️ Warning: No filters defined")
                    else:
                        # Has filters
                        filter_count = len(filters)
                        filter_names = [f.get('name', 'unnamed') for f in filters if isinstance(f, dict)]
                        
                        if verbose:
                            print(f"      ✅ OK: {filter_count} filter(s) defined")
                            for fname in filter_names:
                                print(f"         - {fname}")
            
            except yaml.YAMLError as e:
                if verbose:
                    print(f"   ⚠️  Warning: YAML parsing error: {e}")
                
                # Fallback to regex-based detection
                if verbose:
                    print(f"   🔄 Attempting regex-based detection...")
                
                # Find dashboard name using regex
                dashboard_match = re.search(r'-?\s*dashboard:\s*(\w+)', content)
                if dashboard_match:
                    dashboard_name = dashboard_match.group(1)
                    dashboards_checked += 1
                    
                    if verbose:
                        print(f"   🔎 Dashboard: '{dashboard_name}' (regex)")
                    
                    # Check for filters section using regex
                    filters_match = re.search(r'\nfilters:\s*\n\s*-\s+name:', content)
                    
                    if not filters_match:
                        violations.append({
                            'file': file_path,
                            'dashboard': dashboard_name,
                            'issue': 'No filters defined'
                        })
                        
                        if verbose:
                            print(f"      ⚠️ Warning: No filters defined (regex)")
                    else:
                        # Count filters using regex
                        filter_count = len(re.findall(r'\n\s*-\s+name:\s+', content))
                        if verbose:
                            print(f"      ✅ OK: ~{filter_count} filter(s) detected (regex)")
                else:
                    if verbose:
                        print(f"   ⚠️  Could not detect dashboard name")
        
        except FileNotFoundError:
            print(f"⚠️  Warning: File not found at {file_path}. Skipping.")
            continue
        except Exception as e:
            print(f"⚠️ Warning processing file {file_path}: {e}")
            if verbose:
                import traceback
                traceback.print_exc()
            continue
    
    if verbose:
        print(f"\n{'='*70}")
        print(f"📊 Total dashboards checked: {dashboards_checked}")
        print(f"{'='*70}\n")
    
    return violations, dashboards_checked


def main():
    parser = argparse.ArgumentParser(
        description='Validate that LookML YAML dashboards have at least one filter defined'
    )
    parser.add_argument(
        '--project-name',
        default='.',
        help='Project root directory (default: current directory)'
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
    
    args = parser.parse_args()
    
    # FILE DISCOVERY
    files_to_audit = []
    
    if args.files:
        # Use specific files provided
        files_to_audit = args.files.split()
    else:
        # Find all .dashboard.lookml files recursively
        project_root = args.project_name
        
        patterns = [
            '**/*.dashboard.lookml',
            '**/dashboards/*.lookml',
            'Dashboards/*.lookml'
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
    violations, dashboards_checked = check_dashboard_has_filters(
        files_to_audit,
        verbose=args.verbose
    )
    
    # Write summary JSON
    summary = {
        "dashboards_missing_filters": len(violations),
        "total_dashboards_checked": dashboards_checked,
        "violations": violations
    }
    with open("dashboard_filters_results.json", "w") as f:
        json.dump(summary, f, indent=2)    
    
    # REPORTING
    if violations:
        print(f"\n{'='*70}")
        print("⚠️ Warning - Dashboard Filter Validation Failed")
        print(f"{'='*70}")
        print(f"Found {len(violations)} dashboard(s) without filters:\n")
        
        for v in violations:
            message = f"Dashboard '{v['dashboard']}' has no filters defined"
            
            # GitHub Actions annotation format
            print(f"::error file={v['file']},title=Missing Dashboard Filters::{message}")
            
            # Also print readable format
            print(f"   📍 {v['file']}")
            print(f"      Dashboard: {v['dashboard']}")
            print(f"      Issue: {v['issue']}")
            print()
        
        print(f"{'='*70}")
        print("💡 Recommendations:")
        print("   1. Add at least one filter to each dashboard for better user experience")
        print("   2. Filters help users narrow down data and improve query performance")
        print("   3. Common filters include date ranges, categories, and dimensions")
        print("   4. Example filter structure:")
        print("      filters:")
        print("      - name: Date Range")
        print("        title: Date Range")
        print("        type: field_filter")
        print("        default_value: 'this year'")
        print("        model: your_model")
        print("        explore: your_explore")
        print("        field: your_field.date")
        print(f"{'='*70}\n")
        
        sys.exit(1)  # Fail the check
    
    else:
        print(f"\n{'='*70}")
        print("✅ Dashboard Filter Validation Passed")
        print(f"{'='*70}")
        print(f"✅ Total dashboards checked: {dashboards_checked}")
        print("All dashboards have at least one filter defined.")
        print(f"{'='*70}\n")
        
        sys.exit(0)  # Pass the check


if __name__ == '__main__':
    main()
