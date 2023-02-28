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
    "bitbucket": "assertion.workspaceUuid=='companyWorkspace'",
    "circleci": "assertion.aud=='company'",
    "github": "assertion.repository_owner=='companyOrg' && assertion.ref=='refs/head/main'",
    "gitlab": "assertion.namespace_id=='companyGroup'",
    "terraform-cloud": "assertion.terraform_organization_id=='organization'",
    "unknown": "none"
}

if __name__ == '__main__':
    python_validator(expected_data)
