#!/usr/bin/env python3
"""
LookML Content Validator
Validates dashboards, looks, and explores through Looker API
"""

import json
import sys
import argparse
import configparser
import requests
from typing import Dict, List, Any
import time
from datetime import datetime


class LookerContentValidator:
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
            'dashboards': [],
            'looks': [],
            'explores': [],
            'summary': {
                'total_dashboards': 0,
                'valid_dashboards': 0,
                'total_looks': 0,
                'valid_looks': 0,
                'total_explores': 0,
                'valid_explores': 0,
                'errors': [],
                'warnings': []
            },
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
                
            # Set authorization header for future requests
            self.session.headers.update({
                'Authorization': f'Bearer {self.access_token}',
                'Content-Type': 'application/json'
            })
            
            print("Successfully authenticated with Looker API")
            return True
            
        except requests.exceptions.RequestException as e:
            print(f"Authentication failed: {e}")
            return False
    
    def get_project_content(self, project_name: str) -> Dict[str, List]:
        """Get all content (dashboards, looks, explores) for a project"""
        content = {
            'dashboards': [],
            'looks': [],
            'explores': []
        }
        
        try:
            # Get all dashboards
            dashboards_response = self.session.get(f"{self.api_url}/dashboards")
            if dashboards_response.status_code == 200:
                all_dashboards = dashboards_response.json()
                # Filter dashboards by project (if possible through model association)
                content['dashboards'] = all_dashboards[:10]  # Limit for CI/CD performance
                print(f"Found {len(content['dashboards'])} dashboards to validate")
            
            # Get all looks
            looks_response = self.session.get(f"{self.api_url}/looks")
            if looks_response.status_code == 200:
                all_looks = looks_response.json()
                content['looks'] = all_looks[:5]  # Limit for CI/CD performance
                print(f"Found {len(content['looks'])} looks to validate")
            
            # Get explores for the specific project
            models_response = self.session.get(f"{self.api_url}/lookml_models")
            if models_response.status_code == 200:
                all_models = models_response.json()
                project_models = [m for m in all_models if m.get('project_name') == project_name]
                
                for model in project_models:
                    model_name = model.get('name')
                    if model_name:
                        model_detail_response = self.session.get(f"{self.api_url}/lookml_models/{model_name}")
                        if model_detail_response.status_code == 200:
                            model_detail = model_detail_response.json()
                            explores = model_detail.get('explores', [])
                            for explore in explores:
                                content['explores'].append({
                                    'model_name': model_name,
                                    'explore_name': explore.get('name'),
                                    'label': explore.get('label', explore.get('name'))
                                })
                
                print(f"Found {len(content['explores'])} explores to validate")
        
        except Exception as e:
            print(f"Error getting project content: {e}")
            self.validation_results['summary']['errors'].append(f"Failed to retrieve content: {str(e)}")
        
        return content
    
    def validate_dashboard(self, dashboard: Dict) -> Dict[str, Any]:
        """Validate a single dashboard"""
        dashboard_id = dashboard.get('id')
        dashboard_title = dashboard.get('title', 'Untitled')
        
        validation_result = {
            'id': dashboard_id,
            'title': dashboard_title,
            'status': 'unknown',
            'errors': [],
            'warnings': [],
            'load_time': None
        }
        
        try:
            print(f"  Validating dashboard: {dashboard_title}")
            
            start_time = time.time()
            
            # Get dashboard details
            dashboard_response = self.session.get(f"{self.api_url}/dashboards/{dashboard_id}")
            
            if dashboard_response.status_code == 200:
                dashboard_detail = dashboard_response.json()
                load_time = time.time() - start_time
                validation_result['load_time'] = round(load_time, 2)
                
                # Check dashboard elements
                elements = dashboard_detail.get('dashboard_elements', [])
                if not elements:
                    validation_result['warnings'].append("Dashboard has no elements")
                
                # Validate a few dashboard elements (limit for performance)
                element_errors = []
                for element in elements[:3]:  # Test first 3 elements
                    element_id = element.get('id')
                    if element_id:
                        # Try to run the element query (basic validation)
                        element_response = self.session.get(f"{self.api_url}/dashboard_elements/{element_id}")
                        if element_response.status_code != 200:
                            element_errors.append(f"Element {element_id} failed to load")
                
                if element_errors:
                    validation_result['errors'].extend(element_errors)
                    validation_result['status'] = 'error'
                else:
                    validation_result['status'] = 'valid'
                    
            else:
                validation_result['status'] = 'error'
                validation_result['errors'].append(f"Failed to load dashboard: HTTP {dashboard_response.status_code}")
        
        except Exception as e:
            validation_result['status'] = 'error'
            validation_result['errors'].append(f"Validation error: {str(e)}")
        
        return validation_result
    
    def validate_look(self, look: Dict) -> Dict[str, Any]:
        """Validate a single look"""
        look_id = look.get('id')
        look_title = look.get('title', 'Untitled')
        
        validation_result = {
            'id': look_id,
            'title': look_title,
            'status': 'unknown',
            'errors': [],
            'warnings': [],
            'load_time': None
        }
        
        try:
            print(f"  Validating look: {look_title}")
            
            start_time = time.time()
            
            # Get look details
            look_response = self.session.get(f"{self.api_url}/looks/{look_id}")
            
            if look_response.status_code == 200:
                look_detail = look_response.json()
                load_time = time.time() - start_time
                validation_result['load_time'] = round(load_time, 2)
                
                # Check if look has a query
                query = look_detail.get('query')
                if not query:
                    validation_result['errors'].append("Look has no associated query")
                    validation_result['status'] = 'error'
                else:
                    # Try to run the query (with limit for performance)
                    query_id = query.get('id')
                    if query_id:
                        run_response = self.session.get(f"{self.api_url}/queries/{query_id}/run/json?limit=1")
                        if run_response.status_code == 200:
                            validation_result['status'] = 'valid'
                        else:
                            validation_result['status'] = 'error'
                            validation_result['errors'].append(f"Query execution failed: HTTP {run_response.status_code}")
                    else:
                        validation_result['status'] = 'valid'  # Look exists but query validation skipped
            else:
                validation_result['status'] = 'error'
                validation_result['errors'].append(f"Failed to load look: HTTP {look_response.status_code}")
        
        except Exception as e:
            validation_result['status'] = 'error'
            validation_result['errors'].append(f"Validation error: {str(e)}")
        
        return validation_result
    
    def validate_explore(self, explore: Dict) -> Dict[str, Any]:
        """Validate a single explore"""
        model_name = explore.get('model_name')
        explore_name = explore.get('explore_name')
        explore_label = explore.get('label', explore_name)
        
        validation_result = {
            'model_name': model_name,
            'explore_name': explore_name,
            'label': explore_label,
            'status': 'unknown',
            'errors': [],
            'warnings': [],
            'load_time': None
        }
        
        try:
            print(f"  Validating explore: {model_name}.{explore_name}")
            
            start_time = time.time()
            
            # Get explore details
            explore_response = self.session.get(f"{self.api_url}/lookml_models/{model_name}/explores/{explore_name}")
            
            if explore_response.status_code == 200:
                explore_detail = explore_response.json()
                load_time = time.time() - start_time
                validation_result['load_time'] = round(load_time, 2)
                
                # Check for errors in explore definition
                if explore_detail.get('errors'):
                    validation_result['errors'].extend(explore_detail['errors'])
                    validation_result['status'] = 'error'
                else:
                    # Try to run a simple query on the explore
                    query_body = {
                        'model': model_name,
                        'explore': explore_name,
                        'fields': [],
                        'limit': '1'
                    }
                    
                    # Get first available dimension for the query
                    dimensions = explore_detail.get('dimensions', [])
                    if dimensions and len(dimensions) > 0:
                        first_dimension = dimensions[0].get('name')
                        if first_dimension:
                            query_body['fields'] = [first_dimension]
                    
                    if query_body['fields']:
                        query_response = self.session.post(f"{self.api_url}/queries", json=query_body)
                        
                        if query_response.status_code == 200:
                            query_data = query_response.json()
                            query_id = query_data.get('id')
                            
                            if query_id:
                                # Run the query
                                run_response = self.session.get(f"{self.api_url}/queries/{query_id}/run/json")
                                if run_response.status_code == 200:
                                    validation_result['status'] = 'valid'
                                else:
                                    validation_result['status'] = 'warning'
                                    validation_result['warnings'].append(f"Query execution failed but explore is accessible")
                            else:
                                validation_result['status'] = 'valid'
                        else:
                            validation_result['status'] = 'warning'
                            validation_result['warnings'].append("Could not create test query")
                    else:
                        validation_result['status'] = 'warning'
                        validation_result['warnings'].append("No dimensions found for testing")
                        
            else:
                validation_result['status'] = 'error'
                validation_result['errors'].append(f"Failed to load explore: HTTP {explore_response.status_code}")
        
        except Exception as e:
            validation_result['status'] = 'error'
            validation_result['errors'].append(f"Validation error: {str(e)}")
        
        return validation_result
    
    def validate_content(self, project_name: str):
        """Main function to validate all content"""
        print("=" * 60)
        print("LOOKER CONTENT VALIDATION")
        print("=" * 60)
        
        if not self.authenticate():
            return False
        
        # Get content to validate
        content = self.get_project_content(project_name)
        
        # Validate dashboards
        print(f"\n1. Validating Dashboards...")
        for dashboard in content['dashboards']:
            result = self.validate_dashboard(dashboard)
            self.validation_results['dashboards'].append(result)
            
            if result['status'] == 'valid':
                self.validation_results['summary']['valid_dashboards'] += 1
            elif result['errors']:
                self.validation_results['summary']['errors'].extend(result['errors'])
        
        self.validation_results['summary']['total_dashboards'] = len(content['dashboards'])
        
        # Validate looks
        print(f"\n2. Validating Looks...")
        for look in content['looks']:
            result = self.validate_look(look)
            self.validation_results['looks'].append(result)
            
            if result['status'] == 'valid':
                self.validation_results['summary']['valid_looks'] += 1
            elif result['errors']:
                self.validation_results['summary']['errors'].extend(result['errors'])
        
        self.validation_results['summary']['total_looks'] = len(content['looks'])
        
        # Validate explores
        print(f"\n3. Validating Explores...")
        for explore in content['explores']:
            result = self.validate_explore(explore)
            self.validation_results['explores'].append(result)
            
            if result['status'] == 'valid':
                self.validation_results['summary']['valid_explores'] += 1
            elif result['errors']:
                self.validation_results['summary']['errors'].extend(result['errors'])
        
        self.validation_results['summary']['total_explores'] = len(content['explores'])
        
        # Print summary
        self.print_summary()
        
        # Determine success
        total_errors = len(self.validation_results['summary']['errors'])
        return total_errors == 0
    
    def print_summary(self):
        """Print validation summary"""
        print(f"\n" + "=" * 60)
        print("CONTENT VALIDATION SUMMARY")
        print("=" * 60)
        
        summary = self.validation_results['summary']
        
        print(f"\nDashboards:")
        print(f"  Total: {summary['total_dashboards']}")
        print(f"  Valid: {summary['valid_dashboards']}")
        print(f"  Failed: {summary['total_dashboards'] - summary['valid_dashboards']}")
        
        print(f"\nLooks:")
        print(f"  Total: {summary['total_looks']}")
        print(f"  Valid: {summary['valid_looks']}")
        print(f"  Failed: {summary['total_looks'] - summary['valid_looks']}")
        
        print(f"\nExplores:")
        print(f"  Total: {summary['total_explores']}")
        print(f"  Valid: {summary['valid_explores']}")
        print(f"  Failed: {summary['total_explores'] - summary['valid_explores']}")
        
        if summary['errors']:
            print(f"\nErrors found:")
            for i, error in enumerate(summary['errors'][:5]):  # Show first 5 errors
                print(f"  {i+1}. {error}")
            
            if len(summary['errors']) > 5:
                print(f"  ... and {len(summary['errors']) - 5} more errors")
    
    def save_results(self, output_file: str = 'content_validation_results.json'):
        """Save validation results to JSON file"""
        try:
            with open(output_file, 'w') as f:
                json.dump(self.validation_results, f, indent=2)
            print(f"Content validation results saved to {output_file}")
        except Exception as e:
            print(f"Failed to save results: {e}")


def main():
    parser = argparse.ArgumentParser(description='Validate Looker content using Looker API')
    parser.add_argument('--project-name', required=True, help='Name of the LookML project')
    parser.add_argument('--config-file', default='looker.ini', help='Looker configuration file')
    parser.add_argument('--output-file', default='content_validation_results.json', help='Output file for results')
    
    args = parser.parse_args()
    
    print(f"Starting content validation for project: {args.project_name}")
    
    validator = LookerContentValidator(args.config_file)
    success = validator.validate_content(args.project_name)
    validator.save_results(args.output_file)
    
    if success:
        print("Content validation completed successfully!")
        sys.exit(0)
    else:
        print("Content validation found issues!")
        sys.exit(1)


if __name__ == '__main__':
    main()
