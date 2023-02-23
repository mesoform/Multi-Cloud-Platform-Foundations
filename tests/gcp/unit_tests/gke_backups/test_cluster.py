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
    Tests what cluster backup plans are assigned to
"""

expected_data = {
    "test_daily_backup": 'some-cluster',
    "test_hourly": 'some-cluster',
    "test_weekly": 'another-cluster'
}

if __name__ == '__main__':
    python_validator(expected_data)
