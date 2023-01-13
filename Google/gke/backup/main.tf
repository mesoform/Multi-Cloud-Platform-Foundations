data google_project self {
  project_id = var.project_id == null ? local.gke_backup.project_id : var.project_id
}

resource google_gke_backup_backup_plan self {
  provider = google-beta
  for_each = local.gke_backup_specs
  project = data.google_project.self.project_id
  cluster = var.cluster_id == null ? each.value.cluster_id : var.cluster_id
  name = lookup(each.value, "name", each.key)
  location = lookup(each.value, "location", null)
  dynamic backup_config {
    for_each = lookup(each.value, "backup_config", null) == null ? {backup_config = {}} : {backup_config = each.value.backup_config}
    content {
      all_namespaces = lookup(backup_config.value, "all_namespaces", true)
      include_secrets = lookup(backup_config.value, "include_secrets", true)
      include_volume_data = lookup(backup_config.value, "include_volume_data", true)
      dynamic selected_applications {
        for_each = lookup(backup_config.value, "selected_applications", null ) == null ? {} : {selected_applications: backup_config.value.selected_applications}
        content {
          dynamic namespaced_names {
            for_each = lookup(selected_applications.value, "namespaced_names", [])
            content {
              namespace = namespaced_names.value.namespace
              name = namespaced_names.value.name
            }
          }
        }
      }
      dynamic selected_namespaces {
        for_each = lookup(backup_config.value, "selected_namespaces", null) == null ? {} : {selected_namespaces: backup_config.value.selected_namespaces}
        content {
          namespaces = lookup(selected_namespaces.value, "namespaces", [])
        }
      }
    }
  }
  dynamic backup_schedule {
    for_each = lookup(each.value, "backup_schedule", null ) == null ? {} : {backup_schedule = each.value.backup_schedule}
    content {
      cron_schedule = lookup(backup_schedule.value, "cron_schedule", null)
      paused = lookup(backup_schedule.value, "paused", false)
    }
  }
  dynamic retention_policy {
    for_each = lookup(each.value, "retention_policy", null) == null ? try(each.value.backup_schedule.cron_schedule!=null, false)? {retention_policy = {}}: {} : {retention_policy = each.value.retention_policy}
    content {
      backup_delete_lock_days = lookup(retention_policy.value, "backup_delete_lock_days", null)
      backup_retain_days = lookup(retention_policy.value, "backup_retain_days", 1)
      locked = try(lookup(retention_policy.value, "locked", false), false) # Hack for avoiding type error from retention_policy being a map(number)
    }
  }
}
