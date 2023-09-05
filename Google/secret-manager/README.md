# Google Secret Manage Module  
This module can be used to manage Secret Manager Secrets in a project (Note: this module does not manage the secret versions).
This is created by defining a Terraform `module` which references a `yaml` configuration file (see [configuration](#google-project-basic-configuration).
e.g. `main.tf`:
```terraform
module dev_projects {
  source      = "github.com/mesoform/Multi-Cloud-Platform-Foundations//Google/secret-manager"
  secrets_yml = "./secrets.yaml"
}
```
## Prerequisites
### Required Services
The following services must be enabled in the project the secrets will be deployed to:
* `secretmanager.googleapis.com`
### Required Permissions
The account used for creating the secret will need to have the following roles:
 * `roles/secretmanager.admin` for creating secrets and managing the IAM policy (note: this will also give the service 
account permission to access the secret versions)

## Secret Manager basic configuration  
The yaml file must contain a top level attribute `project_id` with the project_id
The `components.common` block contains attributes common across all secrets which are available in `components.specs`.
The `components.specs` block contains maps of project configuration, with the following attributes:

| Key                     |   Type    | Required | Description                                                                                                                                           |                 Default                  |
|:------------------------|:---------:|:--------:|:------------------------------------------------------------------------------------------------------------------------------------------------------|:----------------------------------------:|
| `secret_id`             |  string   |  false   | ID of the secret                                                                                                                                      | secret key, from `component.specs.<key>` |
| `user_managed_replicas` | list(map) |  false   | (Ignore if using automatic replication). List of user managed replication configurations, each item contains `location` and optionally `kms_key_name` |                   none                   |
| `labels`                |    map    |  false   | Key Value pairs of labels for project                                                                                                                 |                   none                   |
| `annotations`           |    map    |  false   | Key Value pairs of annotaions for project                                                                                                             |                   none                   |
| `ttl`                   |  string   |  false   | Time to Live for the secret in seconds (must have "s" at the end)                                                                                     |                   none                   |
| `version_aliases`       |    map    |  false   | Mapping from version alias to version name                                                                                                            |                   none                   |
| `topics`                |    map    |  false   | A list of up to 10 Pub/Sub topics to which messages are published when control plane operations are called on the secret or its versions              |                   none                   |
| `rotation`              |  string   |  false   | The rotation time and period for a Secret                                                                                                             |                   none                   |
| `expire_time`           |  string   |  false   | Timestamp in UTC when the Secret is scheduled to expire.                                                                                              |                   none                   |
| `secrets_iam`           |   list    |  false   | List of IAM role bindings used to create IAM policy for the secret (see details [below](#project-iam))                                                |                   none                   |


##### example  
```yaml
components:
  common:
    location: europe-west2
    labels:
      environment: testing
      overwrite: false
    annotations:
      env: test1
    secret_iam:
      - role: roles/secretmanager.secretAccessor
        members:
          - "user:info@example.com"
  specs:
    test_secret:
      ttl: 16000s
      automatic_replication: true
      secret_iam:
        - role: roles/secretmanager.secretAdmin
          members:
            - "user:info@example.com"
    second_test:
      labels:
        function: workload
        overwrite: true
      annotations:
        mount: /mount/path
      user_managed_replicas:
        - location: europe-west1
        - location: europe-west2
```