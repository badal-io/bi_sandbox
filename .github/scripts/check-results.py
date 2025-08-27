#!/usr/bin/env python3
"""
Check validation results and exit with appropriate code (Updated with Content Validation support)
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
    
    # Check data tests results
    if os.path.exists('data_tests_results.json'):
        try:
            with open('data_tests_results.json', 'r') as f:
                data_tests_data = json.load(f)
            
            test_summary = data_tests_data.get('summary', {})
            failed_models = test_summary.get('failed_models', 0)
            failed_tests = test_summary.get('failed_tests', 0)
            data_test_errors = failed_models + failed_tests
            
            total_errors += data_test_errors
            
            if data_test_errors > 0:
                print(f"❌ Found {failed_models} failed models and {failed_tests} failed data tests")
            else:
                print("✅ All data tests passed")
                
        except Exception as e:
            print(f"⚠️ Could not read data tests results: {e}")
    else:
        print("ℹ️ No data tests results file found")
    
    # Check content validation results
    if os.path.exists('content_validation_results.json'):
        try:
            with open('content_validation_results.json', 'r') as f:
                content_validation_data = json.load(f)
            
            content_summary = content_validation_data.get('summary', {})
            content_errors = content_summary.get('bi_sandbox_errors', 0)
            
            total_errors += content_errors
            
            if content_errors > 0:
                print(f"❌ Found {content_errors} content validation errors in BI Sandbox")
            else:
                print("✅ Content validation passed")
                
        except Exception as e:
            print(f"⚠️ Could not read content validation results: {e}")
    else:
        print("ℹ️ No content validation results file found")
    
    # Final result
    if total_errors > 0:
        print(f"\n❌ LookML validation failed with {total_errors} total errors")
        sys.exit(1)
    else:
        print(f"\n✅ All LookML validations passed!")
        sys.exit(0)

if __name__ == '__main__':
    main()
