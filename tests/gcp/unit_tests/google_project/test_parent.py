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
    Tests that setting a folder parent in the specs block, ignores a org parent configured in commons
"""

expected_data = {
    "parent_folder" : "987654321",
    "parent_org" : "null"
}

if __name__ == '__main__':
    python_validator(expected_data)
