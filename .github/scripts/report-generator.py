# Updated .github/scripts/report-generator.py
"""
Generate validation reports for GitHub Actions (Updated with Data Tests support)
"""

import json
import os
import sys

def generate_github_summary():
    """Generate GitHub Actions step summary"""
    
    summary_lines = []
    summary_lines.append("## LookML Validation Report\n")
    
    # Read validation results
    validation_data = {}
    if os.path.exists('validation_results.json'):
        try:
            with open('validation_results.json', 'r') as f:
                validation_data = json.load(f)
        except Exception as e:
            print(f"Warning: Could not read validation results: {e}")
    
    # Read linting results
    linting_data = {}
    if os.path.exists('linting_results.json'):
        try:
            with open('linting_results.json', 'r') as f:
                linting_data = json.load(f)
        except Exception as e:
            print(f"Warning: Could not read linting results: {e}")
    
    # Read data tests results
    data_tests_data = {}
    if os.path.exists('data_tests_results.json'):
        try:
            with open('data_tests_results.json', 'r') as f:
                data_tests_data = json.load(f)
        except Exception as e:
            print(f"Warning: Could not read data tests results: {e}")
    
    # Add files processed
    summary_lines.append("### Files Processed:")
    files_processed = set()
    files_processed.update(validation_data.get('files_processed', []))
    files_processed.update(linting_data.get('files_processed', []))
    
    if files_processed:
        for file in sorted(files_processed):
            summary_lines.append(f"- {file}")
    else:
        summary_lines.append("- No files processed")
    
    summary_lines.append("")
    
    # Validation results
    summary_lines.append("### Validation Results:")
    validation_errors = validation_data.get('errors', [])
    if validation_errors:
        summary_lines.append("#### Syntax Errors:")
        for error in validation_errors:
            summary_lines.append(f"- {error}")
    else:
        summary_lines.append("#### ✓ No syntax errors found!")
    
    summary_lines.append("")
    
    # Linting results
    linting_errors = linting_data.get('errors', [])
    linting_warnings = linting_data.get('warnings', [])
    
    if linting_errors:
        summary_lines.append("#### Linting Errors:")
        for error in linting_errors:
            summary_lines.append(f"- {error}")
    
    if linting_warnings:
        summary_lines.append("#### Linting Warnings:")
        for warning in linting_warnings:
            summary_lines.append(f"- {warning}")
    
    if not linting_errors and not linting_warnings:
        summary_lines.append("#### ✓ No linting issues found!")
    
    summary_lines.append("")
    
    # Data tests results
    summary_lines.append("### Data Tests Results:")
    if data_tests_data and data_tests_data.get('summary'):
        test_summary = data_tests_data['summary']
        
        # Model validation summary
        if test_summary.get('total_models', 0) > 0:
            summary_lines.append(f"#### Model Validation:")
            summary_lines.append(f"- Total models: {test_summary['total_models']}")
            summary_lines.append(f"- Passed: {test_summary['passed_models']}")
            summary_lines.append(f"- Failed: {test_summary['failed_models']}")
            
            if test_summary['failed_models'] > 0:
                summary_lines.append("- **Failed Models:**")
                for model in data_tests_data.get('model_validation', []):
                    if model.get('status') != 'success':
                        summary_lines.append(f"  - {model.get('model', 'Unknown')}: {len(model.get('errors', []))} errors")
        
        # LookML tests summary
        if test_summary.get('total_tests', 0) > 0:
            summary_lines.append(f"#### LookML Tests:")
            summary_lines.append(f"- Total tests: {test_summary['total_tests']}")
            summary_lines.append(f"- Passed: {test_summary['passed_tests']}")
            summary_lines.append(f"- Failed: {test_summary['failed_tests']}")
            summary_lines.append(f"- Warnings: {test_summary['warnings']}")
            
            if test_summary['failed_tests'] > 0:
                summary_lines.append("- **Failed Tests:**")
                for test in data_tests_data.get('data_tests', []):
                    if test.get('status') == 'error':
                        test_name = test.get('test_name', 'Unknown')
                        model_name = test.get('model_name', 'Unknown')
                        explore_name = test.get('explore_name', 'Unknown')
                        summary_lines.append(f"  - {test_name} ({model_name}.{explore_name})")
    else:
        summary_lines.append("#### No data tests executed")
    
    # Write to GitHub Actions step summary
    summary_content = "\n".join(summary_lines)
    
    github_step_summary = os.environ.get('GITHUB_STEP_SUMMARY')
    if github_step_summary:
        try:
            with open(github_step_summary, 'a') as f:
                f.write(summary_content)
            print("GitHub step summary updated")
        except Exception as e:
            print(f"Failed to write GitHub step summary: {e}")
    else:
        print("GITHUB_STEP_SUMMARY not set, printing to console:")
        print(summary_content)
    
    # Also save as markdown file
    with open('validation_summary.md', 'w') as f:
        f.write(summary_content)
    print("Validation summary saved to validation_summary.md")

