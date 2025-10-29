#!/usr/bin/env python3
"""
LookML Join Relationship Auditor
Checks that all join relationships are 'many_to_one'
Flags 'one_to_one', 'one_to_many', 'many_to_many', and MISSING as violations
"""

import re
import sys
import os
import glob
import argparse


def test_only_many_to_one_joins(files, verbose=False):
    """
    Checks that all join relationships in explores are 'many_to_one'.
    Flags 'one_to_one', 'one_to_many', 'many_to_many', and MISSING as violations.
    """
    # Pattern to find explore blocks (handles nested braces)
    pattern_explore = r'explore:\s*(\w+)\s*\{'
    
    # Pattern to find join blocks within explores
    pattern_join = r'join:\s*(\w+)\s*\{'
    
    # Improved relationship pattern - more flexible with whitespace
    # Matches: relationship: one_to_one, relationship:one_to_one, etc.
    relationship_pattern = r'relationship:\s*(\w+)'
    
    violations = []
    total_joins_checked = 0

    if verbose:
        print(f"\n{'='*70}")
        print("🔍 Starting Join Relationship Audit")
        print(f"{'='*70}\n")

    for file_path in files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            if verbose:
                print(f"📄 Processing: {file_path}")
            
            # Find all explore blocks
            explore_positions = []
            for explore_match in re.finditer(pattern_explore, content):
                explore_name = explore_match.group(1)
                explore_start = explore_match.start()
                
                # Find the matching closing brace for this explore
                explore_end = find_matching_brace(content, explore_match.end() - 1)
                
                if explore_end == -1:
                    if verbose:
                        print(f"   ⚠️  Warning: Could not find closing brace for explore '{explore_name}'")
                    continue
                
                explore_body = content[explore_match.end():explore_end]
                explore_positions.append({
                    'name': explore_name,
                    'body': explore_body,
                    'start': explore_start,
                    'end': explore_end
                })
            
            # Process each explore
            for explore_info in explore_positions:
                explore_name = explore_info['name']
                explore_body = explore_info['body']
                
                if verbose:
                    print(f"   🔎 Explore: '{explore_name}'")
                
                # Find all join blocks in this explore
                join_positions = []
                for join_match in re.finditer(pattern_join, explore_body):
                    join_name = join_match.group(1)
                    join_start = join_match.start()
                    
                    # Find the matching closing brace for this join
                    join_end = find_matching_brace(explore_body, join_match.end() - 1)
                    
                    if join_end == -1:
                        if verbose:
                            print(f"      ⚠️  Warning: Could not find closing brace for join '{join_name}'")
                        continue
                    
                    join_body = explore_body[join_match.end():join_end]
                    join_positions.append({
                        'name': join_name,
                        'body': join_body
                    })
                
                # Check each join for relationship
                for join_info in join_positions:
                    join_name = join_info['name']
                    join_body = join_info['body']
                    total_joins_checked += 1
                    
                    if verbose:
                        print(f"      → Join: '{join_name}'")
                    
                    # Search for relationship declaration
                    rel_match = re.search(relationship_pattern, join_body, re.IGNORECASE)
                    
                    if rel_match:
                        relationship_type = rel_match.group(1).lower()
                        
                        if verbose:
                            print(f"         Relationship: {relationship_type}")
                        
                        # Check if it's NOT many_to_one
                        if relationship_type != "many_to_one":
                            violations.append({
                                'file': file_path,
                                'explore': explore_name,
                                'join': join_name,
                                'relationship': relationship_type
                            })
                            
                            if verbose:
                                print(f"         ⚠️ Warning: Expected 'many_to_one', found '{relationship_type}'")
                    else:
                        # Missing relationship declaration
                        violations.append({
                            'file': file_path,
                            'explore': explore_name,
                            'join': join_name,
                            'relationship': 'MISSING'
                        })
                        
                        if verbose:
                            print(f"         ⚠️ Warning: Relationship declaration MISSING")
        
        except FileNotFoundError:
            print(f"⚠️  Warning: File not found at {file_path}. Skipping.")
            continue
        except Exception as e:
            print(f"⚠️ Warning processing file {file_path}: {e}")
            continue
    
    if verbose:
        print(f"\n{'='*70}")
        print(f"📊 Total joins checked: {total_joins_checked}")
        print(f"{'='*70}\n")
    
    return violations


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
        description='Audit LookML joins to ensure all use many_to_one relationships'
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
        # Find all .model.lkml and .explore.lkml files recursively
        project_root = args.project_name
        
        for pattern in ['**/*.model.lkml', '**/*.explore.lkml', '**/*.lkml']:
            for filename in glob.iglob(os.path.join(project_root, pattern), recursive=True):
                if filename not in files_to_audit:
                    # Check if it's a model or explore file
                    if filename.endswith(('.model.lkml', '.explore.lkml')) or 'explore' in filename.lower():
                        files_to_audit.append(filename)
    
    if not files_to_audit:
        print("⚠️  No LookML files found to audit.")
        sys.exit(0)
    
    if args.verbose:
        print(f"Files to audit ({len(files_to_audit)}):")
        for f in files_to_audit:
            print(f"  - {f}")
    
    # RUN AUDIT
    violations = test_only_many_to_one_joins(files_to_audit, verbose=args.verbose)

    # Write summary JSON
    summary = {
        "joins_with_invalid_relationship": len(violations),
        "total_joins_checked": sum(1 for v in violations),
        "violations": violations
    }
    with open("join_relationship_results.json", "w") as f:
        json.dump(summary, f, indent=2)
        
    # REPORTING
    if violations:
        print(f"\n{'='*70}")
        print("⚠️ Warning LookML Join Audit Failed")
        print(f"{'='*70}")
        print(f"Found {len(violations)} violation(s):\n")
        
        for v in violations:
            message = f"Explore '{v['explore']}', Join '{v['join']}' → Relationship: {v['relationship']}"
            
            # GitHub Actions annotation format
            print(f"::error file={v['file']},title=Invalid Join Relationship::{message}")
            
            # Also print readable format
            print(f"   📍 {v['file']}")
            print(f"      Explore: {v['explore']}")
            print(f"      Join: {v['join']}")
            print(f"      Issue: Relationship is '{v['relationship']}' (must be 'many_to_one')")
            print()
        
        print(f"{'='*70}")
        print("💡 Fix: Change all join relationships to 'many_to_one' or add missing declarations")
        print(f"{'='*70}\n")
        
        sys.exit(1)  # Fail the check
    
    else:
        print(f"\n{'='*70}")
        print("✅ LookML Join Audit Passed")
        print(f"{'='*70}")
        print("All joins use 'many_to_one' relationships.")
        print(f"{'='*70}\n")
        
        sys.exit(0)  # Pass the check


if __name__ == '__main__':
    main()
