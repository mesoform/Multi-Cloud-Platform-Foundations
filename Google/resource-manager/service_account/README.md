# Google Service Account Module  
This module can be used to deploy Google Service Accounts.
This is created by defining a terraform `module` which references a `yaml` configuration file (see [configuration](#google-service-account-basic-configuration)).
e.g. `main.tf`:
```terraform
module dev_service_accounts {
  source      = "github.com/mesoform/Multi-Cloud-Platform-Foundations//Google/resource-manager/service_account"
  service_accounts_yml = "./dev_service_accounts.yaml"
  
}
```

## Google Service Account basic configuration  
Each service account block contains maps of service account configuration, with the following attributes:

| Key                   |  Type   | Required | Description                                                                                                     |            Default             |
|:----------------------|:-------:|:--------:|:----------------------------------------------------------------------------------------------------------------|:------------------------------:|
| `account_id`          | string  |   true   | The account id that is used to generate the service account email address and a stable unique id                |              none              |
| `display_name`        | string  |  false   | The display name for the service account                                                                        |              none              |
| `project`             | string  |  false   | The ID of the project that the service account will be created in                                               | provider project configuration |
| `description`         | string  |  false   | A text description of the service account                                                                       |              none              |
| `disabled`            | boolean |  false   | Whether a service account is disabled or not                                                                    |             false              |
| `service_account_iam` |  list   |  false   | List of IAM role bindings used to create IAM policy for the project (see details [below](#service-account-iam)) |              none              |


### Service Account IAM  
The IAM policy for each defined service account can be set in the `service_account_iam`.
> **NOTE**: This policy is authoritative and replaces any existing policy already attached.
> Omit the `service_account_iam` key if terraform shouldn't override an existing policy
`service_account_iam` is a list of role bindings with the keys:
* `role`(required): Role for the binding, takes the format `roles/<role` or for custom `[projects|organizations]/{parent-name}/roles/{role-name}`
* `members` (required): Identities who the role is granted to (see [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam#member/members) for format)
* `condition` (optional): IAM condition for role assignment (see [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_service_account_iam#condition) for configuration)


### Example  
```yaml
test-account:
  account_id: test-account
  display_name: test-account
  project: test-project
  description: Test account
  disabled: false
  service_account_iam:
    - role: "roles/iam.serviceAccountUser"
      members:
        - "user:info@kvit.pub"
test-account2:
  account_id: test-account2
  display_name: test-account2
  project: test-project
  description: Test account2
  disabled: false
  service_account_iam:
    - role: "roles/iam.serviceAccountUser"
      members:
        - "user:user@kvit.pub"
        - "group:engineers@kvit.pub"
      condition:
        title: "expires_after_2019_12_31"
        description: "Expiring at midnight of 2019-12-31"
        expression: "request.time < timestamp(\"2020-01-01T00:00:00Z\")"

```