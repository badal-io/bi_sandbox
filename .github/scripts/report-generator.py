#!/usr/bin/env python3
"""
Generate validation reports for GitHub Actions
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
        summary_lines.append("#### ❌ Syntax Errors:")
        for error in validation_errors:
            summary_lines.append(f"- {error}")
    else:
        summary_lines.append("#### ✅ No syntax errors found!")
    
    summary_lines.append("")
    
    # Linting results
    linting_errors = linting_data.get('errors', [])
    linting_warnings = linting_data.get('warnings', [])
    
    if linting_errors:
        summary_lines.append("#### ❌ Linting Errors:")
        for error in linting_errors:
            summary_lines.append(f"- {error}")
    
    if linting_warnings:
        summary_lines.append("#### ⚠️ Linting Warnings:")
        for warning in linting_warnings:
            summary_lines.append(f"- {warning}")
    
    if not linting_errors and not linting_warnings:
        summary_lines.append("#### ✅ No linting issues found!")
    
    # Write to GitHub Actions step summary
    summary_content = "\n".join(summary_lines)
    
    github_step_summary = os.environ.get('GITHUB_STEP_SUMMARY')
    if github_step_summary:
        try:
            with open(github_step_summary, 'a') as f:
                f.write(summary_content)
            print("✅ GitHub step summary updated")
        except Exception as e:
            print(f"❌ Failed to write GitHub step summary: {e}")
    else:
        print("ℹ️ GITHUB_STEP_SUMMARY not set, printing to console:")
        print(summary_content)
    
    # Also save as markdown file
    with open('validation_summary.md', 'w') as f:
        f.write(summary_content)
    print("📄 Validation summary saved to validation_summary.md")

def generate_pr_comment():
    """Generate PR comment content"""
    
    comment_lines = []
    comment_lines.append("## 🔍 LookML Validation Results\n")
    
    # Read results files
    validation_data = {}
    linting_data = {}
    
    try:
        if os.path.exists('validation_results.json'):
            with open('validation_results.json', 'r') as f:
                validation_data = json.load(f)
    except Exception as e:
        comment_lines.append(f"⚠️ Could not read validation results: {e}\n")
    
    try:
        if os.path.exists('linting_results.json'):
            with open('linting_results.json', 'r') as f:
                linting_data = json.load(f)
    except Exception as e:
        comment_lines.append(f"⚠️ Could not read linting results: {e}\n")
    
    # Process validation errors
    validation_errors = validation_data.get('errors', [])
    if validation_errors:
        comment_lines.append("### ❌ Validation Errors")
        for error in validation_errors:
            comment_lines.append(f"- {error}")
        comment_lines.append("")
    
    # Process linting errors
    linting_errors = linting_data.get('errors', [])
    if linting_errors:
        comment_lines.append("### ❌ Linting Errors")
        for error in linting_errors:
            comment_lines.append(f"- {error}")
        comment_lines.append("")
    
    # Process warnings
    validation_warnings = validation_data.get('warnings', [])
    linting_warnings = linting_data.get('warnings', [])
    all_warnings = validation_warnings + linting_warnings
    
    if all_warnings:
        comment_lines.append("### ⚠️ Warnings")
        for warning in all_warnings:
            comment_lines.append(f"- {warning}")
        comment_lines.append("")
    
    # Success message if no errors or warnings
    if not validation_errors and not linting_errors and not all_warnings:
        comment_lines.append("### ✅ All validations passed!")
        comment_lines.append("")
    
    # Add workflow link placeholder
    github_run_id = os.environ.get('GITHUB_RUN_ID', 'unknown')
    github_repository = os.environ.get('GITHUB_REPOSITORY', 'unknown')
    comment_lines.append(f"**Workflow run:** [View Details](https://github.com/{github_repository}/actions/runs/{github_run_id})")
    
    # Save comment to file
    comment_content = "\n".join(comment_lines)
    with open('pr_comment.md', 'w') as f:
        f.write(comment_content)
    
    print("💬 PR comment generated and saved to pr_comment.md")

if __name__ == '__main__':
    print("📊 Generating validation reports...")
    
    try:
        generate_github_summary()
        generate_pr_comment()
        print("✅ All reports generated successfully")
    except Exception as e:
        print(f"❌ Error generating reports: {e}")
        sys.exit(1)
