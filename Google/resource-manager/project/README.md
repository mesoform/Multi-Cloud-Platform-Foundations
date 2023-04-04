# Google Project Module  
This module can be used to deploy Google Projects in a specified folder or organisation.
This is created by defining a Terraform `module` which references a `yaml` configuration file (see [configuration](#google-project-basic-configuration).
e.g. `main.tf`:
```terraform
module dev_projects {
  source      = "github.com/mesoform/Multi-Cloud-Platform-Foundations//Google/resource-manager/project"
  projects_yml = "./dev_projects.yaml"
  #parent_folder = <dev-folder-id>   (optional) 
}
```
## Prerequisites
### Required Services
The following services must be enabled in the project which the deploying service account comes from:
* `cloudbilling.googleapis.com`
* `cloudresourcemanager.googleapis.com`
### Required Permissions
The account used for creating the project will need to have the following roles in the relevant folder/organization:
 * `roles/resourcemanager.projectCreator` for creating projects
 * `roles/resourcemanager.projectDeletor` for deleting projects
 * `roles/billing.user` for attaching a billing account to a project (can be applied to organization or individual billing accounts)

And optionally:
 * `roles/resourcemanager.projectMover` for moving projects
 * `roles/resourcemanager.projectIamAdmin` for managing the projects IAM policy
 * `roles/serviceusage.serviceUsageAdmin` for enabling services in the projects.
  This role can be assigned at the project level if necessary. 

## Google Project basic configuration  
The `components.common` block contains attributes common across all projects. It can contain
* One of `org_id` or `folder_id` -  ID of folder or organization the project will be created in, either just the ID or in the form `folders/<folder-id>` or `organizations/<organization-id>`. 
Alternatively the `parent_folder` or `parent_org` variable can be set in the module definition.
These can also be set in `components.specs` but it is recommended to have a separate module for each parent. See [below](#parent-configuration) for more details of use.
* `enable_service_delay` - A string specifying the delay between IAM policy to creation, and enabling services in the project. This defaults to `"2m"`. 
* Any of the attributes available to the `components.specs` block.
The `components.specs` block contains maps of project configuration, with the following attributes:

| Key                    |  Type   | Required | Description                                                                                             |                  Default                  |
|:-----------------------|:-------:|:--------:|:--------------------------------------------------------------------------------------------------------|:-----------------------------------------:|
| `name`                 | string  |  false   | Display name for the Google Project, which will also be the Project ID                                  | project key, from `component.specs.<key>` |
| `project_id`           | string  |   true   | Project ID for the Google Project                                                                       |                   none                    |
| `billing_account`      | string  |  false   | The alphanumeric ID of the billing account this project belongs to.                                     |                   none                    |
| `skip_delete`          | string  |  false   | If true, the Terraform resource can be deleted without deleting the Project via the Google API.         |                   none                    |
| `labels`               |   map   |  false   | Key Value pairs of labels for project                                                                   |                   none                    |
| `auto_create_network`  | boolean |  false   | automatically create a default network in the Google project                                            |                   none                    |
| `project_iam`          |  list   |  false   | List of IAM role bindings used to create IAM policy for the project (see details [below](#project-iam)) |                   none                    |
| `services`             |  list   |  false   | List of services to enable in the project (see details [below](#project-services)                       |                   none                    |

### Parent configuration  
The parent of the project must be either a folder or an organization, and can be configured by the `parent_folder`/`parent_org` variables, as well as in the MCCF file.  
If these values are set in multiple places, the order of priority is:
1. Variables set in module block. The `parent_folder` or `parent_org` variable will take priority over any MCCF configuration,
   and will apply to all the projects configured in the MCCF file.   
   This means that setting the parents for individual projects (i.e. priority 2) cannot be done when using variables to configure parent. 
2. MCCF file: `components.specs.<project>`. If `folder_id` or `org_id` is set in the configuration for the project, 
    that project will ignore any parent configuration configured in `components.common`
3. MCCF file: `components.common`. The `folder_id` or `org_id` configured here will apply to all projects in the MCCF file,
    provided there is no configuration from 1 or 2.

> **NOTE**: At each priority level (i.e. 1, 2 or 3) there should only be configuration for **either** folder **OR** organization.  

#### Examples:  
##### 1. Passing the parent ID from a variable in the module  
```terraform
module folders {
  source      = "github.com/mesoform/Multi-Cloud-Platform-Foundations//Google/resource-manager/folder"
  projects_yml = "../folders.yaml"
}

module projects {
  source      = "github.com/mesoform/Multi-Cloud-Platform-Foundations//Google/resource-manager/project"
  projects_yml  = "../projects.yaml"
  parent_folder = module.core_folders.folder_names["development"]
}
```  

##### 2. Different parent for specific project  
```yaml
components:
  common:
    skip_delete: false
    auto_create_network: false
    folder_id: folders/12345678910 
  specs:
    org-project:
      name: "Organization level project"
      project_id: some-project-id1
      org_id: organizations/12345678910
    folder-project1:
      name: "test-project1"
      project_id: some-project-id2
    folder-project2:
      name: "test-project2"
      project_id: some-project-id-3
      folder_id: folders/10987654321
```
In this example the `org-project` project will be located in the organization, 
the `folder-project1` project will be in the `folders/12345678910` folder specified in `components_common`, 
and the `folder-project2` project will be in the `folders/10987654321`

### Project IAM  
The IAM policy for each defined project can be set in the `project_iam`.
> **NOTE**: This policy is authoritative and replaces any existing policy already attached.
> Omit the `project_iam` key if terraform shouldn't override an existing policy
`project_iam` is a list of role bindings with the keys:
* `role`(required): Role for the binding, takes the format `roles/<role` or for custom `[projects|organizations]/{parent-name}/roles/{role-name}`
* `members` (required): Identities who the role is granted to (see [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#member/members) for format)
* `condition` (optional): IAM condition for role assignment (see [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam#nested_condition) for configuration)

### Project services
A list of services to be enabled in the created project can be set using the `services` key.  
> **NOTE**: The account used for deployment would need a role with the `serviceusage.services.enable` permission (e.g. `roles/serviceUsageAdmin`)  

By default, a service is disabled when the service resource is destroyed (i.e. removed from yaml file), 
but disabling can be prevented by adding setting `disable_on_destroy` to `false`.  
If a service is disabled when the resource is destroyed, it can also be set to disable any services dependent on it by setting the value
`disable_dependent_services` to `true` (defaults to `false`).  
E.g:
```yaml
    services:
      - service: compute.googleapis.com
        disable_dependent_services: true
      - service: container.googleapis.com
        disable_on_destroy: false
      - service: recommender.googleapis.com
```

If a role required for enabling services is set in the projects IAM policy during deployment, 
a default delay of 2 minutes is set, allowing for propagation of permissions.   
This delay can be updated using the `enable_service_delay` attribute in the `components.commons` section.

### Advisory Notifications
[Advisory notifications](https://cloud.google.com/advisory-notifications/docs/overview) provide communications about 
security events on Google Cloud Platform to configured essential contacts.
Essential contacts to receive these notifications for a project can be configured using an `essential_contacts` block.  
The `essential_contacts` block has the following attributes:
* `language_tag` - Language the notifications should be sent in (defaults to en-GB)
* `contacts` - A map of contacts and a list of the notification categories they should receive

Full notification types can be found in the [google documentation](https://cloud.google.com/resource-manager/docs/managing-notification-contacts)

Example `essential_contacts` block:
```yaml
essential_contacts:
  language_tag: en-GB
  contacts:
    admin-team@company.com: ["ALL"]
    business-team@company.com: 
      - BILLING
      - LEGAL
    security-team@company.com: 
      - SECURITY
      - TECHNICAL
    platform-team@company.com:
      - TECHNICAL
```

### Full Example  
```yaml
components:
  common:
    org_id: 12345678901
    billing_account: 12345-12345-12345
    skip_delete: true
    labels: 
      key-1: value-1
    auto_create_network: false
    enable_service_delay: 90s
    services: 
      - service: compute.googleapis.com
      - service: recommender.googleapis.com
  specs: 
    staging-sandbox:
      name: Staging Sandbox
      project_id: project-id-123456
      skip_delete: true
      labels:
        key-1: overwrite-value
        key-2: value-2
      auto_create_network: true
      services:
        - service: compute.googleapis.com
          disable_on_destroy: false
      project_iam:
        - role: "roles/viewer"
          members:
            - "user:info@kvit.pub"
        - role: "roles/serviceusage.serviceUsageAdmin"
          members:
            - "user:user@kvit.pub"
          condition:
            title: "expires_after_2019_12_31"
            description: "Expiring at midnight of 2019-12-31"
            expression: "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
    test-project:
      project_id: test-project-123
      folder_id: folders/12345678910

```