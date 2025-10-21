#!/usr/bin/env python3
"""
LookML Orphaned Views Checker
Identifies views that are not used in any explore
"""

import json
import sys
import argparse
import os
import re
from typing import Dict, List, Set


class OrphanedViewsChecker:
    def __init__(self):
        self.results = {
            'orphaned_views': [],
            'files_processed': []
        }
        self.views = {}  # view_name: file_path
        self.explores = {}  # explore_name: {'file': path, 'base_view': name, 'joins': [view_names]}
   
    def process_file(self, file_path: str) -> None:
        """Process a single LookML file"""
        if not os.path.exists(file_path):
            print(f"⚠️  File not found: {file_path}")
            return
       
        self.results['files_processed'].append(file_path)
        print(f"🔍 Processing: {file_path}")
       
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
           
            # Collect views
            self.collect_views(file_path, content)
           
            # Collect explores
            self.collect_explores(file_path, content)
           
        except Exception as e:
            print(f"❌ Error processing {file_path}: {str(e)}")
   
    def collect_views(self, file_path: str, content: str) -> None:
        """Collect all view definitions"""
        # Pattern to match: view: view_name {
        view_pattern = r'view:\s*(\w+)\s*\{'
        view_matches = re.finditer(view_pattern, content)
       
        for match in view_matches:
            view_name = match.group(1)
            self.views[view_name] = file_path
            print(f"   📋 Found view: {view_name}")
   
    def collect_explores(self, file_path: str, content: str) -> None:
        """Collect all explore definitions and their referenced views"""
        # Pattern to match: explore: explore_name {
        explore_pattern = r'explore:\s*(\w+)\s*\{([^}]*(?:\{[^}]*\}[^}]*)*)\}'
        explore_matches = re.finditer(explore_pattern, content, re.DOTALL)
       
        for match in explore_matches:
            explore_name = match.group(1)
            explore_content = match.group(2)
           
            print(f"   🔎 Found explore: {explore_name}")
           
            # The base view is typically the explore name itself
            base_view = explore_name
           
            # Also check for explicit from: parameter
            from_match = re.search(r'from:\s*(\w+)', explore_content)
            if from_match:
                base_view = from_match.group(1)
                print(f"      → Base view (from:): {base_view}")
            else:
                print(f"      → Base view (implicit): {base_view}")
           
            # Find all joins in this explore
            joins = []
            join_pattern = r'join:\s*(\w+)\s*\{'
            join_matches = re.finditer(join_pattern, explore_content)
           
            for join_match in join_matches:
                join_view = join_match.group(1)
                joins.append(join_view)
                print(f"      → Joined view: {join_view}")
           
            # Store explore info
            self.explores[explore_name] = {
                'file': file_path,
                'base_view': base_view,
                'joins': joins
            }
   
    def find_orphaned_views(self) -> List[Dict]:
        """Identify views that are not used in any explore"""
        print(f"\n{'='*70}")
        print("🔍 Analyzing view usage...")
        print(f"{'='*70}")
       
        # Collect all views used in explores
        used_views = set()
       
        for explore_name, explore_info in self.explores.items():
            # Add base view
            used_views.add(explore_info['base_view'])
           
            # Add all joined views
            for join_view in explore_info['joins']:
                used_views.add(join_view)
       
        print(f"\n📊 Statistics:")
        print(f"   Total views found: {len(self.views)}")
        print(f"   Total explores found: {len(self.explores)}")
        print(f"   Views used in explores: {len(used_views)}")
       
        # Find orphaned views
        orphaned = []
       
        for view_name, view_file in self.views.items():
            if view_name not in used_views:
                orphaned.append({
                    'view_name': view_name,
                    'file': view_file
                })
       
        self.results['orphaned_views'] = orphaned
       
        return orphaned
   
    def print_report(self) -> None:
        """Print the orphaned views report"""
        orphaned = self.results['orphaned_views']
       
        print(f"\n{'='*70}")
        print("📋 ORPHANED VIEWS REPORT")
        print(f"{'='*70}")
       
        if not orphaned:
            print("\n✅ Great! No orphaned views found.")
            print("   All views are being used in at least one explore.")
        else:
            print(f"\n⚠️  Found {len(orphaned)} orphaned view(s):")
            print(f"{'='*70}")
           
            for item in orphaned:
                print(f"\n📌 View: {item['view_name']}")
                print(f"   File: {item['file']}")
                print(f"   Status: Not used in any explore")
           
            print(f"\n{'='*70}")
            print("💡 Recommendations:")
            print("   1. Remove unused views to reduce code clutter")
            print("   2. Add views to an explore if they should be queryable")
            print("   3. Mark as hidden: yes if intentionally unused")
            print(f"{'='*70}")
   
    def save_results(self, output_file: str = 'orphaned_views.json') -> None:
        """Save results to JSON file"""
        try:
            output = {
                'summary': {
                    'files_processed': len(self.results['files_processed']),
                    'total_views': len(self.views),
                    'total_explores': len(self.explores),
                    'orphaned_count': len(self.results['orphaned_views'])
                },
                'orphaned_views': self.results['orphaned_views'],
                'all_views': [{'name': name, 'file': file} for name, file in self.views.items()],
                'all_explores': [
                    {
                        'name': name,
                        'file': info['file'],
                        'base_view': info['base_view'],
                        'joins': info['joins']
                    }
                    for name, info in self.explores.items()
                ]
            }
           
            with open(output_file, 'w') as f:
                json.dump(output, f, indent=2)
           
            print(f"\n📄 Results saved to: {output_file}")
        except Exception as e:
            print(f"\n❌ Failed to save results: {e}")


def main():
    parser = argparse.ArgumentParser(
        description='Identify orphaned LookML views (not used in any explore)'
    )
    parser.add_argument(
        '--files',
        required=True,
        help='Space-separated list of LookML files to check'
    )
    parser.add_argument(
        '--output-file',
        default='orphaned_views.json',
        help='Output file for results (default: orphaned_views.json)'
    )
   
    args = parser.parse_args()
   
    files_to_check = args.files.split()
   
    print(f"{'='*70}")
    print("🚀 LookML Orphaned Views Checker")
    print(f"{'='*70}")
    print(f"Files to process: {len(files_to_check)}\n")
   
    checker = OrphanedViewsChecker()
   
    # Process all files
    valid_extensions = ('.view.lkml', '.model.lkml', '.explore.lkml',
                       '.view', '.model', '.explore', '.lkml', '.lookml')
   
    for file_path in files_to_check:
        if file_path.endswith(valid_extensions) or 'manifest.lkml' in file_path:
            checker.process_file(file_path)
        else:
            print(f"⏭️  Skipping: {file_path}")
   
    # Find orphaned views
    orphaned_views = checker.find_orphaned_views()
   
    # Print report
    checker.print_report()
   
    # Save results
    checker.save_results(args.output_file)
   
    # Exit with appropriate code
    if len(orphaned_views) > 0:
        print(f"\n⚠️  Check complete: {len(orphaned_views)} orphaned view(s) found")
        sys.exit(0)  # Success but with findings
    else:
        print("\n✅ Check complete: No orphaned views found")
        sys.exit(0)


if __name__ == '__main__':
    main()
