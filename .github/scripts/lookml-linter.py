#!/usr/bin/env python3
"""
Custom LookML Linter
Enforces coding standards and best practices
"""

import json
import sys
import argparse
import os
import re
import yaml
from typing import Dict, List, Any, Tuple
from pathlib import Path


class LookMLLinter:
    def __init__(self, rules_file: str = '.github/config/linting-rules.yaml'):
        self.rules_file = rules_file
        self.rules = self.load_rules()
        self.results = {
            'errors': [],
            'warnings': [],
            'info': [],
            'files_processed': []
        }
    
    def load_rules(self) -> Dict[str, Any]:
        """Load linting rules from YAML configuration"""
        default_rules = {
            'mandatory_fields': {
                'dimension': ['label', 'description'],
                'measure': ['label', 'description', 'type'],
                'explore': ['description'],
                'dashboard': ['title', 'description']
            },
            'naming_conventions': {
                'use_snake_case': True,
                'boolean_prefixes': ['is_', 'has_', 'can_', 'should_'],
                'avoid_reserved_words': ['order', 'group', 'select', 'from', 'where']
            },
            'performance_rules': {
                'avoid_select_star': True,
                'recommend_indexes': True,
                'limit_nested_queries': 3
            },
            'security_rules': {
                'require_access_filters_for_pii': True,
                'no_hardcoded_secrets': True
            }
        }
        
        if not os.path.exists(self.rules_file):
            print(f"⚠️ Rules file {self.rules_file} not found, using default rules")
            return default_rules
        
        try:
            with open(self.rules_file, 'r') as f:
                custom_rules = yaml.safe_load(f)
                # Merge with defaults
                default_rules.update(custom_rules)
                return default_rules
        except Exception as e:
            print(f"❌ Error loading rules file: {e}")
            return default_rules
    
    def lint_file(self, file_path: str) -> None:
        """Lint a single LookML file"""
        if not os.path.exists(file_path):
            self.results['errors'].append(f"File not found: {file_path}")
            return
        
        self.results['files_processed'].append(file_path)
        print(f"🔍 Linting file: {file_path}")
        
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            self.check_mandatory_fields(file_path, content)
            self.check_naming_conventions(file_path, content)
            self.check_performance_rules(file_path, content)
            self.check_security_rules(file_path, content)
            
        except Exception as e:
            self.results['errors'].append(f"Error processing {file_path}: {e}")
    
    def check_mandatory_fields(self, file_path: str, content: str) -> None:
        """Check for mandatory fields in dimensions, measures, etc."""
        mandatory_rules = self.rules.get('mandatory_fields', {})
        
        for block_type, required_fields in mandatory_rules.items():
            # Find all blocks of this type
            pattern = rf'{block_type}:\s*(\w+)\s*\{{([^{{}}]*(?:\{{[^{{}}]*\}}[^{{}}]*)*)\}}'
            matches = re.finditer(pattern, content, re.DOTALL | re.MULTILINE)
            
            for match in matches:
                block_name = match.group(1)
                block_content = match.group(2)
                
                for required_field in required_fields:
                    field_pattern = rf'{required_field}:\s*["\']?[^"\'\n]+["\']?'
                    if not re.search(field_pattern, block_content):
                        error_msg = f"{file_path}: {block_type} '{block_name}' missing required field '{required_field}'"
                        self.results['errors'].append(error_msg)
    
    def check_naming_conventions(self, file_path: str, content: str) -> None:
        """Check naming convention rules"""
        naming_rules = self.rules.get('naming_conventions', {})
        
        if naming_rules.get('use_snake_case', False):
            # Check for non-snake_case names
            patterns = [
                (r'dimension:\s*([a-zA-Z][a-zA-Z0-9]*[A-Z][a-zA-Z0-9]*)', 'dimension'),
                (r'measure:\s*([a-zA-Z][a-zA-Z0-9]*[A-Z][a-zA-Z0-9]*)', 'measure'),
                (r'view:\s*([a-zA-Z][a-zA-Z0-9]*[A-Z][a-zA-Z0-9]*)', 'view')
            ]
            
            for pattern, element_type in patterns:
                matches = re.finditer(pattern, content)
                for match in matches:
                    name = match.group(1)
                    warning_msg = f"{file_path}: {element_type} '{name}' should use snake_case naming"
                    self.results['warnings'].append(warning_msg)
        
        # Check boolean naming conventions
        boolean_prefixes = naming_rules.get('boolean_prefixes', [])
        if boolean_prefixes:
            boolean_pattern = r'dimension:\s*(\w+)\s*\{[^}]*type:\s*yesno'
            matches = re.finditer(boolean_pattern, content, re.DOTALL)
            
            for match in matches:
                dim_name = match.group(1)
                if not any(dim_name.startswith(prefix) for prefix in boolean_prefixes):
                    warning_msg = f"{file_path}: Boolean dimension '{dim_name}' should start with one of: {boolean_prefixes}"
                    self.results['warnings'].append(warning_msg)
    
    def check_performance_rules(self, file_path: str, content: str) -> None:
        """Check performance-related rules"""
        perf_rules = self.rules.get('performance_rules', {})
        
        if perf_rules.get('avoid_select_star', False):
            if re.search(r'SELECT\s+\*', content, re.IGNORECASE):
                warning_msg = f"{file_path}: Avoid using SELECT * for performance reasons"
                self.results['warnings'].append(warning_msg)
        
        # Check for nested query depth
        max_nested = perf_rules.get('limit_nested_queries', 3)
        nested_count = len(re.findall(r'\(SELECT', content, re.IGNORECASE))
        if nested_count > max_nested:
            warning_msg = f"{file_path}: High nesting level ({nested_count}) may impact performance"
            self.results['warnings'].append(warning_msg)
    
    def check_security_rules(self, file_path: str, content: str) -> None:
        """Check security-related rules"""
        security_rules = self.rules.get('security_rules', {})
        
        if security_rules.get('no_hardcoded_secrets', False):
            # Look for potential hardcoded secrets
            secret_patterns = [
                r'password\s*[=:]\s*["\'][^"\']+["\']',
                r'secret\s*[=:]\s*["\'][^"\']+["\']',
                r'key\s*[=:]\s*["\'][^"\']+["\']'
            ]
            
            for pattern in secret_patterns:
                if re.search(pattern, content, re.IGNORECASE):
                    error_msg = f"{file_path}: Potential hardcoded secret detected"
                    self.results['errors'].append(error_msg)
        
        # Check for PII fields without access filters
        pii_patterns = [
            r'dimension:\s*\w*(email|ssn|phone|address)\w*',
            r'dimension:\s*\w*(first_name|last_name|full_name)\w*'
        ]
        
        for pattern in pii_patterns:
            matches = re.finditer(pattern, content, re.IGNORECASE)
            for match in matches:
                # Check if there's an access_filter in the same explore
                if not re.search(r'access_filter:', content):
                    warning_msg = f"{file_path}: PII field detected without access_filter protection"
                    self.results['warnings'].append(warning_msg)
    
    def generate_summary(self) -> str:
        """Generate a summary of linting results"""
        total_files = len(self.results['files_processed'])
        total_errors = len(self.results['errors'])
        total_warnings = len(self.results['warnings'])
        
        summary = f"""
📊 LookML Linting Summary:
  Files processed: {total_files}
  Errors found: {total_errors}
  Warnings found: {total_warnings}
        """
        
        if total_errors > 0:
            summary += "\n❌ Errors:\n"
            for error in self.results['errors']:
                summary += f"  - {error}\n"
        
        if total_warnings > 0:
            summary += "\n⚠️ Warnings:\n"
            for warning in self.results['warnings']:
                summary += f"  - {warning}\n"
        
        return summary
    
    def save_results(self, output_file: str = 'linting_results.json'):
        """Save linting results to JSON file"""
        try:
            with open(output_file, 'w') as f:
                json.dump(self.results, f, indent=2)
            print(f"📄 Linting results saved to {output_file}")
        except Exception as e:
            print(f"❌ Failed to save results: {e}")


def main():
    parser = argparse.ArgumentParser(description='Lint LookML files for coding standards')
    parser.add_argument('--files', required=True, help='Space-separated list of files to lint')
    parser.add_argument('--rules-file', default='.github/config/linting-rules.yaml', help='Linting rules configuration file')
    parser.add_argument('--output-file', default='linting_results.json', help='Output file for results')
    
    args = parser.parse_args()
    
    files_to_lint = args.files.split()
    
    print(f"🚀 Starting LookML linting for {len(files_to_lint)} files")
    
    linter = LookMLLinter(args.rules_file)
    
    for file_path in files_to_lint:
        if file_path.endswith(('.lookml', '.lkml', '.model', '.view', '.explore', '.dashboard')) or file_path == 'manifest.lkml':
            linter.lint_file(file_path)
    
    print(linter.generate_summary())
    linter.save_results(args.output_file)
    
    # Exit with error code if there are errors
    if len(linter.results['errors']) > 0:
        sys.exit(1)
    else:
        print("✅ LookML linting completed successfully!")
        sys.exit(0)


if __name__ == '__main__':
    main()
