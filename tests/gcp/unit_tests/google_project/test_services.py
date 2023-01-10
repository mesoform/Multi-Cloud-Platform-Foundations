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
    Tests whether the keys for the service maps and the `disable_on_destroy` value for the services are configured correctly
"""

expected_data = {
    "staging_sandbox_recommender": "true",
    "staging_sandbox_compute": "true",
    "test_project_recommender": "false"
}

if __name__ == '__main__':
    python_validator(expected_data)
