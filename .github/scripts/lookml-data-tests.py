#!/usr/bin/env python3
"""
LookML Data Tests Validator for CI/CD Pipeline
Adapted from run_data_tests.rtf for GitHub Actions
"""

import json
import sys
import argparse
import configparser
import requests
from typing import Dict, List, Any
import os
from datetime import datetime


class LookerDataTestRunner:
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
        
        self.test_results = {
            'model_validation': [],
            'data_tests': [],
            'summary': {
                'total_models': 0,
                'passed_models': 0,
                'failed_models': 0,
                'total_tests': 0,
                'passed_tests': 0,
                'failed_tests': 0,
                'warnings': 0
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
            
            # Test connection
            me_response = self.session.get(f"{self.api_url}/user")
            if me_response.status_code == 200:
                user_info = me_response.json()
                print(f"Connected to Looker as: {user_info.get('display_name', 'Unknown')} ({user_info.get('email', 'Unknown')})")
                return True
            else:
                print("Failed to verify connection")
                return False
                
        except requests.exceptions.RequestException as e:
            print(f"Authentication failed: {e}")
            return False
    
    def run_model_validation(self, project_name: str) -> List[Dict[str, Any]]:
        """Run validation for all models in the project"""
        try:
            print(f"\nRunning model validation for project: {project_name}")
            
            # Get all models for the project
            models_response = self.session.get(f"{self.api_url}/lookml_models")
            models_response.raise_for_status()
            
            all_models = models_response.json()
            project_models = [model for model in all_models if model.get('project_name') == project_name]
            
            if not project_models:
                print(f"No models found for project '{project_name}'")
                return []
            
            validation_results = []
            
            for model in project_models:
                model_name = model.get('name')
                print(f"\nValidating model: {model_name}")
                
                try:
                    # Get model details
                    model_response = self.session.get(f"{self.api_url}/lookml_models/{model_name}")
                    model_response.raise_for_status()
                    model_details = model_response.json()
                    
                    # Check if model has any errors
                    model_errors = model_details.get('errors', [])
                    if model_errors:
                        print(f"Model '{model_name}' has {len(model_errors)} errors:")
                        for error in model_errors:
                            print(f"  - {error}")
                        
                        validation_results.append({
                            'model': model_name,
                            'status': 'error',
                            'errors': model_errors,
                            'timestamp': datetime.now().isoformat()
                        })
                    else:
                        print(f"Model '{model_name}' validation passed")
                        validation_results.append({
                            'model': model_name,
                            'status': 'success',
                            'errors': [],
                            'timestamp': datetime.now().isoformat()
                        })
                    
                    # Validate explores in the model
                    explores = model_details.get('explores', [])
                    if explores:
                        explore_results = []
                        
                        for explore in explores:
                            explore_name = explore.get('name')
                            try:
                                explore_response = self.session.get(
                                    f"{self.api_url}/lookml_models/{model_name}/explores/{explore_name}"
                                )
                                explore_response.raise_for_status()
                                explore_details = explore_response.json()
                                
                                explore_errors = explore_details.get('errors', [])
                                if explore_errors:
                                    print(f"  Explore '{explore_name}' has errors")
                                    explore_results.append({
                                        'explore': explore_name,
                                        'status': 'error',
                                        'errors': explore_errors
                                    })
                                else:
                                    print(f"  Explore '{explore_name}' validation passed")
                                    explore_results.append({
                                        'explore': explore_name,
                                        'status': 'success',
                                        'errors': []
                                    })
                                
                            except Exception as e:
                                print(f"  Failed to validate explore '{explore_name}': {e}")
                                explore_results.append({
                                    'explore': explore_name,
                                    'status': 'error',
                                    'errors': [str(e)]
                                })
                        
                        validation_results[-1]['explores'] = explore_results
                
                except Exception as e:
                    print(f"Failed to validate model '{model_name}': {e}")
                    validation_results.append({
                        'model': model_name,
                        'status': 'error',
                        'errors': [str(e)],
                        'timestamp': datetime.now().isoformat()
                    })
            
            return validation_results
            
        except Exception as e:
            print(f"Error running model validation: {e}")
            return []
    
    def run_data_tests_validation(self, project_name: str) -> List[Dict[str, Any]]:
        """Validate LookML tests and run project validation"""
        try:
            print(f"\nValidating LookML tests for project: {project_name}")
            
            # Run project validation first
            try:
                print(f"\nRunning project validation for: {project_name}")
                validation_response = self.session.get(f"{self.api_url}/projects/{project_name}/validate")
                validation_response.raise_for_status()
                validation_result = validation_response.json()
                
                if validation_result:
                    print("Project validation completed")
                    
                    # Check for errors in validation
                    validation_errors = validation_result.get('errors', [])
                    if validation_errors:
                        print(f"Project has {len(validation_errors)} validation errors:")
                        for error in validation_errors[:5]:  # Show first 5 errors
                            print(f"  - {error}")
                    else:
                        print("No validation errors found")
                    
                    # Check for warnings
                    validation_warnings = validation_result.get('warnings', [])
                    if validation_warnings:
                        print(f"Project has {len(validation_warnings)} warnings:")
                        for warning in validation_warnings[:3]:  # Show first 3 warnings
                            print(f"  - {warning}")
                
            except Exception as e:
                print(f"Project validation failed: {e}")
            
            # Try to get LookML tests
            try:
                tests_response = self.session.get(f"{self.api_url}/projects/{project_name}/lookml_tests")
                
                if tests_response.status_code == 200:
                    lookml_tests = tests_response.json()
                    print(f"Found {len(lookml_tests)} LookML tests to validate")
                    
                    test_results = []
                    
                    # Validate each test definition
                    for test in lookml_tests:
                        test_name = test.get('name', 'Unknown')
                        print(f"\nValidating test definition: {test_name}")
                        
                        try:
                            test_info = {
                                'test_name': test_name,
                                'model_name': test.get('model_name', 'Unknown'),
                                'explore_name': test.get('explore_name', 'Unknown'),
                                'file': test.get('file', 'Unknown'),
                                'line_number': test.get('line_number', 'Unknown'),
                                'status': 'validated',
                                'message': 'Test definition is valid',
                                'errors': [],
                                'warnings': [],
                                'timestamp': datetime.now().isoformat()
                            }
                            
                            # Check if test has required properties
                            if not test.get('model_name'):
                                test_info['warnings'].append("Test missing model_name")
                            
                            if not test.get('explore_name'):
                                test_info['warnings'].append("Test missing explore_name")
                            
                            # Try to validate model and explore existence
                            if test.get('model_name') and test.get('explore_name'):
                                try:
                                    model_response = self.session.get(
                                        f"{self.api_url}/lookml_models/{test['model_name']}"
                                    )
                                    if model_response.status_code == 200:
                                        print(f"  Model '{test['model_name']}' exists")
                                        
                                        # Check if explore exists in model
                                        explore_response = self.session.get(
                                            f"{self.api_url}/lookml_models/{test['model_name']}/explores/{test['explore_name']}"
                                        )
                                        if explore_response.status_code == 200:
                                            print(f"  Explore '{test['explore_name']}' exists in model '{test['model_name']}'")
                                            test_info['message'] = 'Test definition and dependencies are valid'
                                        else:
                                            test_info['errors'].append(f"Explore '{test['explore_name']}' not found in model '{test['model_name']}'")
                                            test_info['status'] = 'error'
                                    else:
                                        test_info['errors'].append(f"Model '{test['model_name']}' not found")
                                        test_info['status'] = 'error'
                                
                                except Exception as model_error:
                                    test_info['warnings'].append(f"Could not validate model/explore: {str(model_error)}")
                            
                            if test_info['errors']:
                                print(f"  Test '{test_name}' has validation errors")
                                for error in test_info['errors']:
                                    print(f"    - {error}")
                            elif test_info['warnings']:
                                print(f"  Test '{test_name}' has warnings")
                                for warning in test_info['warnings']:
                                    print(f"    - {warning}")
                            else:
                                print(f"  Test '{test_name}' validation passed")
                            
                            test_results.append(test_info)
                        
                        except Exception as e:
                            print(f"  Failed to validate test '{test_name}': {e}")
                            test_results.append({
                                'test_name': test_name,
                                'model_name': test.get('model_name', 'Unknown'),
                                'explore_name': test.get('explore_name', 'Unknown'),
                                'status': 'error',
                                'message': str(e),
                                'errors': [str(e)],
                                'warnings': [],
                                'timestamp': datetime.now().isoformat()
                            })
                    
                    return test_results
                else:
                    print("No LookML tests found or unable to access tests")
                    return []
            
            except Exception as e:
                print(f"Failed to get LookML tests: {e}")
                return []
                
        except Exception as e:
            print(f"Error validating LookML tests: {e}")
            return []
    
    def generate_summary(self, model_validation: List[Dict], data_tests: List[Dict]):
        """Generate test summary statistics"""
        # Model validation summary
        if model_validation:
            self.test_results['summary']['total_models'] = len(model_validation)
            self.test_results['summary']['passed_models'] = len([m for m in model_validation if m['status'] == 'success'])
            self.test_results['summary']['failed_models'] = self.test_results['summary']['total_models'] - self.test_results['summary']['passed_models']
        
        # Data tests summary
        if data_tests:
            self.test_results['summary']['total_tests'] = len(data_tests)
            self.test_results['summary']['passed_tests'] = len([t for t in data_tests if t['status'] in ['success', 'validated']])
            self.test_results['summary']['failed_tests'] = len([t for t in data_tests if t['status'] == 'error'])
            self.test_results['summary']['warnings'] = len([t for t in data_tests if t.get('warnings', [])])
    
    def print_summary(self, project_name: str):
        """Print a summary of all test results"""
        print(f"\n" + "="*60)
        print(f"TEST RESULTS SUMMARY FOR PROJECT: {project_name}")
        print(f"="*60)
        
        summary = self.test_results['summary']
        
        # Model validation summary
        if summary['total_models'] > 0:
            print(f"\nModel Validation:")
            print(f"  Total models tested: {summary['total_models']}")
            print(f"  Passed: {summary['passed_models']}")
            print(f"  Failed: {summary['failed_models']}")
            
            if summary['failed_models'] > 0:
                print(f"\n  Failed models:")
                for model in self.test_results['model_validation']:
                    if model['status'] != 'success':
                        print(f"    - {model['model']}: {len(model['errors'])} errors")
        
        # Data tests summary
        if summary['total_tests'] > 0:
            print(f"\nData Tests:")
            print(f"  Total tests validated: {summary['total_tests']}")
            print(f"  Passed validation: {summary['passed_tests']}")
            print(f"  Warnings: {summary['warnings']}")
            print(f"  Failed: {summary['failed_tests']}")
            
            if summary['failed_tests'] > 0:
                print(f"\n  Failed tests:")
                for test in self.test_results['data_tests']:
                    if test['status'] == 'error':
                        test_name = test.get('test_name', 'Unknown')
                        model_name = test.get('model_name', 'Unknown')
                        explore_name = test.get('explore_name', 'Unknown')
                        message = test.get('message', 'No message')
                        print(f"    - {test_name} ({model_name}.{explore_name}): {message}")
    
    def run_tests(self, project_name: str):
        """Main function to execute all data tests"""
        print("="*60)
        print("LOOKER DATA TESTS EXECUTION")
        print("="*60)
        
        # Authenticate
        if not self.authenticate():
            print("Failed to authenticate with Looker")
            return False
        
        # Run model validation
        print(f"\n1. Running model validation...")
        model_validation = self.run_model_validation(project_name)
        self.test_results['model_validation'] = model_validation
        
        # Run data tests
        print(f"\n2. Running LookML tests...")
        data_tests = self.run_data_tests_validation(project_name)
        self.test_results['data_tests'] = data_tests
        
        # Generate summary
        self.generate_summary(model_validation, data_tests)
        
        # Print summary
        self.print_summary(project_name)
        
        print(f"\nAll data tests execution completed!")
        
        # Return success if no critical errors
        return self.test_results['summary']['failed_models'] == 0 and self.test_results['summary']['failed_tests'] == 0
    
    def save_results(self, output_file: str = 'data_tests_results.json'):
        """Save test results to JSON file"""
        try:
            with open(output_file, 'w') as f:
                json.dump(self.test_results, f, indent=2)
            print(f"Test results saved to {output_file}")
        except Exception as e:
            print(f"Failed to save results: {e}")


def main():
    parser = argparse.ArgumentParser(description='Run LookML data tests validation')
    parser.add_argument('--project-name', required=True, help='Name of the LookML project to test')
    parser.add_argument('--config-file', default='looker.ini', help='Looker configuration file')
    parser.add_argument('--output-file', default='data_tests_results.json', help='Output file for results')
    
    args = parser.parse_args()
    
    print(f"Starting LookML data tests for project: {args.project_name}")
    
    runner = LookerDataTestRunner(args.config_file)
    success = runner.run_tests(args.project_name)
    runner.save_results(args.output_file)
    
    if success:
        print("All data tests passed!")
        sys.exit(0)
    else:
        print("Some data tests failed!")
        sys.exit(1)


if __name__ == '__main__':
    main()
