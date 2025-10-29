#!/usr/bin/env python3
# Fixed .github/scripts/report-generator.py
"""
Generate validation reports for GitHub Actions (Fixed SQL Validation structure)
"""

import json
import os
import sys

def generate_github_summary():
    """Generate GitHub Actions step summary"""
    
    summary_lines = []
    summary_lines.append("## EK Custom LookML Validation Report\n")
    
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
    
    # Read SQL validation results (fixed structure)
    sql_validation_data = {}
    if os.path.exists('sql_validation_results.json'):
        try:
            with open('sql_validation_results.json', 'r') as f:
                sql_validation_data = json.load(f)
        except Exception as e:
            print(f"Warning: Could not read SQL validation results: {e}")
    
    # Read data tests results
    data_tests_data = {}
    if os.path.exists('data_tests_results.json'):
        try:
            with open('data_tests_results.json', 'r') as f:
                data_tests_data = json.load(f)
        except Exception as e:
            print(f"Warning: Could not read data tests results: {e}")
    
    # Read content validation results
    content_validation_data = {}
    if os.path.exists('content_validation_results.json'):
        try:
            with open('content_validation_results.json', 'r') as f:
                content_validation_data = json.load(f)
        except Exception as e:
            print(f"Warning: Could not read content validation results: {e}")

    # --- Read EK Audit Script Results ---
    summary_lines.append("\n## EK Audit Script Results\n")
    # Orphaned Views
    if os.path.exists("orphaned_views_results.json"):
        try:
            with open("orphaned_views_results.json") as f:
                data = json.load(f)
                summary_lines.append(f"- Orphaned views found: {data.get('orphaned_views_count', 0)}")
        except Exception as e:
            summary_lines.append(f"- Could not read orphaned_views_results.json: {e}")
    # Dashboard Query Limit
    if os.path.exists("query_limit_results.json"):
        try:
            with open("query_limit_results.json") as f:
                data = json.load(f)
                summary_lines.append(f"- Dashboards exceeding query limit: {data.get('dashboards_exceeding_query_limit', 0)}")
        except Exception as e:
            summary_lines.append(f"- Could not read query_limit_results.json: {e}")
    # Dashboard Filters
    if os.path.exists("dashboard_filters_results.json"):
        try:
            with open("dashboard_filters_results.json") as f:
                data = json.load(f)
                summary_lines.append(f"- Dashboards missing filters: {data.get('dashboards_missing_filters', 0)}")
        except Exception as e:
            summary_lines.append(f"- Could not read dashboard_filters_results.json: {e}")
    # Join Relationships
    if os.path.exists("join_relationship_results.json"):
        try:
            with open("join_relationship_results.json") as f:
                data = json.load(f)
                summary_lines.append(f"- Joins with invalid relationship: {data.get('joins_with_invalid_relationship', 0)}")
        except Exception as e:
            summary_lines.append(f"- Could not read join_relationship_results.json: {e}")
    # Primary Key Missing
    if os.path.exists("primary_key_results.json"):
        try:
            with open("primary_key_results.json") as f:
                data = json.load(f)
                summary_lines.append(f"- Views missing primary key: {data.get('views_missing_primary_key', 0)}")
        except Exception as e:
            summary_lines.append(f"- Could not read primary_key_results.json: {e}")
    summary_lines.append("")

    # Add files processed
    summary_lines.append("### Files Processed:")
    files_processed = set()
    files_processed.update(validation_data.get('files_processed', []))
    files_processed.update(linting_data.get('files_processed', []))
    
    # Fixed: Get files from SQL executions (correct structure)
    if sql_validation_data.get('sql_executions'):
        for execution in sql_validation_data['sql_executions']:
            if execution.get('query_info', {}).get('file_path'):
                files_processed.add(execution['query_info']['file_path'])
    
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
        summary_lines.append("#### ✅ No syntax errors found!")
    
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
        summary_lines.append("#### ✅ No linting issues found!")
    
    summary_lines.append("")
    
    # SQL Execution results (fixed structure)
    summary_lines.append("### SQL Execution Testing Results:")
    if sql_validation_data and sql_validation_data.get('summary'):
        sql_summary = sql_validation_data['summary']
        
        summary_lines.append(f"#### SQL Execution Analysis:")
        summary_lines.append(f"- Total SQL queries found: {sql_summary.get('total_queries_found', 0)}")
        summary_lines.append(f"- Queries tested: {sql_summary.get('total_queries_tested', 0)}")
        summary_lines.append(f"- Queries passed: {sql_summary.get('queries_passed', 0)}")
        summary_lines.append(f"- Queries with execution errors: {sql_summary.get('queries_with_execution_errors', 0)}")
        
        if sql_summary.get('queries_with_execution_errors', 0) > 0:
            summary_lines.append("- **SQL Execution Errors:**")
            sql_errors = sql_validation_data.get('errors', [])
            for error in sql_errors[:5]:  # Show first 5 errors
                summary_lines.append(f"  - {error}")
        
        sql_warnings = sql_validation_data.get('warnings', [])
        if sql_warnings:
            summary_lines.append("- **SQL Execution Warnings:**")
            for warning in sql_warnings[:3]:  # Show first 3 warnings
                summary_lines.append(f"  - {warning}")
        
        if sql_summary.get('queries_with_execution_errors', 0) == 0:
            summary_lines.append("#### ✅ All SQL queries executed successfully!")
    else:
        summary_lines.append("#### No SQL execution testing performed")
    
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
    
    # Content validation results
    summary_lines.append("")
    summary_lines.append("### Content Validation Results:")
    if content_validation_data and content_validation_data.get('summary'):
        content_summary = content_validation_data['summary']
        
        total_content = sum(content_summary.get('total_content_validated', {}).values())
        summary_lines.append(f"#### Content Statistics:")
        #summary_lines.append(f"- Total content validated: {total_content}")
        summary_lines.append(f"- BI Sandbox errors: {content_summary.get('bi_sandbox_errors', 0)}")
        #summary_lines.append(f"- All content errors: {content_summary.get('total_errors_all_content', 0)}")
        
        if content_summary.get('bi_sandbox_errors', 0) > 0:
            summary_lines.append("- **BI Sandbox Content Issues:**")
            filtered_content = content_summary.get('filtered_content', [])
            for item in filtered_content[:5]:  # Show first 5 items
                errors = item.get('errors', [])
                if errors:
                    content_type = "Unknown"
                    content_name = "Unknown"
                    
                    if item.get('look'):
                        content_type = "Look"
                        content_name = item['look'].get('title', 'Unnamed Look')
                    elif item.get('dashboard'):
                        content_type = "Dashboard"
                        content_name = item['dashboard'].get('title', 'Unnamed Dashboard')
                    elif item.get('dashboard_element'):
                        content_type = "Dashboard Element"
                        content_name = item['dashboard_element'].get('title', 'Unnamed Element')
                    
                    summary_lines.append(f"  - {content_type}: {content_name} ({len(errors)} errors)")
        else:
            summary_lines.append("#### ✅ No content validation errors found in BI Sandbox!")
    else:
        summary_lines.append("#### No content validation executed")
    
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
    sql_validation_data = {}
    data_tests_data = {}
    content_validation_data = {}
    
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
        if os.path.exists('sql_validation_results.json'):
            with open('sql_validation_results.json', 'r') as f:
                sql_validation_data = json.load(f)
    except Exception as e:
        comment_lines.append(f"Could not read SQL validation results: {e}\n")
    
    try:
        if os.path.exists('data_tests_results.json'):
            with open('data_tests_results.json', 'r') as f:
                data_tests_data = json.load(f)
    except Exception as e:
        comment_lines.append(f"Could not read data tests results: {e}\n")
    
    try:
        if os.path.exists('content_validation_results.json'):
            with open('content_validation_results.json', 'r') as f:
                content_validation_data = json.load(f)
    except Exception as e:
        comment_lines.append(f"Could not read content validation results: {e}\n")

    # --- Read EK Audit Script Results ---
    comment_lines.append("\n## EK Audit Script Results\n")
    # Orphaned Views
    if os.path.exists("orphaned_views_results.json"):
        try:
            with open("orphaned_views_results.json") as f:
                data = json.load(f)
                comment_lines.append(f"- Orphaned views found: {data.get('orphaned_views_count', 0)}")
        except Exception as e:
            comment_lines.append(f"- Could not read orphaned_views_results.json: {e}")
    # Dashboard Query Limit
    if os.path.exists("query_limit_results.json"):
        try:
            with open("query_limit_results.json") as f:
                data = json.load(f)
                comment_lines.append(f"- Dashboards exceeding query limit: {data.get('dashboards_exceeding_query_limit', 0)}")
        except Exception as e:
            comment_lines.append(f"- Could not read query_limit_results.json: {e}")
    # Dashboard Filters
    if os.path.exists("dashboard_filters_results.json"):
        try:
            with open("dashboard_filters_results.json") as f:
                data = json.load(f)
                comment_lines.append(f"- Dashboards missing filters: {data.get('dashboards_missing_filters', 0)}")
        except Exception as e:
            comment_lines.append(f"- Could not read dashboard_filters_results.json: {e}")
    # Join Relationships
    if os.path.exists("join_relationship_results.json"):
        try:
            with open("join_relationship_results.json") as f:
                data = json.load(f)
                comment_lines.append(f"- Joins with invalid relationship: {data.get('joins_with_invalid_relationship', 0)}")
        except Exception as e:
            comment_lines.append(f"- Could not read join_relationship_results.json: {e}")
    # Primary Key Missing
    if os.path.exists("primary_key_results.json"):
        try:
            with open("primary_key_results.json") as f:
                data = json.load(f)
                comment_lines.append(f"- Views missing primary key: {data.get('views_missing_primary_key', 0)}")
        except Exception as e:
            comment_lines.append(f"- Could not read primary_key_results.json: {e}")
    comment_lines.append("")

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
    
    # Process SQL execution errors (fixed structure)
    sql_errors = sql_validation_data.get('errors', [])
    if sql_errors:
        comment_lines.append("### SQL Execution Errors")
        for error in sql_errors:
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
    
    # Process content validation errors
    if content_validation_data and content_validation_data.get('summary'):
        content_summary = content_validation_data['summary']
        
        if content_summary.get('bi_sandbox_errors', 0) > 0:
            comment_lines.append("### Content Validation Errors")
            filtered_content = content_summary.get('filtered_content', [])
            
            for i, item in enumerate(filtered_content):
                errors = item.get('errors', [])
                if errors:
                    # Extract content info
                    content_type = "Unknown"
                    content_name = "Unknown"
                    folder_name = "Unknown"
                    
                    if item.get('look'):
                        content_type = "Look"
                        content_name = item['look'].get('title', 'Unnamed Look')
                        if item['look'].get('folder'):
                            folder_name = item['look']['folder'].get('name', 'No folder')
                    elif item.get('dashboard'):
                        content_type = "Dashboard"
                        content_name = item['dashboard'].get('title', 'Unnamed Dashboard')
                        if item['dashboard'].get('folder'):
                            folder_name = item['dashboard']['folder'].get('name', 'No folder')
                    elif item.get('dashboard_element'):
                        content_type = "Dashboard Element"
                        content_name = item['dashboard_element'].get('title', 'Unnamed Element')
                        if item.get('dashboard') and item['dashboard'].get('folder'):
                            folder_name = item['dashboard']['folder'].get('name', 'No folder')
                    
                    comment_lines.append(f"**{content_type}: {content_name}** (Folder: {folder_name})")
                    for error in errors:
                        model_name = error.get('model_name', 'Unknown')
                        message = error.get('message', 'No message')
                        comment_lines.append(f"- Model {model_name}: {message}")
            
            comment_lines.append("")
    
    # Process warnings
    validation_warnings = validation_data.get('warnings', [])
    linting_warnings = linting_data.get('warnings', [])
    sql_warnings = sql_validation_data.get('warnings', [])
    all_warnings = validation_warnings + linting_warnings + sql_warnings
    
    if data_tests_data and data_tests_data.get('summary', {}).get('warnings', 0) > 0:
        comment_lines.append("### Data Tests Warnings")
        for test in data_tests_data.get('data_tests', []):
            if test.get('warnings'):
                test_name = test.get('test_name', 'Unknown')
                for warning in test['warnings']:
                    comment_lines.append(f"- {test_name}: {warning}")
        comment_lines.append("")
    
    if all_warnings:
        comment_lines.append("### Other Warnings")
        for warning in all_warnings:
            comment_lines.append(f"- {warning}")
        comment_lines.append("")
    
    # Calculate total errors for success message
    total_errors = len(validation_data.get('errors', [])) + len(linting_data.get('errors', []))
    total_errors += len(sql_validation_data.get('errors', []))
    if data_tests_data and data_tests_data.get('summary'):
        total_errors += data_tests_data['summary'].get('failed_models', 0) + data_tests_data['summary'].get('failed_tests', 0)
    if content_validation_data and content_validation_data.get('summary'):
        total_errors += content_validation_data['summary'].get('bi_sandbox_errors', 0)
    
    # Success message if no errors or warnings
    if total_errors == 0 and not all_warnings:
        comment_lines.append("### ✅ All validations passed!")
        comment_lines.append("")
    
    # Add summary with status icons
    comment_lines.append("### Summary")
    
    # LookML Validation status
    validation_errors = len(validation_data.get('errors', []))
    validation_icon = "✅" if validation_errors == 0 else "❌"
    comment_lines.append(f"**LookML Validation:** {validation_icon}")
    
    # LookML Linting status
    linting_errors = len(linting_data.get('errors', []))
    linting_icon = "✅" if linting_errors == 0 else "❌"
    comment_lines.append(f"**LookML Linting:** {linting_icon}")
    
    # SQL Execution Testing status (fixed structure)
    sql_errors = len(sql_validation_data.get('errors', []))
    if sql_validation_data and sql_validation_data.get('summary'):
        sql_icon = "✅" if sql_errors == 0 else "❌"
    else:
        sql_icon = "⚪"  # Not run
    comment_lines.append(f"**SQL Execution Testing:** {sql_icon}")
    
    # LookML Data Tests status
    if data_tests_data and data_tests_data.get('summary'):
        data_test_errors = data_tests_data['summary'].get('failed_models', 0) + data_tests_data['summary'].get('failed_tests', 0)
        data_tests_icon = "✅" if data_test_errors == 0 else "❌"
    else:
        data_tests_icon = "⚪"  # Not run
    comment_lines.append(f"**LookML Data Tests:** {data_tests_icon}")
    
    # Looker Content Validation status
    if content_validation_data and content_validation_data.get('summary'):
        content_errors = content_validation_data['summary'].get('bi_sandbox_errors', 0)
        content_icon = "✅" if content_errors == 0 else "❌"
    else:
        content_icon = "⚪"  # Not run
    comment_lines.append(f"**Looker Content Validation:** {content_icon}")
    
    comment_lines.append("")
    
    # Add SQL execution testing summary (fixed structure)
    if sql_validation_data and sql_validation_data.get('summary'):
        sql_summary = sql_validation_data['summary']
        comment_lines.append("### SQL Execution Testing Summary")
        comment_lines.append(f"- SQL queries found: {sql_summary.get('total_queries_found', 0)}")
        comment_lines.append(f"- Queries tested: {sql_summary.get('total_queries_tested', 0)}")
        comment_lines.append(f"- Queries passed: {sql_summary.get('queries_passed', 0)}")
        comment_lines.append(f"- Queries with errors: {sql_summary.get('queries_with_execution_errors', 0)}")
        comment_lines.append("")
    
    # Add data tests summary
    if data_tests_data and data_tests_data.get('summary'):
        test_summary = data_tests_data['summary']
        comment_lines.append("### Data Tests Summary")
        comment_lines.append(f"- Models tested: {test_summary.get('total_models', 0)} (passed: {test_summary.get('passed_models', 0)})")
        comment_lines.append(f"- LookML tests: {test_summary.get('total_tests', 0)} (passed: {test_summary.get('passed_tests', 0)})")
        comment_lines.append("")
    
    # Add content validation summary
    if content_validation_data and content_validation_data.get('summary'):
        content_summary = content_validation_data['summary']
        comment_lines.append("### Content Validation Summary")
        #comment_lines.append(f"- Total content validated: {sum(content_summary.get('total_content_validated', {}).values())}")
        comment_lines.append(f"- BI Sandbox errors: {content_summary.get('bi_sandbox_errors', 0)}")
        #comment_lines.append(f"- All content errors: {content_summary.get('total_errors_all_content', 0)}")
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
