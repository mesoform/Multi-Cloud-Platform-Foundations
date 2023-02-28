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
    "cicd_github": "https://token.actions.githubusercontent.com",
    "cicd_gitlab": "https://gitlab.com/",
    "cicd_bitbucket": "https://api.bitbucket.org/2.0/workspaces/companyWorkspace/pipelines-config/identity/oidc",
    "cicd_unknown": "https://unknown.issuer",
    "azure_azure_app_1": "https://sts.windows.net/tenantID"
}

if __name__ == '__main__':
    python_validator(expected_data)