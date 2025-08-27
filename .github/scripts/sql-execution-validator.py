#!/usr/bin/env python3
"""
SQL Execution Validator for LookML - Corrected Two-Step API Workflow
Tests actual SQL execution against database connections using proper Looker SQL Runner API
"""

import json
import sys
import argparse
import configparser
import requests
import os
import re
from typing import Dict, List, Any, Tuple, Optional
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
        self.default_connection = None
        
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
            print("🔐 Authenticating with Looker API...")
            response = self.session.post(login_url, data=login_data)
            response.raise_for_status()
            
            auth_data = response.json()
            self.access_token = auth_data.get('access_token')
            
            if not self.access_token:
                print("❌ Failed to obtain access token")
                return False
                
            self.session.headers.update({
                'Authorization': f'Bearer {self.access_token}',
                'Content-Type': 'application/json'
            })
            
            print("✅ Successfully authenticated with Looker API")
            return True
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Authentication failed: {e}")
            return False
    
    def get_connections(self) -> Dict[str, Dict[str, Any]]:
        """Get available database connections from Looker"""
        try:
            print("🔗 Fetching available connections...")
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
                        'database': conn.get('database', 'unknown'),
                        'host': conn.get('host', 'unknown')
                    }
            
            print(f"🔗 Found {len(connections)} available connections:")
            for name, info in connections.items():
                print(f"  • {name} ({info['dialect']}) - {info['database']}")
            
            # Set default connection (you might want to configure this)
            if connections:
                # Look for specific connection names first
                preferred_connections = ['badal_internal_projects', 'bigquery', 'default']
                for pref in preferred_connections:
                    if pref in connections:
                        self.default_connection = pref
                        break
                
                # If no preferred connection found, use first available
                if not self.default_connection:
                    self.default_connection = list(connections.keys())[0]
                
                print(f"🎯 Default connection: {self.default_connection}")
            
            self.connections = connections
            return connections
            
        except Exception as e:
            print(f"❌ Failed to get connections: {e}")
            return {}
    
    def create_sql_query(self, sql: str, connection_name: str) -> Optional[str]:
        """
        Step 1: Create a SQL Runner Query using correct API workflow
        Returns the query slug if successful
        """
        try:
            print(f"📝 Creating SQL query...")
            
            # Create SQL query endpoint (correct API)
            create_url = f"{self.api_url}/sql_queries"
            
            # Prepare payload for creating SQL query
            payload = {
                'sql': sql.strip(),
                'connection_name': connection_name
            }
            
            response = self.session.post(create_url, json=payload)
            
            if response.status_code == 200:
                query_data = response.json()
                query_slug = query_data.get('slug')
                
                if query_slug:
                    print(f"✅ SQL query created successfully with slug: {query_slug}")
                    return query_slug
                else:
                    print("❌ No query slug returned")
                    return None
            else:
                try:
                    error_data = response.json()
                    error_message = error_data.get('message', 'Unknown error')
                    print(f"❌ Failed to create query: {error_message}")
                except json.JSONDecodeError:
                    print(f"❌ Failed to create query: HTTP {response.status_code}: {response.text[:200]}")
                return None
                
        except Exception as e:
            print(f"❌ Exception creating query: {e}")
            return None
    
    def run_sql_query(self, query_slug: str, result_format: str = 'json') -> Dict[str, Any]:
        """
        Step 2: Run the SQL Runner Query using correct API workflow
        """
        try:
            print(f"🧪 Running SQL query with slug: {query_slug}")
            
            # Run SQL query endpoint (correct API)
            run_url = f"{self.api_url}/sql_queries/{query_slug}/run/{result_format}"
            
            start_time = datetime.now()
            response = self.session.post(run_url)
            end_time = datetime.now()
            execution_time = (end_time - start_time).total_seconds()
            
            result = {
                'success': response.status_code == 200,
                'status_code': response.status_code,
                'execution_time_seconds': execution_time,
                'query_slug': query_slug,
                'timestamp': start_time.isoformat(),
                'result_format': result_format,
                'errors': [],
                'warnings': []
            }
            
            if response.status_code == 200:
                # Query executed successfully
                try:
                    if result_format == 'json':
                        query_result = response.json()
                        
                        # Handle different response formats
                        if isinstance(query_result, list):
                            result.update({
                                'data': query_result,
                                'row_count': len(query_result),
                                'truncated': False
                            })
                        elif isinstance(query_result, dict):
                            result.update({
                                'data': query_result.get('data', []),
                                'fields': query_result.get('fields', []),
                                'row_count': len(query_result.get('data', [])),
                                'truncated': query_result.get('truncated', False),
                                'query_id': query_result.get('query_id')
                            })
                        
                        print(f"✅ Query executed successfully!")
                        print(f"⏱️ Execution time: {execution_time:.2f} seconds")
                        print(f"📊 Returned {result.get('row_count', 0)} rows")
                        
                    else:
                        result['raw_response'] = response.text
                        print(f"✅ Query executed successfully in {result_format} format")
                
                except json.JSONDecodeError:
                    result['raw_response'] = response.text
                    print(f"✅ Query executed successfully (non-JSON response)")
            
            else:
                # Handle error response
                try:
                    error_data = response.json()
                    error_message = error_data.get('message', 'Unknown error')
                    
                    # Parse specific error types for better reporting
                    if any(keyword in error_message.lower() for keyword in ['syntax', 'parse', 'invalid']):
                        result['errors'].append(f"Syntax Error: {error_message}")
                        print(f"❌ Syntax Error: {error_message}")
                    elif any(keyword in error_message.lower() for keyword in ['not exist', 'not found', 'unknown']):
                        result['errors'].append(f"Schema Error: {error_message}")
                        print(f"❌ Schema Error: {error_message}")
                    elif any(keyword in error_message.lower() for keyword in ['permission', 'access', 'denied']):
                        result['errors'].append(f"Permission Error: {error_message}")
                        print(f"❌ Permission Error: {error_message}")
                    else:
                        result['errors'].append(f"Execution Error: {error_message}")
                        print(f"❌ Execution Error: {error_message}")
                    
                    # Include full error details for debugging
                    result['error_details'] = error_data
                    
                except json.JSONDecodeError:
                    error_msg = f"HTTP {response.status_code}: {response.text[:200]}"
                    result['errors'].append(error_msg)
                    print(f"❌ {error_msg}")
            
            return result
            
        except Exception as e:
            error_result = {
                'success': False,
                'error': f"Execution failed: {str(e)}",
                'errors': [f"Exception: {str(e)}"],
                'timestamp': datetime.now().isoformat(),
                'query_slug': query_slug
            }
            print(f"❌ Exception running query: {e}")
            return error_result
    
    def execute_sql_complete_workflow(self, sql: str, connection_name: str) -> Dict[str, Any]:
        """
        Complete two-step workflow: Create and run SQL query
        """
        print(f"🚀 Executing SQL query on connection: {connection_name}")
        print(f"📝 Query preview: {sql[:100]}{'...' if len(sql) > 100 else ''}")
        
        # Step 1: Create the query
        query_slug = self.create_sql_query(sql, connection_name)
        if not query_slug:
            return {
                'success': False,
                'errors': ['Failed to create SQL query'],
                'timestamp': datetime.now().isoformat(),
                'connection_name': connection_name
            }
        
        # Step 2: Run the query
        result = self.run_sql_query(query_slug, 'json')
        result['connection_name'] = connection_name
        return result
    
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
                
                # Extract from derived tables (most important for validation)
                file_queries.extend(self.extract_derived_table_sql(content, file_path))
                
                sql_queries.extend(file_queries)
                
                if file_queries:
                    print(f"   Found {len(file_queries)} SQL queries to test")
                
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
                        # Try to detect connection from the derived_table or use default
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
    
    def clean_sql(self, sql_content: str) -> str:
        """Clean SQL content for execution"""
        # Remove LookML comment delimiters
        sql_content = re.sub(r';;.*$', '', sql_content, flags=re.MULTILINE)
        # Clean up whitespace but preserve structure
        lines = sql_content.split('\n')
        cleaned_lines = [line.strip() for line in lines if line.strip()]
        sql_content = '\n'.join(cleaned_lines)
        return sql_content.strip()
    
    def detect_connection_for_sql(self, derived_content: str, sql_content: str) -> str:
        """Try to detect which connection to use for SQL execution"""
        # Look for connection in derived_table
        connection_match = re.search(r'connection:\s*"([^"]+)"', derived_content)
        if connection_match:
            conn_name = connection_match.group(1)
            if conn_name in self.connections:
                return conn_name
        
        # Look for BigQuery patterns in SQL
        if 'bigquery-public-data' in sql_content or '`' in sql_content:
            # Look for BigQuery connections
            for conn_name, conn_info in self.connections.items():
                if 'bigquery' in conn_info['dialect'].lower():
                    return conn_name
        
        # Use default connection
        return self.default_connection or list(self.connections.keys())[0] if self.connections else 'unknown'
    
    def run_sql_execution_tests(self, file_paths: List[str]) -> bool:
        """Main function to run SQL execution tests"""
        print("=" * 60)
        print("SQL EXECUTION TESTING FOR LOOKML")
        print("Using Correct Two-Step Looker API Workflow")
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
        
        # Execute each SQL query using two-step workflow
        for i, sql_query in enumerate(sql_queries, 1):
            print(f"\n[{i}/{len(sql_queries)}] {sql_query['file_path']}:{sql_query['line_number']}")
            print(f"📍 Context: {sql_query['context']}")
            
            # Execute using correct two-step API workflow
            execution_result = self.execute_sql_complete_workflow(
                sql_query['sql_content'], 
                sql_query['connection_name']
            )
            
            # Add query info to result
            execution_result['query_info'] = sql_query
            
            self.validation_results['sql_executions'].append(execution_result)
            self.validation_results['summary']['total_queries_tested'] += 1
            
            # Track results
            if execution_result['success']:
                self.validation_results['summary']['queries_passed'] += 1
            else:
                self.validation_results['summary']['queries_with_execution_errors'] += 1
                
                # Collect errors for final report
                for error in execution_result.get('errors', []):
                    error_msg = f"{sql_query['file_path']}:{sql_query['line_number']} - {error}"
                    self.validation_results['errors'].append(error_msg)
            
            # Small delay to be respectful to API
            time.sleep(0.3)
        
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
        print(f"Connections available: {', '.join(summary['connections_used'])}")
        
        if summary['queries_with_execution_errors'] == 0:
            print("\n✅ All SQL queries executed successfully!")
        else:
            print(f"\n❌ {summary['queries_with_execution_errors']} SQL queries failed execution")
            print("\nExecution errors found:")
            for error in self.validation_results['errors'][:10]:  # Show first 10 errors
                print(f"  • {error}")
            
            if len(self.validation_results['errors']) > 10:
                print(f"  ... and {len(self.validation_results['errors']) - 10} more errors")
    
    def save_results(self, output_file: str = 'sql_validation_results.json'):
        """Save execution results to JSON file"""
        try:
            with open(output_file, 'w') as f:
                json.dump(self.validation_results, f, indent=2, default=str)
            print(f"📄 SQL execution results saved to {output_file}")
        except Exception as e:
            print(f"❌ Failed to save results: {e}")


def main():
    parser = argparse.ArgumentParser(description='Test SQL execution for LookML queries using correct Looker API workflow')
    parser.add_argument('--files', required=True, help='Space-separated list of files to test')
    parser.add_argument('--config-file', default='looker.ini', help='Looker configuration file')
    parser.add_argument('--output-file', default='sql_validation_results.json', help='Output file for results')
    
    args = parser.parse_args()
    
    files_to_test = args.files.split()
    
    print(f"🚀 Starting SQL execution testing for {len(files_to_test)} files")
    print("Using correct two-step Looker SQL Runner API workflow")
    
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
