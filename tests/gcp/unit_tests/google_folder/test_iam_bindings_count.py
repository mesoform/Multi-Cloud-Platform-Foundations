"""
Terraform external provider just handles strings in maps, so tests need to consider this
"""
from sys import path, stderr

try:
    path.insert(1, '../../../test_fixtures/python_validator')
    from python_validator import python_validator
except Exception as e:
    print(e, stderr)


"""
    Checks the bindings of the IAM policies in the folder
"""

expected_data = {
    "staging": 2,
    "department-2": 2,
    "department-3": 1,
    "department-4": 0
}

if __name__ == '__main__':
    python_validator(expected_data)
