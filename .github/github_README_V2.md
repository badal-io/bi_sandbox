# LookML Audit Scripts Documentation

This folder contains Python scripts intended for auditing and validating LookML files in your project. Each script focuses on a specific best practice or rule for LookML dashboards, explores, and joins.

## Scripts Overview

### 1. `lookml-audit-cnt-query.py`
**Purpose**: Checks that dashboards do not exceed a specified maximum number of queries per dashboard (default: 5).
- Supports both YAML and LookML dashboard formats.
- Reports dashboards that violate the query limit.
- Outputs GitHub Actions annotations for violations.

### 2. `lookml-audit-dashboard-filters.py`
**Purpose**: Validates that each YAML dashboard includes at least one filter.
- Reports dashboards missing filters.
- Uses both YAML parsing and regex-based fallback.
- Outputs GitHub Actions error annotations for dashboards without filters.

### 3. `lookml-audit-explore.py`
**Purpose**: Identifies orphaned views—views defined in LookML files but not referenced in any explore.
- Processes all relevant LookML files.
- Reports unused views and recommends actions (e.g., removal, adding to explores).
- Saves results in a JSON file.

### 4. `lookml-audit-join.py`
**Purpose**: Checks that all join relationships in explores are set to `many_to_one`.
- Flags any non-`many_to_one` relationships (`one_to_one`, `one_to_many`, `many_to_many`, or missing).
- Reports violations and provides recommendations for fixes.

## Usage

Each script is designed to be run from the command line with arguments for project root, file lists, verbosity, and output options. They are intended to be used in CI/CD pipelines or by developers to enforce LookML best practices.
