#!/usr/bin/env python3
import re
import sys
import os
import glob 

def test_only_many_to_one_joins(files):
    """
    Checks that all join relationships in explores are 'many_to_one'.
    Returns a list of (file, explore_name, join_name, found_relationship) for violations.
    
    NOTE: Temporary print statements are included for debugging regex issues.
    """
    # 1. INITIALIZE PATTERNS AND VIOLATIONS LIST
    
    # Pattern to find the explore block (designed to handle nested braces)
    pattern_explore = r'explore:\s*(\w+)\s*\{([^}]*(?:\{[^}]*\}[^}]*)*)\}'
    
    # Pattern to find the join block within an explore block
    pattern_join = r'join:\s*(\w+)\s*\{([^}]*)\}'
    
    # Robust pattern for the relationship property using line anchors (requires re.MULTILINE)
    relationship_pattern = r'^\s*relationship:\s*(\w+)\s*$' 
    
    violations = []

    # 2. FILE ITERATION AND CONTENT PROCESSING
    for file_path in files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            # All content processing happens inside the try block
            for explore_match in re.finditer(pattern_explore, content, re.DOTALL):
                explore_name = explore_match.group(1)
                explore_body = explore_match.group(2)
                
                # DEBUG: Check if explore was captured
                print(f"DEBUG: Found Explore '{explore_name}' in {file_path}") 
                
                for join_match in re.finditer(pattern_join, explore_body, re.DOTALL):
                    join_name = join_match.group(1)
                    join_body = join_match.group(2)
                    
                    # DEBUG: Check if join was captured
                    print(f"DEBUG:   Found Join '{join_name}'. Snippet: {join_body.strip()[:60]}...")
                    
                    # Use re.MULTILINE for the anchored relationship pattern
                    rel_match = re.search(relationship_pattern, join_body, re.MULTILINE) 
                    
                    if rel_match:
                        relationship_type = rel_match.group(1)
                        # DEBUG: Report the found relationship type
                        print(f"DEBUG:     Relationship found: {relationship_type}") 
                        
                        if relationship_type != "many_to_one":
                            violations.append((file_path, explore_name, join_name, relationship_type))
                    else:
                        # DEBUG: Relationship was not found by the regex
                        print(f"DEBUG:     Relationship: MISSING/FAILED TO MATCH")
                        violations.append((file_path, explore_name, join_name, "MISSING"))

        except FileNotFoundError:
            print(f"Warning: File not found at {file_path}. Skipping.")
            continue
        except Exception as e:
            print(f"Error processing file {file_path}: {e}")
            continue
            
    return violations

## The Main Execution Block

def main():
    # 1. FILE DISCOVERY (Simplified for demonstration)
    project_root = "." 
    files_to_audit = []
    
    # Find all .model.lkml and .explore.lkml files recursively
    for filename in glob.iglob(project_root + '/**/*.lkml', recursive=True):
        if filename.endswith(('.model.lkml', '.explore.lkml')):
            files_to_audit.append(filename)

    if not files_to_audit:
        print("No LookML files found to audit.")
        sys.exit(0)
    
    # 2. AUDIT EXECUTION
    violations = test_only_many_to_one_joins(files_to_audit)

    # 3. REPORTING AND EXIT CODE
    if violations:
        print("\n❌ LookML Join Audit Failed: The following joins are NOT many_to_one or are missing a relationship:\n")
        
        for file_path, explore, join, found in violations:
            message = f"In Explore '{explore}', Join '{join}' has relationship: {found}"
            # Use GitHub Annotation format for better visibility
            print(f"::error file={file_path},title=LookML Join Audit Error:: {message}")
            
        sys.exit(1) # Fail the GitHub Action

    else:
        print("✅ LookML Join Audit Passed: All joins use many_to_one relationships only.")
        sys.exit(0) # Pass the GitHub Action

if __name__ == '__main__':
    # Add a check for the old --project-name argument for compatibility
    if '--project-name' in sys.argv:
        print("Note: '--project-name' argument is currently ignored in favor of scanning '.' recursively.")
    main()
