#!/usr/bin/env python3
"""
Check validation results and exit with appropriate code
"""

import json
import os
import sys

def main():
    """Check validation results and exit with error code if needed"""
    
    total_errors = 0
    
    # Check validation results
    if os.path.exists('validation_results.json'):
        try:
            with open('validation_results.json', 'r') as f:
                validation_data = json.load(f)
            
            validation_errors = len(validation_data.get('errors', []))
            total_errors += validation_errors
            
            if validation_errors > 0:
                print(f"❌ Found {validation_errors} validation errors")
            else:
                print("✅ No validation errors found")
                
        except Exception as e:
            print(f"⚠️ Could not read validation results: {e}")
    else:
        print("ℹ️ No validation results file found")
    
    # Check linting results
    if os.path.exists('linting_results.json'):
        try:
            with open('linting_results.json', 'r') as f:
                linting_data = json.load(f)
            
            linting_errors = len(linting_data.get('errors', []))
            total_errors += linting_errors
            
            if linting_errors > 0:
                print(f"❌ Found {linting_errors} linting errors")
            else:
                print("✅ No linting errors found")
                
        except Exception as e:
            print(f"⚠️ Could not read linting results: {e}")
    else:
        print("ℹ️ No linting results file found")
    
    # Final result
    if total_errors > 0:
        print(f"\n❌ LookML validation failed with {total_errors} total errors")
        sys.exit(1)
    else:
        print(f"\n✅ LookML validation passed!")
        sys.exit(0)

if __name__ == '__main__':
    main()
