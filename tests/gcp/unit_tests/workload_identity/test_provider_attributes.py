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
    Tests whether default issuer from templates are assigned correctly for each identity pool provider
"""

expected_data = {
    "google.subject": "assertion.sub",
    "attribute.workspace_uuid": "assertion.workspaceUuid",
    "attribute.repository": "assertion.repositoryUuid",
    "attribute.git_ref": "assertion.branchName",
    "attribute.tid": "assertion.tid"
}

if __name__ == '__main__':
    python_validator(expected_data)
