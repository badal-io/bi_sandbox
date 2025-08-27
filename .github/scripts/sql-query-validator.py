#!/usr/bin/env python3
"""
SQL Execution Validator for LookML
Tests actual SQL execution against database connections using Looker API
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


class SQLExecutionValidator:
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
        
        # Get available connections
        self.connections = {}
        
        self.validation_results = {
            'sql_executions': [],
            'summary': {
                'total_queries_found': 0,
                'total_queries_tested': 0,
                'queries_with_execution_errors': 0,
                'queries_passed': 0,
                'files_processed': 0,
                'connections_used': []
            },
            'errors': [],
            'warnings': [],
            'timestamp': datetime.now().isoformat()
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
    
    def get_connections(self) -> Dict[str, str]:
        """Get available database connections from Looker"""
        try:
            connections_url = f"{self.api_url}/connections"
            response = self.session.get(connections_url)
            response.raise_for_status()
            
            connections_data = response.json()
            connections = {}
            
            for conn in connections_data:
                if conn.get('name') and not conn.get('name').startswith('looker'):
                    connections[conn['name']] = {
                        'name': conn['name'],
                        'dialect': conn.get('dialect', {}).get('name', 'unknown'),
                        'database': conn.get('database', 'unknown')
                    }
            
            print(f"Found {len(connections)} available connections:")
            for name, info in connections.items():
                print(f"  - {name} ({info['dialect']})")
            
            return connections
            
        except Exception as e:
            print(f"Failed to get connections: {e}")
            return {}
    
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
                
                # Extract SQL from different LookML contexts
                file_queries = []
                
                # Extract from derived tables
                file_queries.extend(self.extract_derived_table_sql(content, file_path))
                
                # Extract from dimension/measure sql (only complex SQL)
                file_queries.extend(self.extract_complex_field_sql(content, file_path))
                
                sql_queries.extend(file_queries)
                
                if file_queries:
                    print(f"   Found {len(file_queries)} SQL queries")
                
            except Exception as e:
                error_msg = f"Error reading file {file_path}: {e}"
                self.validation_results['errors'].append(error_msg)
                print(f"❌ {error_msg}")
        
        self.validation_results['summary']['total_queries_found'] = len(sql_queries)
        return sql_queries
    
    def extract_derived_table_sql(self, content: str, file_path: str) -> List[Dict[str, Any]]:
        """Extract SQL from derived tables - these are the most important to test"""
        sql_queries = []
        
        # Pattern to match view with derived_table
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
                sql_pattern = r'sql:\s*(.*?)(?=\s*(?:datagroup_trigger|distribution_style|sortkeys|indexes|persist_for|\}|;;))'
                sql_match = re.search(sql_pattern, derived_content, re.DOTALL)
                
                if sql_match:
                    sql_content = sql_match.group(1).strip()
                    # Clean up the SQL
                    sql_content = self.clean_sql(sql_content)
                    
                    if sql_content and len(sql_content) > 10:  # Only substantial SQL
                        # Try to detect connection from sql_table_name or guess
                        connection_name = self.detect_connection_for_sql(derived_content, sql_content)
                        
                        sql_queries.append({
                            'type': 'derived_table',
                            'view_name': view_name,
                            'file_path': file_path,
                            'sql_content': sql_content,
                            'connection_name': connection_name,
                            'line_number': content[:match.start()].count('\n') + 1,
                            'context': f"view: {view_name} > derived_table"
                        })
        
        return sql_queries
    
    def extract_complex_field_sql(self, content: str, file_path: str) -> List[Dict[str, Any]]:
        """Extract complex SQL from dimensions/measures (not simple field references)"""
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
                sql_pattern = r'sql:\s*(.*?)(?=\s*(?:type:|label:|description:|hidden:|\}|;;))'
                sql_match = re.search(sql_pattern, field_content, re.DOTALL)
                
                if sql_match:
                    sql_content = sql_match.group(1).strip()
                    sql_content = self.clean_sql(sql_content)
                    
                    # Only include complex SQL (has SELECT, CASE, subqueries, functions)
                    if self.is_complex_sql(sql_content):
                        # For field SQL, we need to wrap it in a SELECT to test
                        test_sql = f"SELECT ({sql_content}) as test_field FROM dual LIMIT 1"
                        
                        connection_name = self.detect_connection_from_context(content, field_content)
                        
                        sql_queries.append({
                            'type': f'{field_type}_sql',
                            'field_name': field_name,
                            'field_type': field_type,
                            'file_path': file_path,
                            'sql_content': test_sql,
                            'original_sql': sql_content,
                            'connection_name': connection_name,
                            'line_number': content[:match.start()].count('\n') + 1,
                            'context': f"{field_type}: {field_name}"
                        })
        
        return sql_queries
    
    def clean_sql(self, sql_content: str) -> str:
        """Clean SQL content for execution"""
        # Remove LookML comment delimiters
        sql_content = re.sub(r';;.*$', '', sql_content, flags=re.MULTILINE)
        # Remove extra whitespace
        sql_content = re.sub(r'\s+', ' ', sql_content.strip())
        # Remove trailing semicolons and delimiters
        sql_content = sql_content.strip(' \n\t;')
        return sql_content
    
    def is_complex_sql(self, sql_content: str) -> bool:
        """Check if SQL is complex enough to warrant execution testing"""
        sql_upper = sql_content.upper()
        
        # Consider it complex if it has:
        complex_indicators = [
            'SELECT',      # Subqueries
            'CASE',        # Case statements  
            'WHEN',        # Case conditions
            'CONCAT',      # String functions
            'COALESCE',    # Null handling
            'CAST',        # Type conversion
            'EXTRACT',     # Date functions
            'SUBSTRING',   # String manipulation
            '(',           # Function calls
        ]
        
        # Must have at least 2 indicators and be substantial
        indicator_count = sum(1 for indicator in complex_indicators if indicator in sql_upper)
        return indicator_count >= 2 and len(sql_content) > 20
    
    def detect_connection_for_sql(self, derived_content: str, sql_content: str) -> str:
        """Try to detect which connection to use for SQL execution"""
        # Look for connection in derived_table
        connection_match = re.search(r'connection:\s*"([^"]+)"', derived_content)
        if connection_match:
            return connection_match.group(1)
        
        # Try to detect from table names in SQL
        if 'bigquery-public-data' in sql_content:
            return 'bigquery_connection'  # This would need to be configured
        
        # Default fallback - would need to be configured per environment
        return 'default_connection'
    
    def detect_connection_from_context(self, full_content: str, field_content: str) -> str:
        """Detect connection for field SQL from context"""
        # Look for connection in the view or model
        connection_match = re.search(r'connection:\s*"([^"]+)"', full_content)
        if connection_match:
            return connection_match.group(1)
        
        return 'default_connection'
    
    def execute_sql_query(self, sql_query: Dict[str, Any]) -> Dict[str, Any]:
        """Execute SQL query using Looker SQL Runner API"""
        try:
            print(f"🧪 Testing SQL: {sql_query['context']}")
            
            # Use SQL Runner API
            sql_runner_url = f"{self.api_url}/sql_runners"
            
            # Prepare payload
            payload = {
                'sql': sql_query['sql_content'],
                'limit': 1,  # Just test execution, don't return data
                'apply_formatting': False,
                'cache': False  # Don't use cache for testing
            }
            
            # Add connection if available
            if sql_query['connection_name'] and sql_query['connection_name'] in self.connections:
                payload['connection_name'] = sql_query['connection_name']
                print(f"   Using connection: {sql_query['connection_name']}")
            else:
                # Try to find a working connection
                if self.connections:
                    payload['connection_name'] = list(self.connections.keys())[0]
                    print(f"   Using default connection: {payload['connection_name']}")
            
            # Execute the query
            response = self.session.post(sql_runner_url, json=payload)
            
            execution_result = {
                'query_info': sql_query,
                'execution_status': 'success' if response.status_code == 200 else 'error',
                'status_code': response.status_code,
                'errors': [],
                'warnings': [],
                'connection_used': payload.get('connection_name', 'unknown'),
                'timestamp': datetime.now().isoformat()
            }
            
            if response.status_code == 200:
                print(f"   ✅ SQL execution successful")
                self.validation_results['summary']['queries_passed'] += 1
            else:
                # Parse error response
                try:
                    error_data = response.json()
                    error_message = error_data.get('message', 'Unknown execution error')
                    
                    # Check for specific error types
                    if 'syntax' in error_message.lower() or 'parse' in error_message.lower():
                        execution_result['errors'].append(f"Syntax Error: {error_message}")
                        print(f"   ❌ Syntax Error: {error_message}")
                    elif 'not exist' in error_message.lower() or 'not found' in error_message.lower():
                        execution_result['errors'].append(f"Schema Error: {error_message}")
                        print(f"   ❌ Schema Error: {error_message}")
                    else:
                        execution_result['errors'].append(f"Execution Error: {error_message}")
                        print(f"   ❌ Execution Error: {error_message}")
                    
                    self.validation_results['summary']['queries_with_execution_errors'] += 1
                    
                except json.JSONDecodeError:
                    error_msg = f"HTTP {response.status_code}: {response.text[:200]}"
                    execution_result['errors'].append(error_msg)
                    print(f"   ❌ {error_msg}")
                    self.validation_results['summary']['queries_with_execution_errors'] += 1
            
            return execution_result
            
        except Exception as e:
            error_result = {
                'query_info': sql_query,
                'execution_status': 'error',
                'errors': [f"Execution failed: {str(e)}"],
                'timestamp': datetime.now().isoformat()
            }
            print(f"   ❌ Execution failed: {str(e)}")
            self.validation_results['summary']['queries_with_execution_errors'] += 1
            return error_result
    
    def run_sql_execution_tests(self, file_paths: List[str]) -> bool:
        """Main function to run SQL execution tests"""
        print("=" * 60)
        print("SQL EXECUTION TESTING FOR LOOKML")
        print("=" * 60)
        
        if not self.authenticate():
            return False
        
        # Get available connections
        self.connections = self.get_connections()
        if not self.connections:
            print("⚠️ No database connections available")
            return False
        
        self.validation_results['summary']['connections_used'] = list(self.connections.keys())
        
        # Extract SQL queries
        sql_queries = self.extract_sql_from_lookml_files(file_paths)
        
        if not sql_queries:
            print("ℹ️ No SQL queries found for execution testing")
            return True
        
        print(f"\n🧪 Testing {len(sql_queries)} SQL queries for execution...")
        
        # Execute each SQL query
        for i, sql_query in enumerate(sql_queries, 1):
            print(f"\n[{i}/{len(sql_queries)}] {sql_query['file_path']}:{sql_query['line_number']}")
            
            execution_result = self.execute_sql_query(sql_query)
            self.validation_results['sql_executions'].append(execution_result)
            self.validation_results['summary']['total_queries_tested'] += 1
            
            # Collect errors for final report
            for error in execution_result.get('errors', []):
                error_msg = f"{sql_query['file_path']}:{sql_query['line_number']} - {error}"
                self.validation_results['errors'].append(error_msg)
            
            # Small delay to be respectful to API
            time.sleep(0.2)
        
        return self.validation_results['summary']['queries_with_execution_errors'] == 0
    
    def print_summary(self):
        """Print execution testing summary"""
        print(f"\n" + "=" * 60)
        print("SQL EXECUTION TESTING SUMMARY")
        print("=" * 60)
        
        summary = self.validation_results['summary']
        print(f"Files processed: {summary['files_processed']}")
        print(f"SQL queries found: {summary['total_queries_found']}")
        print(f"Queries tested: {summary['total_queries_tested']}")
        print(f"Queries passed: {summary['queries_passed']}")
        print(f"Queries with execution errors: {summary['queries_with_execution_errors']}")
        print(f"Connections used: {', '.join(summary['connections_used'])}")
        
        if summary['queries_with_execution_errors'] == 0:
            print("\n✅ All SQL queries executed successfully!")
        else:
            print(f"\n❌ {summary['queries_with_execution_errors']} SQL queries failed execution")
            print("\nExecution errors found:")
            for error in self.validation_results['errors']:
                print(f"  • {error}")
    
    def save_results(self, output_file: str = 'sql_validation_results.json'):
        """Save execution results to JSON file"""
        try:
            with open(output_file, 'w') as f:
                json.dump(self.validation_results, f, indent=2)
            print(f"📄 SQL execution results saved to {output_file}")
        except Exception as e:
            print(f"❌ Failed to save results: {e}")


def main():
    parser = argparse.ArgumentParser(description='Test SQL execution for LookML queries')
    parser.add_argument('--files', required=True, help='Space-separated list of files to test')
    parser.add_argument('--config-file', default='looker.ini', help='Looker configuration file')
    parser.add_argument('--output-file', default='sql_validation_results.json', help='Output file for results')
    
    args = parser.parse_args()
    
    files_to_test = args.files.split()
    
    print(f"🚀 Starting SQL execution testing for {len(files_to_test)} files")
    
    validator = SQLExecutionValidator(args.config_file)
    success = validator.run_sql_execution_tests(files_to_test)
    validator.print_summary()
    validator.save_results(args.output_file)
    
    if success:
        print("✅ All SQL execution tests passed!")
        sys.exit(0)
    else:
        print("❌ SQL execution tests found errors!")
        sys.exit(1)


if __name__ == '__main__':
    main()
