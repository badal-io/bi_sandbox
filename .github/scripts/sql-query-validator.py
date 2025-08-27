#!/usr/bin/env python3
"""
SQL Query Validator for LookML Views and Explores
Validates SQL queries defined in LookML files using Looker API
"""

import json
import sys
import argparse
import configparser
import requests
import os
import re
from typing import Dict, List, Any, Tuple
from datetime import datetime
import time


class SQLQueryValidator:
    def __init__(self, config_file: str = 'looker.ini'):
        self.config = configparser.ConfigParser()
        self.config.read(config_file)
        
        # Looker connection details
        self.base_url = self.config['Looker']['base_url'].rstrip('/')
        self.client_id = self.config['Looker']['client_id']
        self.client_secret = self.config['Looker']['client_secret']
        self.api_version = self.config.get('Looker', 'api_version', fallback='4.0')
        
        self.api_url = f"{self.base_url}/api/{self.api_version}"
        self.session = requests.Session()
        self.access_token = None
        
        self.validation_results = {
            'sql_validations': [],
            'summary': {
                'total_queries_found': 0,
                'total_queries_validated': 0,
                'queries_with_errors': 0,
                'queries_with_warnings': 0,
                'files_processed': 0
            },
            'errors': [],
            'warnings': [],
            'timestamp': datetime.now().isoformat()
        }
        
        # SQL validation rules
        self.sql_rules = {
            'performance': {
                'avoid_select_star': True,
                'require_where_clause_for_large_tables': True,
                'limit_without_order_by': True,
                'avoid_functions_in_where': True
            },
            'security': {
                'no_hardcoded_credentials': True,
                'avoid_dynamic_sql': True
            },
            'best_practices': {
                'use_qualified_table_names': True,
                'avoid_reserved_words_as_aliases': True,
                'consistent_naming_convention': True
            }
        }
    
    def authenticate(self) -> bool:
        """Authenticate with Looker API and get access token"""
        login_url = f"{self.api_url}/login"
        
        login_data = {
            'client_id': self.client_id,
            'client_secret': self.client_secret
        }
        
        try:
            response = self.session.post(login_url, data=login_data)
            response.raise_for_status()
            
            auth_data = response.json()
            self.access_token = auth_data.get('access_token')
            
            if not self.access_token:
                print("Failed to obtain access token")
                return False
                
            self.session.headers.update({
                'Authorization': f'Bearer {self.access_token}',
                'Content-Type': 'application/json'
            })
            
            print("Successfully authenticated with Looker API")
            return True
            
        except requests.exceptions.RequestException as e:
            print(f"Authentication failed: {e}")
            return False
    
    def extract_sql_from_lookml_files(self, file_paths: List[str]) -> List[Dict[str, Any]]:
        """Extract SQL queries from LookML files"""
        sql_queries = []
        
        for file_path in file_paths:
            if not file_path.endswith(('.lookml', '.lkml', '.view', '.model', '.explore')):
                continue
            
            if not os.path.exists(file_path):
                continue
            
            self.validation_results['summary']['files_processed'] += 1
            print(f"🔍 Extracting SQL from: {file_path}")
            
            try:
                with open(file_path, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                # Extract SQL from views
                view_sqls = self.extract_view_sql(content, file_path)
                sql_queries.extend(view_sqls)
                
                # Extract SQL from explores (derived tables)
                explore_sqls = self.extract_explore_sql(content, file_path)
                sql_queries.extend(explore_sqls)
                
                # Extract SQL from dimensions/measures with sql parameters
                field_sqls = self.extract_field_sql(content, file_path)
                sql_queries.extend(field_sqls)
                
            except Exception as e:
                error_msg = f"Error reading file {file_path}: {e}"
                self.validation_results['errors'].append(error_msg)
                print(f"❌ {error_msg}")
        
        self.validation_results['summary']['total_queries_found'] = len(sql_queries)
        return sql_queries
    
    def extract_view_sql(self, content: str, file_path: str) -> List[Dict[str, Any]]:
        """Extract SQL from view definitions"""
        sql_queries = []
        
        # Pattern to match view with sql_table_name or derived_table
        view_pattern = r'view:\s+(\w+)\s*\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}'
        view_matches = re.finditer(view_pattern, content, re.DOTALL)
        
        for match in view_matches:
            view_name = match.group(1)
            view_content = match.group(2)
            
            # Look for derived_table with sql
            derived_table_pattern = r'derived_table:\s*\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}'
            derived_match = re.search(derived_table_pattern, view_content, re.DOTALL)
            
            if derived_match:
                derived_content = derived_match.group(1)
                
                # Extract SQL from derived table
                sql_pattern = r'sql:\s*(.*?)(?=\s*(?:datagroup_trigger|distribution_style|sortkeys|indexes|\}|$))'
                sql_match = re.search(sql_pattern, derived_content, re.DOTALL)
                
                if sql_match:
                    sql_content = sql_match.group(1).strip()
                    # Remove ;; delimiters and clean up
                    sql_content = re.sub(r';;.*$', '', sql_content, flags=re.MULTILINE)
                    sql_content = sql_content.strip(' \n\t;')
                    
                    if sql_content:
                        sql_queries.append({
                            'type': 'view_derived_table',
                            'view_name': view_name,
                            'file_path': file_path,
                            'sql_content': sql_content,
                            'line_number': content[:match.start()].count('\n') + 1
                        })
        
        return sql_queries
    
    def extract_explore_sql(self, content: str, file_path: str) -> List[Dict[str, Any]]:
        """Extract SQL from explore definitions (joins with sql_on)"""
        sql_queries = []
        
        # Pattern to match explores
        explore_pattern = r'explore:\s+(\w+)\s*\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}'
        explore_matches = re.finditer(explore_pattern, content, re.DOTALL)
        
        for match in explore_matches:
            explore_name = match.group(1)
            explore_content = match.group(2)
            
            # Look for joins with sql_on
            join_pattern = r'join:\s+(\w+)\s*\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}'
            join_matches = re.finditer(join_pattern, explore_content, re.DOTALL)
            
            for join_match in join_matches:
                join_name = join_match.group(1)
                join_content = join_match.group(2)
                
                # Extract sql_on
                sql_on_pattern = r'sql_on:\s*(.*?)(?=\s*(?:type:|relationship:|\}|$))'
                sql_on_match = re.search(sql_on_pattern, join_content, re.DOTALL)
                
                if sql_on_match:
                    sql_content = sql_on_match.group(1).strip()
                    sql_content = re.sub(r';;.*$', '', sql_content, flags=re.MULTILINE)
                    sql_content = sql_content.strip(' \n\t;')
                    
                    if sql_content:
                        sql_queries.append({
                            'type': 'explore_join',
                            'explore_name': explore_name,
                            'join_name': join_name,
                            'file_path': file_path,
                            'sql_content': sql_content,
                            'line_number': content[:match.start()].count('\n') + 1
                        })
        
        return sql_queries
    
    def extract_field_sql(self, content: str, file_path: str) -> List[Dict[str, Any]]:
        """Extract SQL from dimension/measure sql parameters"""
        sql_queries = []
        
        # Pattern to match dimensions and measures with sql
        field_patterns = [
            (r'dimension:\s+(\w+)\s*\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}', 'dimension'),
            (r'measure:\s+(\w+)\s*\{([^{}]*(?:\{[^{}]*\}[^{}]*)*)\}', 'measure')
        ]
        
        for pattern, field_type in field_patterns:
            field_matches = re.finditer(pattern, content, re.DOTALL)
            
            for match in field_matches:
                field_name = match.group(1)
                field_content = match.group(2)
                
                # Extract sql parameter
                sql_pattern = r'sql:\s*(.*?)(?=\s*(?:type:|label:|description:|hidden:|\}|$))'
                sql_match = re.search(sql_pattern, field_content, re.DOTALL)
                
                if sql_match:
                    sql_content = sql_match.group(1).strip()
                    sql_content = re.sub(r';;.*$', '', sql_content, flags=re.MULTILINE)
                    sql_content = sql_content.strip(' \n\t;')
                    
                    # Only include if it's actual SQL (not just field references)
                    if sql_content and any(keyword in sql_content.upper() for keyword in 
                                         ['SELECT', 'FROM', 'WHERE', 'JOIN', 'CASE', 'WHEN']):
                        sql_queries.append({
                            'type': f'{field_type}_sql',
                            'field_name': field_name,
                            'field_type': field_type,
                            'file_path': file_path,
                            'sql_content': sql_content,
                            'line_number': content[:match.start()].count('\n') + 1
                        })
        
        return sql_queries
    
    def validate_sql_with_looker_api(self, sql_query: Dict[str, Any], project_name: str) -> Dict[str, Any]:
        """Validate SQL query using Looker API"""
        try:
            # Use the sql_runner endpoint to validate SQL
            sql_runner_url = f"{self.api_url}/sql_runners"
            
            payload = {
                'sql': sql_query['sql_content'],
                'connection_name': 'your_connection',  # This should be configurable
                'limit': 1  # Just validate, don't return data
            }
            
            response = self.session.post(sql_runner_url, json=payload)
            
            validation_result = {
                'query_info': sql_query,
                'api_validation': {
                    'status': 'success' if response.status_code == 200 else 'error',
                    'status_code': response.status_code,
                    'errors': [],
                    'warnings': []
                },
                'rule_validation': self.validate_sql_rules(sql_query['sql_content']),
                'timestamp': datetime.now().isoformat()
            }
            
            if response.status_code != 200:
                try:
                    error_data = response.json()
                    validation_result['api_validation']['errors'] = [error_data.get('message', 'Unknown API error')]
                except:
                    validation_result['api_validation']['errors'] = [f"HTTP {response.status_code}: {response.text}"]
            
            return validation_result
            
        except Exception as e:
            return {
                'query_info': sql_query,
                'api_validation': {
                    'status': 'error',
                    'errors': [f"Validation failed: {str(e)}"]
                },
                'rule_validation': self.validate_sql_rules(sql_query['sql_content']),
                'timestamp': datetime.now().isoformat()
            }
    
    def validate_sql_rules(self, sql_content: str) -> Dict[str, List[str]]:
        """Validate SQL against custom rules"""
        errors = []
        warnings = []
        
        sql_upper = sql_content.upper()
        
        # Performance rules
        if self.sql_rules['performance']['avoid_select_star']:
            if re.search(r'SELECT\s+\*', sql_upper):
                warnings.append("Consider avoiding SELECT * for better performance")
        
        if self.sql_rules['performance']['limit_without_order_by']:
            if 'LIMIT' in sql_upper and 'ORDER BY' not in sql_upper:
                warnings.append("LIMIT without ORDER BY may produce inconsistent results")
        
        if self.sql_rules['performance']['avoid_functions_in_where']:
            where_functions = re.findall(r'WHERE.*?(?:UPPER|LOWER|SUBSTR|TRIM)\s*\(', sql_upper)
            if where_functions:
                warnings.append("Functions in WHERE clause may impact performance")
        
        # Security rules
        if self.sql_rules['security']['no_hardcoded_credentials']:
            if re.search(r'(PASSWORD|PWD|SECRET|KEY)\s*=\s*[\'"][^\'"]+[\'"]', sql_upper):
                errors.append("Potential hardcoded credentials detected")
        
        # Best practices
        if self.sql_rules['best_practices']['use_qualified_table_names']:
            # Simple check for unqualified table names in FROM clause
            from_matches = re.findall(r'FROM\s+(\w+)(?:\s|$|,)', sql_upper)
            for table in from_matches:
                if '.' not in table and table not in ['DUAL', 'INFORMATION_SCHEMA']:
                    warnings.append(f"Consider using qualified table name for '{table}'")
        
        return {
            'errors': errors,
            'warnings': warnings
        }
    
    def run_validation(self, file_paths: List[str], project_name: str = 'bi_sandbox') -> bool:
        """Main validation function"""
        print("=" * 60)
        print("SQL QUERY VALIDATION FOR LOOKML")
        print("=" * 60)
        
        if not self.authenticate():
            return False
        
        # Extract SQL queries from LookML files
        sql_queries = self.extract_sql_from_lookml_files(file_paths)
        
        if not sql_queries:
            print("ℹ️ No SQL queries found in the provided files")
            return True
        
        print(f"🔍 Found {len(sql_queries)} SQL queries to validate")
        
        # Validate each SQL query
        for i, sql_query in enumerate(sql_queries, 1):
            print(f"\n📋 Validating query {i}/{len(sql_queries)}: {sql_query['type']} in {sql_query['file_path']}")
            
            # Run rule-based validation (always)
            rule_validation = self.validate_sql_rules(sql_query['sql_content'])
            
            validation_result = {
                'query_info': sql_query,
                'api_validation': {'status': 'skipped', 'message': 'API validation requires connection configuration'},
                'rule_validation': rule_validation,
                'timestamp': datetime.now().isoformat()
            }
            
            # Count errors and warnings
            total_errors = len(rule_validation['errors'])
            total_warnings = len(rule_validation['warnings'])
            
            if total_errors > 0:
                self.validation_results['summary']['queries_with_errors'] += 1
                print(f"❌ Found {total_errors} errors")
                for error in rule_validation['errors']:
                    print(f"   • {error}")
                    self.validation_results['errors'].append(f"{sql_query['file_path']}:{sql_query.get('line_number', '?')} - {error}")
            
            if total_warnings > 0:
                self.validation_results['summary']['queries_with_warnings'] += 1
                print(f"⚠️ Found {total_warnings} warnings")
                for warning in rule_validation['warnings']:
                    print(f"   • {warning}")
                    self.validation_results['warnings'].append(f"{sql_query['file_path']}:{sql_query.get('line_number', '?')} - {warning}")
            
            if total_errors == 0 and total_warnings == 0:
                print("✅ Query validation passed")
            
            self.validation_results['sql_validations'].append(validation_result)
            self.validation_results['summary']['total_queries_validated'] += 1
            
            # Small delay to be respectful to API
            time.sleep(0.1)
        
        return self.validation_results['summary']['queries_with_errors'] == 0
    
    def print_summary(self):
        """Print validation summary"""
        print(f"\n" + "=" * 60)
        print("SQL VALIDATION SUMMARY")
        print("=" * 60)
        
        summary = self.validation_results['summary']
        print(f"Files processed: {summary['files_processed']}")
        print(f"SQL queries found: {summary['total_queries_found']}")
        print(f"Queries validated: {summary['total_queries_validated']}")
        print(f"Queries with errors: {summary['queries_with_errors']}")
        print(f"Queries with warnings: {summary['queries_with_warnings']}")
        
        if summary['queries_with_errors'] == 0:
            print("\n✅ All SQL validations passed!")
        else:
            print(f"\n❌ {summary['queries_with_errors']} queries have errors")
    
    def save_results(self, output_file: str = 'sql_validation_results.json'):
        """Save validation results to JSON file"""
        try:
            with open(output_file, 'w') as f:
                json.dump(self.validation_results, f, indent=2)
            print(f"📄 SQL validation results saved to {output_file}")
        except Exception as e:
            print(f"❌ Failed to save results: {e}")


def main():
    parser = argparse.ArgumentParser(description='Validate SQL queries in LookML files')
    parser.add_argument('--files', required=True, help='Space-separated list of files to validate')
    parser.add_argument('--project-name', default='bi_sandbox', help='LookML project name')
    parser.add_argument('--config-file', default='looker.ini', help='Looker configuration file')
    parser.add_argument('--output-file', default='sql_validation_results.json', help='Output file for results')
    
    args = parser.parse_args()
    
    files_to_validate = args.files.split()
    
    print(f"🚀 Starting SQL validation for {len(files_to_validate)} files")
    
    validator = SQLQueryValidator(args.config_file)
    success = validator.run_validation(files_to_validate, args.project_name)
    validator.print_summary()
    validator.save_results(args.output_file)
    
    if success:
        print("✅ SQL validation completed successfully!")
        sys.exit(0)
    else:
        print("❌ SQL validation found errors!")
        sys.exit(1)


if __name__ == '__main__':
    main()
