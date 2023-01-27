# GKE Cluster
This module deploys a Google Kubernetes Engine (GKE) Cluster using MCCF format. 
By default, any cluster created is an Autopilot cluster, but the module can also be used to manage a Standard cluster, 
by setting `autopilot` to false. The node pools for Standard clusters are managed as a seperate resource from the cluster, 
allowing addition of extra node pools at a later point (see [configuration](#configuration) section for more details). 

GKE Backup Plans can also be created in this module by adding a `backup_plans` block with the configuration matching 
the `specs` section from the backup_plan MCCF module (see documentation).


### Prerequisites
The Google Kubernetes Engine API should be enabled, and the account deploying the cluster should have one of the 
following roles:
* `roles/container.Admin` for creating clusters and managing APIs
* `roles/iam.serviceAccountUser` (optional)for the service account that will be used by the cluster

If configuring any `backup_plans`, the GKE Backup Plan API (`gkebackup.googleapis.com`) must be enabled.

## Configuration
Specify the location of the configuration file `clusters_yml` variable. 
The configuration file should contain the top level `project_id` key which refers to the 
project the cluster should be created in. 

The `components.specs` block contains a maps with the format `<cluster_name>: <attributes>`.
The `components.common` block can contain any of the attributes found in the `components.specs` block. 

Some of the attributes that can be set if configuring an autopilot cluster are:

| Key                                 |   Type    | Required | Description                                                                                                                                                                                                                                | Default |
|:------------------------------------|:---------:|:--------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------:|
| `location`                          |  string   |   true   | The region/zone the cluster is deployed to                                                                                                                                                                                                 |  none   |
| `project_id`                        |  string   |  false   | Project ID the cluster is deployed to, overrides project set in top level key                                                                                                                                                              |  none   |
| `network`                           |  string   |  false   | Network for cluster to be deployed in                                                                                                                                                                                                      |  none   |
| `subnetwork`                        |  string   |  false   | Subnetwork for cluster to be deployed in                                                                                                                                                                                                   |  none   |
| `addons_config`                     | map(bool) |  false   | Map of addons and whether they are enabled. E.g. `gke_backup_agent_config: true`. See [documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#nested_addons_config) for full list |  none   |

If creating a standard cluster, the options above are available as configuration for node pools. see [below](#node-pools) for more details
Full list of attributes can be found in the terraform resource documentation ([link](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluste)).

### Node pools
To manage the configuration of node pools, the `node_pools` block should be used. 
This block contains maps with the name of the node pool as the key, with the attributes listed 
in the [terraform documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool#argument-reference).

Some of the attributes are:

| Key                                 |   Type    | Required | Description                                                                                                                                                                                                                                | Default |
|:------------------------------------|:---------:|:--------:|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------:|
| `location`                          |  string   |   true   | The region/zone the cluster is deployed to                                                                                                                                                                                                 |  none   |
| `project_id`                        |  string   |  false   | Project ID the cluster is deployed to, overrides project set in top level key                                                                                                                                                              |  none   |
| `network`                           |  string   |  false   | Network for cluster to be deployed in                                                                                                                                                                                                      |  none   |

Setting the `node_pools` block will set the `initial_node_count` value to 1, as required to start the cluster, 
and sets `remove_default_node_pool` to `true` to remove the node pool that is automatically created on cluster creation. 

Node pools are managed separately in this module so that node pools can be added in the future. 
If the node_pool were configured in the `google_container_cluster` resource, that would define the only node_pools
the cluster can have (i.e. would not be able to add extra)

Example configuration with custom node pools:
```yaml
components:
  common:
    location: europe-west2
    autopilot: false
    node_pools:
      default:
        node_locations:
          - "europe-west2-a"
        node_count: 1
        mesh_certificates: false
  specs:
    standard_1:
      addons_config:
        gke_backup_agent_config: true
    standard_2:
      confidential_nodes:
        enabled: true
      node_pools:
        secure:
          node_locations:
            - "europe-west2-b"
            - "europe-west2-c"
          node_count: 2
          mesh_certificates: false
          node_config:
            service_account: service-account@project.iam.gserviceaccount.com
            shielded_instance_config:
              enable_secure_boot: true
              enable_integrity_monitoring: true

```


### Backup Plans
To use backup plans in the cluster, the gke_backup addon must be enabled:
```yaml
      addons_config:
        gke_backup_agent_config: true
```
the `backup_plans` section has the same configuration as specified in the backup_plan module documentation.

Below is an example configuration with a weekly backup plan enabled for all clusters, 
and a daily backup plan enabled for the autopilot one:
```yaml
components:
  common:
    location: europe-west2
    backup_plans:
      weekly:
        backup_config:
          include_volume_data: true
          include_secrets: false
          all_namespaces: true
        backup_schedule:
          cron_schedule: "0 0 * * 7"
  specs:
    autopilot:
      addons_config:
        gke_backup_agent_config: true
      backup_plans:
        daily:
          backup_schedule:
            cron_schedule: "0 3 * * *"
    standard:
      autopilot: false
      addons_config:
        http_load_balancing: true
        network_policy_config: false
        gke_backup_agent_config: true


```