def generate_pr_comment():
    """Generate PR comment content"""
    
    comment_lines = []
    comment_lines.append("## LookML Validation Results\n")
    
    # Read results files
    validation_data = {}
    linting_data = {}
    data_tests_data = {}
    
    try:
        if os.path.exists('validation_results.json'):
            with open('validation_results.json', 'r') as f:
                validation_data = json.load(f)
    except Exception as e:
        comment_lines.append(f"Could not read validation results: {e}\n")
    
    try:
        if os.path.exists('linting_results.json'):
            with open('linting_results.json', 'r') as f:
                linting_data = json.load(f)
    except Exception as e:
        comment_lines.append(f"Could not read linting results: {e}\n")
    
    try:
        if os.path.exists('data_tests_results.json'):
            with open('data_tests_results.json', 'r') as f:
                data_tests_data = json.load(f)
    except Exception as e:
        comment_lines.append(f"Could not read data tests results: {e}\n")
    
    # Process validation errors
    validation_errors = validation_data.get('errors', [])
    if validation_errors:
        comment_lines.append("### Validation Errors")
        for error in validation_errors:
            comment_lines.append(f"- {error}")
        comment_lines.append("")
    
    # Process linting errors
    linting_errors = linting_data.get('errors', [])
    if linting_errors:
        comment_lines.append("### Linting Errors")
        for error in linting_errors:
            comment_lines.append(f"- {error}")
        comment_lines.append("")
    
    # Process data tests errors
    if data_tests_data and data_tests_data.get('summary'):
        test_summary = data_tests_data['summary']
        
        if test_summary.get('failed_models', 0) > 0 or test_summary.get('failed_tests', 0) > 0:
            comment_lines.append("### Data Tests Errors")
            
            # Failed models
            if test_summary.get('failed_models', 0) > 0:
                comment_lines.append("**Failed Models:**")
                for model in data_tests_data.get('model_validation', []):
                    if model.get('status') != 'success':
                        model_name = model.get('model', 'Unknown')
                        error_count = len(model.get('errors', []))
                        comment_lines.append(f"- {model_name}: {error_count} errors")
            
            # Failed tests
            if test_summary.get('failed_tests', 0) > 0:
                comment_lines.append("**Failed LookML Tests:**")
                for test in data_tests_data.get('data_tests', []):
                    if test.get('status') == 'error':
                        test_name = test.get('test_name', 'Unknown')
                        model_name = test.get('model_name', 'Unknown')
                        explore_name = test.get('explore_name', 'Unknown')
                        message = test.get('message', 'No details')
                        comment_lines.append(f"- {test_name} ({model_name}.{explore_name}): {message}")
            
            comment_lines.append("")
    
    # Process warnings
    validation_warnings = validation_data.get('warnings', [])
    linting_warnings = linting_data.get('warnings', [])
    all_warnings = validation_warnings + linting_warnings
    
    if data_tests_data and data_tests_data.get('summary', {}).get('warnings', 0) > 0:
        comment_lines.append("### Data Tests Warnings")
        for test in data_tests_data.get('data_tests', []):
            if test.get('warnings'):
                test_name = test.get('test_name', 'Unknown')
                for warning in test['warnings']:
                    comment_lines.append(f"- {test_name}: {warning}")
        comment_lines.append("")
    
    if all_warnings:
        comment_lines.append("### Warnings")
        for warning in all_warnings:
            comment_lines.append(f"- {warning}")
        comment_lines.append("")
    
    # Success message if no errors or warnings
    total_errors = len(validation_errors) + len(linting_errors)
    if data_tests_data and data_tests_data.get('summary'):
        total_errors += data_tests_data['summary'].get('failed_models', 0) + data_tests_data['summary'].get('failed_tests', 0)
    
    if total_errors == 0 and not all_warnings:
        comment_lines.append("### All validations passed!")
        comment_lines.append("")
    
    # Add data tests summary
    if data_tests_data and data_tests_data.get('summary'):
        test_summary = data_tests_data['summary']
        comment_lines.append("### Data Tests Summary")
        comment_lines.append(f"- Models tested: {test_summary.get('total_models', 0)} (passed: {test_summary.get('passed_models', 0)})")
        comment_lines.append(f"- LookML tests: {test_summary.get('total_tests', 0)} (passed: {test_summary.get('passed_tests', 0)})")
        comment_lines.append("")
    
    # Add workflow link placeholder
    github_run_id = os.environ.get('GITHUB_RUN_ID', 'unknown')
    github_repository = os.environ.get('GITHUB_REPOSITORY', 'unknown')
    comment_lines.append(f"**Workflow run:** [View Details](https://github.com/{github_repository}/actions/runs/{github_run_id})")
    
    # Save comment to file
    comment_content = "\n".join(comment_lines)
    with open('pr_comment.md', 'w') as f:
        f.write(comment_content)
    
    print("PR comment generated and saved to pr_comment.md")

if __name__ == '__main__':
    print("Generating validation reports...")
    
    try:
        generate_github_summary()
        generate_pr_comment()
        print("All reports generated successfully")
    except Exception as e:
        print(f"Error generating reports: {e}")
        sys.exit(1)


# Updated .github/scripts/check-results.py
"""
Check validation results and exit with appropriate code (Updated with Data Tests support)
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
                print(f"Found {validation_errors} validation errors")
            else:
                print("No validation errors found")
                
        except Exception as e:
            print(f"Could not read validation results: {e}")
    else:
        print("No validation results file found")
    
    # Check linting results
    if os.path.exists('linting_results.json'):
        try:
            with open('linting_results.json', 'r') as f:
                linting_data = json.load(f)
            
            linting_errors = len(linting_data.get('errors', []))
            total_errors += linting_errors
            
            if linting_errors > 0:
                print(f"Found {linting_errors} linting errors")
            else:
                print("No linting errors found")
                
        except Exception as e:
            print(f"Could not read linting results: {e}")
    else:
        print("No linting results file found")
    
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
                print(f"Found {failed_models} failed models and {failed_tests} failed data tests")
            else:
                print("All data tests passed")
                
        except Exception as e:
            print(f"Could not read data tests results: {e}")
    else:
        print("No data tests results file found")
    
    # Final result
    if total_errors > 0:
        print(f"\nLookML validation failed with {total_errors} total errors")
        sys.exit(1)
    else:
        print(f"\nAll LookML validations passed!")
        sys.exit(0)

if __name__ == '__main__':
    main()
