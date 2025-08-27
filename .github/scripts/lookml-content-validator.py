#!/usr/bin/env python3
"""
Content Validation for CI/CD
Tests content in BI Sandbox folder using Looker API content_validation endpoint
"""

import json
import sys
import argparse
import configparser
import requests
import os
import re
from typing import Dict, List, Any
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
            'content_validation': None,
            'summary': {
                'total_content_validated': {
                    'looks': 0,
                    'dashboard_elements': 0,
                    'dashboard_filters': 0,
                    'scheduled_plans': 0,
                    'alerts': 0,
                    'explores': 0
                },
                'bi_sandbox_errors': 0,
                'total_errors_all_content': 0,
                'computation_time': 0,
                'filtered_content': [],
                'project_context': None
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
                
            self.session.headers.update({
                'Authorization': f'Bearer {self.access_token}',
                'Content-Type': 'application/json'
            })
            
            print("Successfully authenticated with Looker API")
            return True
            
        except requests.exceptions.RequestException as e:
            print(f"Authentication failed: {e}")
            return False
    
    def detect_project_from_context(self) -> str:
        """Try to detect project name from various sources"""
        project_name = "bi_sandbox"  # default fallback
        
        # Try to get from GitHub context (if running in GitHub Actions)
        github_ref = os.environ.get('GITHUB_REF', '')
        github_repository = os.environ.get('GITHUB_REPOSITORY', '')
        
        if github_ref or github_repository:
            print(f"Detected GitHub context:")
            print(f"  Repository: {github_repository}")
            print(f"  Ref: {github_ref}")
            
            # Extract project hints from repository name or branch
            if 'bi_sandbox' in github_repository.lower():
                project_name = "bi_sandbox"
            elif 'sandbox' in github_repository.lower():
                project_name = "bi_sandbox"
        
        # Try to detect from changed files (if any contain project references)
        try:
            # Look for manifest.lkml or other project indicators
            if os.path.exists('manifest.lkml'):
                with open('manifest.lkml', 'r') as f:
                    manifest_content = f.read()
                    
                # Extract project_name from manifest
                project_match = re.search(r'project_name:\s*"([^"]+)"', manifest_content)
                if project_match:
                    detected_project = project_match.group(1)
                    print(f"Detected project from manifest.lkml: {detected_project}")
                    project_name = detected_project
        except Exception as e:
            print(f"Could not read manifest for project detection: {e}")
        
        self.validation_results['summary']['project_context'] = {
            'detected_project': project_name,
            'github_repository': github_repository,
            'github_ref': github_ref
        }
        
        print(f"Using project context: {project_name}")
        return project_name
    
    def run_content_validation(self, target_folder: str = "BI Sandbox") -> bool:
        """Run content validation and filter for specific folder"""
        print("=" * 60)
        print("LOOKER CONTENT VALIDATION")
        print(f"Filtering for folder: {target_folder}")
        print("=" * 60)
        
        if not self.authenticate():
            return False
        
        # Detect project context
        project_name = self.detect_project_from_context()
        
        try:
            print("Running comprehensive content validation...")
            
            content_validation_url = f"{self.api_url}/content_validation"
            response = self.session.get(content_validation_url)
            
            print(f"Content validation API status: {response.status_code}")
            
            if response.status_code != 200:
                error_msg = f"Content validation API returned status {response.status_code}: {response.text}"
                print(f"ERROR: {error_msg}")
                return False
            
            # Parse content validation response
            content_data = response.json()
            print("SUCCESS: Content validation JSON parsing successful")
            
            self.validation_results['content_validation'] = content_data
            
            return self.process_content_results(content_data, target_folder)
            
        except Exception as e:
            error_msg = f"Content validation failed: {str(e)}"
            print(f"ERROR: {error_msg}")
            return False
    
    def process_content_results(self, content_data: Dict[str, Any], target_folder: str) -> bool:
        """Process content validation results and filter for target folder"""
        
        if not isinstance(content_data, dict):
            print("ERROR: Unexpected content validation response format")
            return False
        
        # Extract validation statistics
        stats = {
            'looks': content_data.get('total_looks_validated', 0),
            'dashboard_elements': content_data.get('total_dashboard_elements_validated', 0),
            'dashboard_filters': content_data.get('total_dashboard_filters_validated', 0),
            'scheduled_plans': content_data.get('total_scheduled_plans_validated', 0),
            'alerts': content_data.get('total_alerts_validated', 0),
            'explores': content_data.get('total_explores_validated', 0)
        }
        
        computation_time = content_data.get('computation_time', 0)
        
        self.validation_results['summary']['total_content_validated'] = stats
        self.validation_results['summary']['computation_time'] = computation_time
        
        print(f"Content validation statistics:")
        print(f"  Total looks validated: {stats['looks']}")
        print(f"  Total dashboard elements validated: {stats['dashboard_elements']}")
        print(f"  Total dashboard filters validated: {stats['dashboard_filters']}")
        print(f"  Total scheduled plans validated: {stats['scheduled_plans']}")
        print(f"  Total alerts validated: {stats['alerts']}")
        print(f"  Total explores validated: {stats['explores']}")
        print(f"  Computation time: {computation_time} seconds")
        
        # Filter content for target folder
        all_content_with_errors = content_data.get('content_with_errors', [])
        filtered_content = []
        
        print(f"\nFiltering content for folder: '{target_folder}'")
        
        for item in all_content_with_errors:
            is_in_target_folder = self.is_content_in_folder(item, target_folder)
            
            if is_in_target_folder:
                filtered_content.append(item)
        
        self.validation_results['summary']['total_errors_all_content'] = len(all_content_with_errors)
        self.validation_results['summary']['bi_sandbox_errors'] = len(filtered_content)
        self.validation_results['summary']['filtered_content'] = filtered_content
        
        print(f"Total content items with errors (all): {len(all_content_with_errors)}")
        print(f"Content items with errors ({target_folder} only): {len(filtered_content)}")
        
        # Display filtered errors
        if filtered_content:
            print(f"\n{target_folder} content validation errors:")
            self.display_content_errors(filtered_content)
            return False  # Return False if errors found in target folder
        else:
            print(f"SUCCESS: No content validation errors found in {target_folder} folder!")
            return True
    
    def is_content_in_folder(self, item: Dict[str, Any], target_folder: str) -> bool:
        """Check if content item is in the target folder"""
        target_lower = target_folder.lower()
        
        # Check look folder
        if item.get('look') and item['look'].get('folder'):
            folder_name = item['look']['folder'].get('name', '')
            if target_lower in folder_name.lower():
                return True
        
        # Check dashboard folder
        if item.get('dashboard') and item['dashboard'].get('folder'):
            folder_name = item['dashboard']['folder'].get('name', '')
            if target_lower in folder_name.lower():
                return True
        
        # Check dashboard element (through parent dashboard folder)
        if item.get('dashboard_element'):
            # Check if parent dashboard info is available
            if item.get('dashboard') and item['dashboard'].get('folder'):
                folder_name = item['dashboard']['folder'].get('name', '')
                if target_lower in folder_name.lower():
                    return True
        
        return False
    
    def display_content_errors(self, filtered_content: List[Dict[str, Any]]):
        """Display content errors in a readable format"""
        for i, item in enumerate(filtered_content):
            errors = item.get('errors', [])
            if errors:
                content_type, content_name, folder_name = self.extract_content_info(item)
                
                print(f"  {i+1}. {content_type}: {content_name}")
                print(f"     Folder: {folder_name}")
                
                for j, error in enumerate(errors):
                    model_name = error.get('model_name', 'Unknown')
                    message = error.get('message', 'No message')
                    print(f"     Error {j+1}: {message}")
                    if model_name != 'Unknown':
                        print(f"     Model: {model_name}")
                print()
    
    def extract_content_info(self, item: Dict[str, Any]) -> tuple:
        """Extract content type, name, and folder from content item"""
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
        
        return content_type, content_name, folder_name
    
    def save_results(self, output_file: str = 'content_validation_results.json'):
        """Save validation results to JSON file"""
        try:
            with open(output_file, 'w') as f:
                json.dump(self.validation_results, f, indent=2)
            print(f"Content validation results saved to {output_file}")
        except Exception as e:
            print(f"Failed to save results: {e}")
    
    def print_summary(self):
        """Print validation summary"""
        print(f"\n" + "=" * 60)
        print("CONTENT VALIDATION SUMMARY")
        print("=" * 60)
        
        summary = self.validation_results['summary']
        
        print(f"Project context: {summary['project_context']['detected_project']}")
        print(f"Computation time: {summary['computation_time']} seconds")
        print(f"Total errors (all content): {summary['total_errors_all_content']}")
        print(f"BI Sandbox folder errors: {summary['bi_sandbox_errors']}")
        
        stats = summary['total_content_validated']
        total_validated = sum(stats.values())
        print(f"Total content validated: {total_validated}")
        
        if summary['bi_sandbox_errors'] == 0:
            print("\nAll BI Sandbox content validation passed successfully!")
        else:
            print(f"\n{summary['bi_sandbox_errors']} errors found in BI Sandbox folder")


def main():
    parser = argparse.ArgumentParser(description='Validate content in BI Sandbox folder using Looker API')
    parser.add_argument('--folder-name', default='BI Sandbox', help='Folder name to filter content validation (default: BI Sandbox)')
    parser.add_argument('--config-file', default='looker.ini', help='Looker configuration file')
    parser.add_argument('--output-file', default='content_validation_results.json', help='Output file for results')
    
    args = parser.parse_args()
    
    print(f"Starting content validation for folder: {args.folder_name}")
    
    validator = LookerContentValidator(args.config_file)
    success = validator.run_content_validation(args.folder_name)
    
    validator.print_summary()
    validator.save_results(args.output_file)
    
    if success:
        print("Content validation completed successfully!")
        sys.exit(0)
    else:
        print("Content validation found issues!")
        sys.exit(1)


if __name__ == '__main__':
    main()
