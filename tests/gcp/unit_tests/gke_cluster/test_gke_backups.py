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
    Tests how many backup plans each of the clusters have 
"""

expected_data = {
    "autopilot": '2',
    "standard": '1'
}

if __name__ == '__main__':
    python_validator(expected_data)
