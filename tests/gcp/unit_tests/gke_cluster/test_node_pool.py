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
    Tests whether a map of node pools with the key in the format <cluster_name>_<node_pool_name> is created 
    and whether <cluster_name> and <node_pool_name> are included as attributes in the map
"""

expected_data = {
    "standard": 'standard_default',
    "standard_default_cluster": 'standard',
    "standard_default_name": 'default'
}

if __name__ == '__main__':
    python_validator(expected_data)
