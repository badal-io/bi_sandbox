#!/usr/bin/env python3
import re

def test_only_many_to_one_joins(files):
    """
    Checks that all join relationships in explores are 'many_to_one'.
    Returns a list of (file, explore_name, join_name, found_relationship) for violations.
    """
    pattern_explore = r'explore:\s*(\w+)\s*\{([^}]*(?:\{[^}]*\}[^}]*)*)\}'
    pattern_join = r'join:\s*(\w+)\s*\{([^}]*)\}'
    relationship_pattern = r'relationship:\s*(\w+_\w+)'

    violations = []

    for file_path in files:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        for explore_match in re.finditer(pattern_explore, content, re.DOTALL):
            explore_name = explore_match.group(1)
            explore_body = explore_match.group(2)
            # Find all joins in explore
            for join_match in re.finditer(pattern_join, explore_body, re.DOTALL):
                join_name = join_match.group(1)
                join_body = join_match.group(2)
                rel_match = re.search(relationship_pattern, join_body)
                if rel_match:
                    relationship_type = rel_match.group(1)
                    if relationship_type != "many_to_one":
                        violations.append((file_path, explore_name, join_name, relationship_type))
                else:
                    # If no relationship declared, you can decide to treat as violation or not
                    violations.append((file_path, explore_name, join_name, "MISSING"))
    return violations
