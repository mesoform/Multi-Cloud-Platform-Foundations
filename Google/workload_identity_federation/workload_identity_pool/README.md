# Workload Identity Pool
This module defines the creation of a workload identity pool. It takes the following variables:
* `project_id` - The project the pool is defined in
* `workload_identity_pool` - Definition of a pool and its providers with the following attibutes:

| Key                                |     Type     | Required | Description                                                                                                                             |                                                           Default                                                           |
|:-----------------------------------|:------------:|:--------:|:----------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------:|
| `pool_id`                          |    string    |   true   | ID for the pool                                                                                                                         |                                                            none                                                             |
| `display_name`                     |    string    |  false   | The display name of the pool if different than the pool-id                                                                              |                                                           pool-id                                                           |
| `description`                      |    string    |  false   | Description for the pool                                                                                                                |                                                            none                                                             |
| `disabled`                         |     bool     |  false   | Whether the pool is disabled                                                                                                            |                                                            false                                                            |
| `providers`                        | map(object)  |  false   | Map with of provider-id and it's attributes                                                                                             |                                                            none                                                             |
| `providers.attribute_mapping`      | map(string)  |  false   | Maps attributes from OIDC claim to google attributes. `google.sub` is required, e.g. `google.sub=assertion.sub`                         |                                                            none                                                             |
| `providers.display_name`           |    string    |  false   | Display name for the provider                                                                                                           |                                                         provider-id                                                         |
| `providers.description`            |    string    |  false   | Description for the provider                                                                                                            |                                                            none                                                             |
| `providers.disabled`               |     bool     |  false   | Whether the provider is disabled                                                                                                        |                                                            false                                                            |
| `providers.attribute_condition`    |    string    |  false   | An expression to define required values for assertion claims                                                                            |                                                            none                                                             |
| `providers.owner`                  |    string    |  false   | If using a preconfigured `oidc.issuer` this references the "owner" of the issuer, i.e. the organization or username.                    |                                                            none                                                             |
| `providers.workspace_uuid`         |    string    |  false   | If `oidc.issuer` is `bitbucket-pipelines`, this references the workspace uuid with the format: `{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}` |                                                            none                                                             |
| `providers.oidc`                   |     map      |  false   | The configuration for an OIDC provider (Either this OR `aws` block can be set)                                                          |                                                            none                                                             |
| `providers.oidc.issuer`            |    string    |   true   | The preconfigured template to use, or the OIDC issuer uri                                                                               |                                                            none                                                             |
| `providers.oidc.allowed_audiences` | list(string) |  false   | Acceptable values for the `aud` field                                                                                                   | `"https://iam.googleapis.com/projects/project-number/locations/global/workloadIdentityPools/pool-id/providers/provider-id"` |
| `providers.aws`                    |     map      |  false   | The configuration for an AWS provider (Either this OR `oidc` block can be set)                                                          |                                                            none                                                             |
| `providersaws.account_id`          |     map      |   true   | The id of the client aws account                                                                                                        |                                                            none                                                             |

## Example implementation
```terraform
module workload_identity_pools {
  source                 = "github.com/mesoform/Multi-Cloud-Platform-Foundations//Google/workload_identity_federation/workload_identity_pool"
  for_each               = local.workload_identity_pools_specs
  project_id             = "project_id"
  workload_identity_pool = {
    pool_id   = "cicd"
    display_name = "CI/CD pool"
    providers = {
      github = {
        attribute_condition = "assertion.repostory_owner=='Company' && assertion.actor=='personalAccount'"
        attribute_mapping   = {
          "google.subject"  = "assertion.repository"
        }
        owner = "Company"
        oidc  = {
          issuer = "github-actions"
        }
      }
      bitbucket = {
        owner          = "mesoform"
        workspace_uuid = "{some-uuid}"
        oidc           = {
          issuer = "bitbucket-pipelines"
        }
      }
      unknown = {
        attribute_mapping = {
          "google.subject" = "assertion.sub"
          "attribute.tid"  = "assertion.tid"
        }
        oidc = {
          issuer = "https://unknown.issuer"
        }
      }
    }
  }
}
```