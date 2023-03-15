# Workload Identity Federation
This module is an MCCF adapter for the [Terraform-Infrastructure-Modules (TIM) Workload Identity Federation module](https://github.com/mesoform/terraform-infrastructure-modules/tree/v2.2.0/gcp/iam/workload_identity_federation)
which deploys Workload Identity Pools and their Workload Identity Pool Providers (IDPs).  
[Workload Identity Federation](https://cloud.google.com/iam/docs/workload-identity-federation) allows external entities 
to access Google Cloud resources without needing to use service account keys.

This module implements templated configurations for commonly used external entities that use OIDC, including:
* Azure
* Bitbucket Pipelines
* CircleCi
* GitHub Actions
* GitLab
* Terraform Cloud

See the [configuration](#configuration) section for implementation details.

### Prerequisites
The project where the resources will be deployed, must have Billing and the following 
services enabled:
* IAM - `iam.googleapis.com`
* Resource Manager - `cloudresourcemanager.googleapis.com`
* Service Account Credentials - `iamcredentials.googleapis.com`
* Security Token Service - `sts.googleapis.com`

The account deploying the resources must have `roles/iam.workloadIdentityPoolAdmin` or a custom role containing
the [required permissions](https://cloud.google.com/iam/docs/manage-workload-identity-pools-providers#expandable-1).

## Configuration

Specify the location of the configuration file `workload_identity_pools_yml` variable.
The configuration file should contain the top level `project_id` key which refers to the project the pools should 
be created in.

The `components.specs` block contains a maps with the format `<pool-id>: <attributes>`.
The `components.common` block can contain any of the attributes for the pool found in the `components.specs` block.

The attributes for configuring a pool are:

| Key            |  Type  | Required | Description                                                                                                     | Default |
|:---------------|:------:|:--------:|:----------------------------------------------------------------------------------------------------------------|:-------:|
| `project_id`   | string |  false   | Project ID the pool is created in, overrides project set in top level key                                       |  none   |
| `display_name` | string |  false   | The display name of the pool if different than the pool-id                                                      | pool-id |
| `description`  | string |  false   | Description for the pool                                                                                        |  none   |
| `disabled`     |  bool  |  false   | Whether the pool is disabled                                                                                    |  false  |
| `providers`    |  map   |  false   | Map with of provider-id and it's attributes, see [table](#provider-attributes) below for detailed configuration |  none   |


## Provider Configuration
The providers for each pool can be configured under the `providers` attribute in the pool configuration.  

This module can be used to configure AWS or OIDC providers. This module has preconfigured settings for some
common clients. To use the preconfigured settings set `oidc.issuer` to one of: `azure`, `bitbucket-pipelines`, `circleci`, 
`github-actions`, `gitlab` or `terraform-cloud`.   
See the [preconfigured defaults](#preconfigured-defaults) section  for details on configuration.

Some defaults can be overwritten by configuring any of the attributes shown in the table below, 
but to replace the `attribute_mappings` rather than add to the defaults, you will need to configure all the values in the table.

The `owner` attribute can also be configured at the `components.common` level if it would be the same for multiple providers (see [trusted_issuers](#trusted-issuers)),
this can be overwritten by specifying the `owner` in `components.specs.*.providers.*`
#### Provider Attributes
| Key                      |     Type     | Required | Description                                                                                                                             |                                                           Default                                                           |
|:-------------------------|:------------:|:--------:|:----------------------------------------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------------------------:|
| `attribute_mapping`      | map(string)  |  false   | Maps attributes from OIDC claim to google attributes. `google.sub` is required, e.g. `google.sub=assertion.sub`                         |                                                            none                                                             |
| `display_name`           |    string    |  false   | Display name for the provider                                                                                                           |                                                         provider-id                                                         |
| `description`            |    string    |  false   | Description for the provider                                                                                                            |                                                            none                                                             |
| `disabled`               |     bool     |  false   | Whether the provider is disabled                                                                                                        |                                                            false                                                            |
| `attribute_condition`    |    string    |  false   | An expression to define required values for assertion claims                                                                            |                                                            none                                                             |
| `owner`                  |    string    |  false   | If using a preconfigured `oidc.issuer` this references the "owner" of the issuer, i.e. the organization or username.                    |                                                            none                                                             |
| `workspace_uuid`         |    string    |  false   | If `oidc.issuer` is `bitbucket-pipelines`, this references the workspace uuid with the format: `{XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}` |                                                            none                                                             |
| `oidc`                   |     map      |  false   | The configuration for an OIDC provider (Either this OR `aws` block can be set)                                                          |                                                            none                                                             |
| `oidc.issuer`            |    string    |   true   | The preconfigured template to use, or the OIDC issuer uri                                                                               |                                                            none                                                             |
| `oidc.allowed_audiences` | list(string) |  false   | Acceptable values for the `aud` field                                                                                                   | `"https://iam.googleapis.com/projects/project-number/locations/global/workloadIdentityPools/pool-id/providers/provider-id"` |
| `aws`                    |     map      |  false   | The configuration for an AWS provider (Either this OR `oidc` block can be set)                                                          |                                                            none                                                             |
| `aws.account_id`         |     map      |   true   | The id of the client aws account                                                                                                        |                                                            none                                                             |

#### Example
```yaml
components:
  specs:
    cicd:
      display_name: CI/CD Workloads
      providers:
        bitbucket:
          owner: workspace
          workspace_uuid: "{some-uuid}"
          oidc:
            issuer: bitbucket
        github:
          owner: repoOwner
          attribute_condition: "assertion.repository_owner=='repoOwner' && assertion.actor=='personalAccount'"
          attribute_mapping:
            "google.subject": "assertion.repository"
          oidc:
            issuer: github
        gitlab:
          owner: groupid
          oidc:
            issuer: gitlab
            allowed_audiences:
              - "default"
        custom-cicd:
          attribute_mapping:
            "google.subject": "assertion.sub"
          oidc:
            issuer: "https://issuer.address"
    azure:
      display_name: Azure
      providers:
        app_1:
          owner: tenantID
          oidc:
            issuer: azure
            allowed_audiences:
              - "api://applicationID"
    aws:
      display_name: AWS
      providers:
        ec2_instance_1:
          attribute_mapping:
            "google.subject": "assertion.arn"
            "attribute.account": "assertion.account"
            "attribute.aws_role": "assertion.arn.extract('assumed-role/ROLE/')"
            "attribute.aws_ec2_instance": "assertion.arn.extract('assumed-role/ROLE_AND_SESSION').extract('/SESSION')"
          aws:
            account_id: "accountid"
          attribute_condition: "assertion.arn.startsWith('arn:aws:sts::accountid:assumed-role/')"
```

### Preconfigured defaults
The TIM module has preconfigured Identity Provider (IDP) settings for commonly used clients, referred to as "trusted issuers", 
which can be used by setting `oidc.issuer` to one of the issuers from the table below, as well as setting required MCCF attributes. 

Further details on the defaults can be found in the [TIM module documentation](https://github.com/mesoform/terraform-infrastructure-modules/tree/06fd7e1879a9d968a74f2f278af1232644228fe2/gcp/iam/workload_identity_federation#preconfigured-defaults),
with the defaults set in the [`trusted_issuers.tf`](https://github.com/mesoform/terraform-infrastructure-modules/tree/v2.2.0/gcp/iam/workload_identity_federation/trusted_issuers.yaml) file.

#### Trusted issuers
| Issuer                | Required MCCF attributes                                                              |
|-----------------------|---------------------------------------------------------------------------------------|
| `azure`               | - `owner`: Tenant ID of Azure tenant                                                  |
| `bitbucket-pipelines` | - `owner`: Name of the workspace owner <br> - `workspace_uuid`: UUid of the workspace |
| `circleci`            | - `owner`: CircleCi Organization ID                                                   |
| `github-actions`      | - `owner`: Repository owner (i.e. Username/Organization)                              |
| `gitlab`              | - `owner`: Unique group ID                                                            |
| `terraform-cloud`     | - `owner`: Terraform Cloud Organization ID                                            |



#### Example using preconfigured default:
```yaml
components:
  specs:
    cicd:
      providers:
        bitbucket:
          owner: workspaceName
          workspace_uuid: '{some-uuid}'
          oidc:
            issuer: bitbucket-pipelines
            allowed_audiences:
              - 'default'
```