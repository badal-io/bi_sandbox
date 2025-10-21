#!/usr/bin/env python3
import re
import sys
import os
import glob # Useful for file discovery

def test_only_many_to_one_joins(files):

    for file_path in files:
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            for explore_match in re.finditer(pattern_explore, content, re.DOTALL):
                explore_name = explore_match.group(1)
                explore_body = explore_match.group(2)
                
                for join_match in re.finditer(pattern_join, explore_body, re.DOTALL):
                    join_name = join_match.group(1)
                    join_body = join_match.group(2)
                    
                    # Remember to apply the re.MULTILINE fix for relationship_pattern
                    rel_match = re.search(relationship_pattern, join_body, re.MULTILINE) 
                    
                    if rel_match:
                        relationship_type = rel_match.group(1)
                        if relationship_type != "many_to_one":
                            violations.append((file_path, explore_name, join_name, relationship_type))
                    else:
                        violations.append((file_path, explore_name, join_name, "MISSING"))

        except FileNotFoundError:
            # If the file isn't found, we just print a warning and continue to the next file.
            print(f"Warning: File not found at {file_path}. Skipping.")
            continue
        except Exception as e:
            # Catch other potential reading/encoding errors
            print(f"Error processing file {file_path}: {e}")
            continue
            
    return violations

## The Main Execution Block

def main():
    # 1. FILE DISCOVERY & ARGUMENT HANDLING
    # This is a simplified way to find all model files for demonstration.
    # In a real script, you'd use the --project-name argument as the base path.
    project_root = "." 
    files_to_audit = []
    
    # Find all .model.lkml and .explore.lkml files recursively
    for filename in glob.iglob(project_root + '/**/*.lkml', recursive=True):
        if filename.endswith(('.model.lkml', '.explore.lkml')):
            files_to_audit.append(filename)

    if not files_to_audit:
        print("No LookML files found to audit.")
        sys.exit(0) # Success if nothing to check
    
    # 2. AUDIT EXECUTION
    violations = test_only_many_to_one_joins(files_to_audit)

    # 3. REPORTING AND EXIT CODE (Your provided code goes here)
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
    main()
