# Google Project Module
This module can be used to deploy Google Projects in a specified folder or organisation.
This is created by defining a terraform `module` which references a `yaml` configuration file (see [configuration](#google-project-basic-configuration)).
e.g. `main.tf`:
```terraform
module dev_projects {
  source      = "github.com/mesoform/Multi-Cloud-Platform-Foundations//Google/resource-manager/project"
  projects_yml = "./dev_projects.yaml"
  #parent_folder = folder/<dev-folder-id>   (optional) 
}
```

## Google Project basic configuration
The `component` block contains:
* One of `org_id` or `folder_id` -  Parent organisation or folder for the project to be in. `parent_folder` can also be set using terraform variable in the module definition.
* `projects` - A list of project definitions, containing the following values:

| Key                   |  Type   | Required | Description                                                                                             | Default |
|:----------------------|:-------:|:--------:|:--------------------------------------------------------------------------------------------------------|:-------:|
| `name`                | string  |   true   | Display name for the Google Project, which will also be the Project ID                                  |  none   |
| `project_id`          | string  |   true   | Project ID for the Google Project                                                                       |  none   |
| `billing_account`     | string  |  false   | The alphanumeric ID of the billing account this project belongs to.                                     |  none   |
| `skip_delete`         | string  |  false   | If true, the Terraform resource can be deleted without deleting the Project via the Google API.         |  none   |
| `labels`              |   map   |  false   | Key Value pairs of labels for project                                                                   |  none   |
| `auto_create_network` | boolean |  false   | automatically create a default network in the Google project                                            |  none   |
| `project_iam`         |  list   |  false   | List of IAM role bindings used to create IAM policy for the project (see details [below](#project-iam)) |  none   |

### Project IAM
The IAM policy for each defined project can be set in the `project_iam`.
> **NOTE**: This policy is authoritative and replaces any existing policy already attached.
> Omit the `project_iam` key if terraform shouldn't override an existing policy
`project_iam` is a list of role bindings with the keys:
* `role`(required): Role for the binding, takes the format `roles/<role` or for custom `[projects|organizations]/{parent-name}/roles/{role-name}`
* `members` (required): Identities who the role is granted to (see [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#member/members) for format)
* `condition` (optional): IAM condition for role assignment (see [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#nested_condition) for configuration)

### Example
```yaml
components:
  org_id: 12345678901
  projects:
    - name: mypsql
      project_id: yenakievo-sun-987654321
      billing_account: 12345-12345-12344
      skip_delete: true
      labels:
        key: value
      auto_create_network: false
      project_iam:
        - role: "roles/viewer"
          members:
            - "user:info@kvit.pub"
        - role: "roles/viewer"
          members:
            - "user:user@kvit.pub"
          condition:
            title: "expires_after_2019_12_31"
            description: "Expiring at midnight of 2019-12-31"
            expression: "request.time < timestamp(\"2020-01-01T00:00:00Z\")"

```