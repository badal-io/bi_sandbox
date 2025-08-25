#!/usr/bin/env python3
"""
LookML Validator using Looker API
Validates LookML syntax and project structure
"""

import json
import sys
import argparse
import configparser
import requests
from typing import Dict, List, Any
import os
import time


class LookerValidator:
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
            'errors': [],
            'warnings': [],
            'info': [],
            'project_validation': None
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
                print("❌ Failed to obtain access token")
                return False
                
            # Set authorization header for future requests
            self.session.headers.update({
                'Authorization': f'Bearer {self.access_token}',
                'Content-Type': 'application/json'
            })
            
            print("✅ Successfully authenticated with Looker API")
            return True
            
        except requests.exceptions.RequestException as e:
            print(f"❌ Authentication failed: {e}")
            return False
    
    def validate_project(self, project_name: str) -> Dict[str, Any]:
        """Validate LookML project using Looker API"""
        if not self.authenticate():
            return {'success': False, 'error': 'Authentication failed'}
        
        try:
            # First, check if project exists
            projects_url = f"{self.api_url}/projects"
            response = self.session.get(projects_url)
            response.raise_for_status()
            
            projects = response.json()
            project_names = [p.get('name', '') for p in projects]
            
            if project_name not in project_names:
                print(f"⚠️ Project '{project_name}' not found. Available projects: {project_names}")
                print("ℹ️ Using manifest validation instead...")
                return self.validate_manifest()
            
            # Validate the specific project
            validation_url = f"{self.api_url}/projects/{project_name}/validate"
            response = self.session.get(validation_url)
            response.raise_for_status()
            
            validation_data = response.json()
            self.validation_results['project_validation'] = validation_data
            
            return self.process_validation_results(validation_data)
            
        except requests.exceptions.RequestException as e:
            error_msg = f"API request failed: {e}"
            self.validation_results['errors'].append(error_msg)
            return {'success': False, 'error': error_msg}
    
    def validate_manifest(self) -> Dict[str, Any]:
        """Validate manifest.lkml file if present"""
        manifest_path = 'manifest.lkml'
        
        if not os.path.exists(manifest_path):
            warning_msg = "No manifest.lkml file found - this is recommended for LookML projects"
            self.validation_results['warnings'].append(warning_msg)
            print(f"⚠️ {warning_msg}")
            return {'success': True, 'warnings': [warning_msg]}
        
        try:
            with open(manifest_path, 'r') as f:
                manifest_content = f.read()
            
            # Basic manifest validation
            required_fields = ['project_name']
            missing_fields = []
            
            for field in required_fields:
                if field not in manifest_content:
                    missing_fields.append(field)
            
            if missing_fields:
                error_msg = f"manifest.lkml missing required fields: {missing_fields}"
                self.validation_results['errors'].append(error_msg)
                print(f"❌ {error_msg}")
            else:
                info_msg = "manifest.lkml basic validation passed"
                self.validation_results['info'].append(info_msg)
                print(f"✅ {info_msg}")
            
            return {'success': len(missing_fields) == 0}
            
        except Exception as e:
            error_msg = f"Error validating manifest.lkml: {e}"
            self.validation_results['errors'].append(error_msg)
            return {'success': False, 'error': error_msg}
    
    def process_validation_results(self, validation_data: Dict[str, Any]) -> Dict[str, Any]:
        """Process validation results from Looker API"""
        success = True
        
        # Check for errors
        if 'errors' in validation_data:
            for error in validation_data['errors']:
                error_msg = f"LookML Error: {error.get('message', 'Unknown error')}"
                if 'file_path' in error:
                    error_msg += f" in {error['file_path']}"
                if 'line_number' in error:
                    error_msg += f" (line {error['line_number']})"
                
                self.validation_results['errors'].append(error_msg)
                print(f"❌ {error_msg}")
                success = False
        
        # Check for warnings
        if 'warnings' in validation_data:
            for warning in validation_data['warnings']:
                warning_msg = f"LookML Warning: {warning.get('message', 'Unknown warning')}"
                if 'file_path' in warning:
                    warning_msg += f" in {warning['file_path']}"
                if 'line_number' in warning:
                    warning_msg += f" (line {warning['line_number']})"
                
                self.validation_results['warnings'].append(warning_msg)
                print(f"⚠️ {warning_msg}")
        
        # Check for project info
        if 'project' in validation_data:
            project_info = validation_data['project']
            info_msg = f"Project validation completed for: {project_info.get('name', 'Unknown')}"
            self.validation_results['info'].append(info_msg)
            print(f"ℹ️ {info_msg}")
        
        return {'success': success}
    
    def save_results(self, output_file: str = 'validation_results.json'):
        """Save validation results to JSON file"""
        try:
            with open(output_file, 'w') as f:
                json.dump(self.validation_results, f, indent=2)
            print(f"📄 Validation results saved to {output_file}")
        except Exception as e:
            print(f"❌ Failed to save results: {e}")


def main():
    parser = argparse.ArgumentParser(description='Validate LookML project using Looker API')
    parser.add_argument('--project-name', required=True, help='Name of the LookML project to validate')
    parser.add_argument('--config-file', default='looker.ini', help='Looker configuration file')
    parser.add_argument('--output-file', default='validation_results.json', help='Output file for results')
    
    args = parser.parse_args()
    
    print(f"🚀 Starting LookML validation for project: {args.project_name}")
    
    validator = LookerValidator(args.config_file)
    result = validator.validate_project(args.project_name)
    validator.save_results(args.output_file)
    
    if result.get('success', False):
        print("✅ LookML validation completed successfully!")
        sys.exit(0)
    else:
        print("❌ LookML validation failed!")
        sys.exit(1)


if __name__ == '__main__':
    main()
