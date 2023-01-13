
### Recommended Deployment Patterns
#### Per Cluster

e.g. cluster_1_backups.yaml:
```yaml
components:
  common:
    cluster_id:
  specs:
    daily_ns_1:
      backup_config:
    daily_ns_2:
      backup_config:
    all:
      backup_config:
```

This is the method used when creating a backup plan alongside with mcp `cluster` adapter

#### Repeatable per backup type
e.g. weekly_backups.yaml
```yaml
components:
  common:
    backup_config:
    backup_schedule:
  specs:
    cluster_1_weekly:
      cluster_id: 
    cluster_2_weekly:
      cluster_id:
    cluster_3_weekly:
      cluster_id:
```