# GKE Backup Plan
This module creates GKE Backup Plans for GKE clusters, see [google documentation](https://cloud.google.com/kubernetes-engine/docs/add-on/backup-for-gke/concepts/backup-for-gke).

To use this module the GKE Backup Plan API (`gkebackup.googleapis.com`) must be enabled, and the addon be enabled on the cluster 
which is to be backed up (also any clusters that backups can be restored to).
If deploying a cluster through the cluster mcp module enable in the `addons_config` block [see documentation](../cluster/README.md#backup-plans).
If the cluster already exists, the addon can be enabled with the following command:
```shell
gcloud container clusters update $CLUSTER_NAME \
   --project=$PROJECT_ID \
   --region=$COMPUTE_REGION \
   --update-addons=BackupRestore=ENABLED
```

## Configuration

`project_id` must be specified in as a top level key in the mccf configuration file or in the terraform `project_id` variable.

Attributes included in `components.specs` includes:

| Key                                        |       Type        | Required | Description                                                                                                    |          Default          |
|:-------------------------------------------|:-----------------:|:--------:|:---------------------------------------------------------------------------------------------------------------|:-------------------------:|
| `location`                                 |      string       |   true   | Location for the backup plan                                                                                   |           none            |
| `cluster_id`                               |      string       |   true   | Cluster backup plan is to perform backups on                                                                   |           none            |
| `name`                                     |      string       |  false   | Name of the backup plan                                                                                        | Key in `components.specs` |
| `backup_config`                            |        map        |   true   | configuration of backup plan                                                                                   |           none            |
| `backup_config.all_namespaces`             |       bool        |  false   | Whether to backup all namespaces                                                                               |           true            |
| `backup_config.include_secrets`            |       bool        |  false   | Whether to backup secrets                                                                                      |           true            |
| `backup_config.include_volume_data`        |       bool        |  false   | Whether to backup persistent volume data                                                                       |           true            |
| `backup_config.selected_namespaces`        |   list(string)    |  false   | Namespaces to backup (if all_namespaces is `false`)                                                            |           false           |
| `backup_config.selected_application`       | list(map(string)) |  false   | Applications to backup (if all_namespaces is `false`). Specifies the `name` and `namespace` of the application |           false           |
| `backup_schedule.cron_schedule`            |      string       |  false   | Cron schedule for a scheduled backup plan                                                                      |           none            |
| `backup_schedule.paused`                   |       bool        |  false   | Whether to pause scheduled backup plan                                                                         |           false           |
| `retention_policy.backup_delete_lock_days` |      number       |  false   | Minimum age for backup before deletion                                                                         |           none            |
| `retention_policy.backup_retain_days`      |      number       |  false   | How long to retain backups                                                                                     |             1             |
| `retention_policy.locked`                  |      number       |  false   | If retention policy can be updated (if set to `true` cannot be unlocked)                                       |           false           |



### Recommended Deployment Patterns
If deploying a cluster with a backup plan, it is recommended to use the MCP cluster module
and specify a `backup_plan` block for your clusters, rather than managing separately ([see documentation](../cluster/README.md#backup-plans)). 

If managing just the backup_plans one of the following patterns should be used

#### Per Cluster
Configure all the backup plans for a cluster using the following format
e.g. cluster_1_backups.yaml:
```yaml
project_id: project
components:
  common:
    cluster_id: cluster
  specs:
    daily_ns_1:
      backup_config:
        include_volume_data: true
        selected_namespaces:
          namespaces:
            - ns_1
    daily_app_1:
      backup_config:
        selected_applications:
          namespaced_names:
            - namespace: "ns_1"
              name: "app1"
            - namespace: "ns_2"
              name: "app2"
    all:
      backup_config:
        include_volume_data: true
        include_secrets: true
        all_namespaces: true
```

This is the method used when creating a backup plan alongside with mcp `cluster` adapter

#### Repeatable per backup type
Configure a backup plan that is used on multiple clusters
e.g. weekly_backups.yaml
```yaml
project_id: project
components:
  common:
    backup_config:
      include_volume_data: true
      include_secrets: false
      all_namespaces: true
    backup_schedule:
      cron_schedule: "0 0 * * 7"
  specs:
    cluster_1_weekly:
      cluster_id: cluster1
    cluster_2_weekly:
      cluster_id: cluster2
    cluster_3_weekly:
      cluster_id: cluster3
```

## Restore Plan
There currently are no terraform resources for creating a restore plan, so restore plans need to be created manually through
`gcloud beta` cli (or in Google Cloud Console).

Some example restore plans are documented below. The following environment variables are used in the examples:
* `PROJECT_ID` - project that cluster and backups reside in
* `LOCATION` - Location backups are stored in
* `BACKUP_PLAN_NAME` - Backup plan to restore backup from
* `BACKUP_NAME` - Name of the backup to restore
* `RESTORE_PLAN_NAME` - Name of the restore plan
* `CLUSTER` - Name of the cluster to restore to (presumes that cluster is in the same project and location as the backup/restore plans)
* `DESCRIPTION` - Description of restore plan

Example restore plans:
* Restore all namespaces:
  ```bash
  gcloud beta container backup-restore restore-plans create $RESTORE_PLAN_NAME \
      --project=$PROJECT \
      --location=$LOCATION \
      --backup-plan=projects/$PROJECT/locations/$LOCATION/backupPlans/$BACKUP_PLAN_NAME \
      --cluster=projects/$PROJECT/locations/$LOCATION/backupPlans/clusters/$CLUSTER \
      --all-namespaces
  ```
* Restore specific namespaces:
  ```bash
  gcloud beta container backup-restore restore-plans create $RESTORE_PLAN_NAME \
      --project=$PROJECT \
      --location=$LOCATION \
      --backup-plan=projects/$PROJECT/locations/$LOCATION/backupPlans/$BACKUP_PLAN_NAME \
      --cluster=projects/$PROJECT/locations/$LOCATION/backupPlans/clusters/$CLUSTER \
      --selected-namespaces=ns1,ns2
  ```
* Restore specific namespaces:
  ```bash
  gcloud beta container backup-restore restore-plans create $RESTORE_PLAN_NAME \
      --project=$PROJECT \
      --location=$LOCATION \
      --backup-plan=projects/$PROJECT/locations/$LOCATION/backupPlans/$BACKUP_PLAN_NAME \
      --cluster=projects/$PROJECT/locations/$LOCATION/backupPlans/clusters/$CLUSTER \
      --selected-applications=app1
  ```
* Delete conflicting resources before restoring from backup
  ```bash
  gcloud beta container backup-restore restore-plans create $RESTORE_PLAN_NAME \
      --project=$PROJECT \
      --location=$LOCATION \
      --backup-plan=projects/$PROJECT/locations/$LOCATION/backupPlans/$BACKUP_PLAN_NAME \
      --cluster=projects/$PROJECT/locations/$LOCATION/backupPlans/clusters/$CLUSTER \
      --selected-namespaces=ns1,ns2
      --namespaced-resource-restore-mode=delete-and-restore
  ```
* Perform transformations on resources before they are created in targed cluster. See [google documentation](https://cloud.google.com/kubernetes-engine/docs/add-on/backup-for-gke/how-to/substitution-rules)
  for more details
  ```bash
  gcloud beta container backup-restore restore-plans create $RESTORE_PLAN_NAME \
      --project=$PROJECT \
      --location=$LOCATION \
      --backup-plan=projects/$PROJECT/locations/$LOCATION/backupPlans/$BACKUP_PLAN_NAME \
      --cluster=projects/$PROJECT/locations/$LOCATION/backupPlans/clusters/$CLUSTER \
      --selected-namespaces=ns1,ns2
      --namespaced-resource-restore-mode=delete-and-restore
      --substitution-rules-file=/path/to/substitution/rules/file
  ```
* Create new PV using volume backup data from Backup (defaults to not restoring PV)
  ```bash
  gcloud beta container backup-restore restore-plans create $RESTORE_PLAN_NAME \
      --project=$PROJECT \
      --location=$LOCATION \
      --backup-plan=projects/$PROJECT/locations/$LOCATION/backupPlans/$BACKUP_PLAN_NAME \
      --cluster=projects/$PROJECT/locations/$LOCATION/backupPlans/clusters/$CLUSTER \
      --selected-namespaces=ns1,ns2
      --namespaced-resource-restore-mode=delete-and-restore
      --volume-data-restore-policy=restore-volume-data-from-backup
      
  ```
* Provision PV using the volume handle of the original PV in the backup
  ```bash
  gcloud beta container backup-restore restore-plans create $RESTORE_PLAN_NAME \
      --project=$PROJECT \
      --location=$LOCATION \
      --backup-plan=projects/$PROJECT/locations/$LOCATION/backupPlans/$BACKUP_PLAN_NAME \
      --cluster=projects/$PROJECT/locations/$LOCATION/backupPlans/clusters/$CLUSTER \
      --selected-namespaces=ns1,ns2
      --namespaced-resource-restore-mode=delete-and-restore
      --volume-data-restore-policy=reuse-volume-handle-from-backup
  ```
* Restore cluster-scoped resources from backup, by default none are restored. 
  Specifying only `--cluster-resources-restore-scope=` will mean no conflicting resources will be restored.
  To delete existing versions of resources before re-creating from backup, use `--cluster-resource-conflict-policy=use-backup-version`
  ```bash
  gcloud beta container backup-restore restore-plans create $RESTORE_PLAN_NAME \
      --project=$PROJECT \
      --location=$LOCATION \
      --backup-plan=projects/$PROJECT/locations/$LOCATION/backupPlans/$BACKUP_PLAN_NAME \
      --cluster=projects/$PROJECT/locations/$LOCATION/backupPlans/clusters/$CLUSTER \
      --selected-namespaces=ns1,ns2
      --namespaced-resource-restore-mode=delete-and-restore
      --cluster-resource-conflict-policy=use-backup-version
      --cluster-resources-restore-scope=group/kind
  ```
  
For details on how to restore a backup, see [google documentation](https://cloud.google.com/kubernetes-engine/docs/add-on/backup-for-gke/how-to/restore) 