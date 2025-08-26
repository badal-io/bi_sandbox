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
                    if test.get('status') ==
