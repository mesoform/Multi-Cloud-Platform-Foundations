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
    Tests that an owner attribute defined in the components.common block, is set in all providers except those 
    where that value is overwritten 
"""

expected_data = {
    "env": "test1",
    "mount": "/mount/path"
}

if __name__ == '__main__':
    python_validator(expected_data)
