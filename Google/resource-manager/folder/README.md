# Google Folder Module
This module can be used to deploy Google Folders in a specified parent folder/organization.
This is created by defining a terraform `module` which references a `yaml` configuration file (see [configuration](#google-folder-basic-configuration)).
e.g. `main.tf`:
```terraform
module test_folders {
  source      = "github.com/mesoform/Multi-Cloud-Platform-Foundations//Google/resource-manager/folder"
  projects_yml = "./test_folders.yaml"
  #parent_folder = folder/<dev-folder-id>   (optional) 
}
```

Terraform will output the `folder_names` of all defined folders after `terraform apply`.  
The output will have the format `<display_name> = <folder-name>` where folder name will have the format like `folder/12345678`. 
This is useful if defining a folders as subfolder of other created folders: 
e.g. 
```terraform
module core_folders {
  source      = "github.com/mesoform/Multi-Cloud-Platform-Foundations//Google/resource-manager/folder"
  projects_yml = "./core_folders.yaml"
}
module dev_folders {
  source      = "github.com/mesoform/Multi-Cloud-Platform-Foundations//Google/resource-manager/folder"
  projects_yml = "./dev_folders.yaml"
  parent_folder = module.core_folders.folder_names["development"]
}
```

## Google Folder basic configuration
The `components.specs` block contains maps of folder configuration, with the following attributes
* `display_name` - Display name for the folder (defaults to the key for the folder's definition). Display name needs to match the requirements of the API (https://cloud.google.com/resource-manager/reference/rest/v2/folders#resource:-folder)
* `folder_iam` (optional) - List of IAM role bindings used to create IAM policy for the project (see details [below](#folder-iam)).

These values can also be present in the `components.common` block, which contains:
*`parent_id` - ID of the organisation or folder for the folder to be in to be in taking format `organization/<org-id>` or `folder/<folder-id>`. 
  If needing to dynamically add the `parent_id` of a folder created by another definition of the module, can use the `parent_folder` variable in the module block (see above).
* Any of the attributes available to the `components.spec` block (see above)

### Folder IAM
The IAM policy for each defined project can be set in the `folder_iam`.
> **NOTE**: This policy is authoritative and replaces any existing policy already attached. 
> Omit the `folder_iam` key if terraform shouldn't override an existing policy 

`folder_iam` is a list of role bindings with the keys:
* `role`(required): Role for the binding, takes the format `roles/<role` or for custom `[projects|organizations]/{parent-name}/roles/{role-name}`
* `members` (required): Identities who the role is granted to (see [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#member/members) for format)
* `condition` (optional): IAM condition for role assignment (see [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#nested_condition) for configuration)

### Example
```yaml
components:
  common:
    parent_id: "folders/12345678"
    folder_iam:
      - role: "roles/owner"
        member: "user:owner@example.com"
  specs:
    staging:
      folder_iam:
        - role: "roles/viewer"
          members:
            - "user:info@example.com"
    department-2:
      display_name: "Department-Bob"
      folder_iam:
        - role: "roles/editor"
          members:
            - "user:info@example.com"
          condition:
            title: "expires_after_2019_12_31"
            description: "Expiring at midnight of 2019-12-31"
            expression: "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
      
```