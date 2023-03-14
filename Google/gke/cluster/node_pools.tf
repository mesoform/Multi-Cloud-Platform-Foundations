resource google_container_node_pool self {
  for_each = local.clusters_node_pools
  name = each.value.name
  cluster = google_container_cluster.self[each.value.cluster].id
  #  cluster = google_container_cluster.self[each.key].id
  location = try(each.value.location, lookup(local.clusters_specs[each.value.cluster], "location", null))
  project = data.google_project.self.project_id
  initial_node_count = lookup(each.value, "initial_node_count", null)
  max_pods_per_node = lookup(each.value, "max_pods_per_node", null)
  node_count = lookup(each.value, "node_count", null)
  node_locations = lookup(each.value, "node_locations", null)
  version = lookup(each.value, "version", null )
  dynamic management {
    for_each = lookup(each.value, "management", null) == null ? {} : {management = each.value.management}
    content {
      auto_upgrade = lookup(management.value, "auto_upgrade", true)
      auto_repair = lookup(management.value, "auto_repair", true)
    }
  }
  dynamic node_config {
    for_each = lookup(each.value, "node_config", null ) == null ? {} : {node_config: each.value.node_config}
    content {
      boot_disk_kms_key = lookup(node_config.value, "boot_disk_kms_key", null)
      disk_size_gb = lookup(node_config.value, "disk_size_gb", null)
      disk_type = lookup(node_config.value, "disk_type", null)
      image_type = lookup(node_config.value, "image_type", null)
      labels = lookup(node_config.value, "labels", {})
      local_ssd_count = lookup(node_config.value, "local_ssd_count", null)
      machine_type = lookup(node_config.value, "machine_type", null)
      metadata = lookup(node_config.value, "metadata", null)
      min_cpu_platform = lookup(node_config.value, "min_cpu_platform", null)
      oauth_scopes = lookup(node_config.value, "boot_disk_kms_key", ["https://www.googleapis.com/auth/cloud-platform"])
      preemptible = lookup(node_config.value, "preemptible", null)
      service_account = lookup(node_config.value, "service_account", null)
      spot = lookup(node_config.value, "spot", null)
      tags = lookup(node_config.value, "tags", [])
      dynamic guest_accelerator {
        for_each = lookup(node_config.value, "guest_accelerator", null ) == null ? {} : {guest_accelerator: each.value.guest_accelerator}
        content {
          count = lookup(guest_accelerator.value, "count", 0)
          type  = lookup(guest_accelerator.value, "type", null)
        }
      }
      dynamic taint {
        for_each = lookup(each.value, "taint", {})
        content {
          effect = lookup(taint.value, "effect", null)
          key    = lookup(taint.value, "key", null)
          value  = lookup(taint.value, "value", null)
        }
      }
      gcfs_config {
        enabled = lookup(each.value, "gcfs_config", false)
      }
      gvnic {
        enabled = lookup(each.value, "gvnic", false)
      }
      dynamic shielded_instance_config {
        for_each = lookup(each.value, "shielded_instance_config", null) == null ? {} : {shielded_instance_config = each.value.shielded_instance_config}
        content {
          enable_secure_boot = lookup(shielded_instance_config.value, "enable_secure_boot", false )
          enable_integrity_monitoring = lookup(shielded_instance_config.value, "enable_integrity_monitoring", true )
        }
      }
#      dynamic workload_metatdata_config
    }
  }
  dynamic upgrade_settings {
    for_each = lookup(each.value, "upgrade_settings", null) == null ? {} : {upgrade_settings = each.value.upgrade_settings}
    content {
      strategy = lookup(upgrade_settings.value, "strategy", "SURGE")
      max_surge = lookup(upgrade_settings.value, "max_surge", 0)
      max_unavailable = lookup(upgrade_settings.value, "max_unavailable", 0)
      //noinspection HILUnresolvedReference
      dynamic blue_green_settings {
        for_each = lookup(upgrade_settings.value, "blue_green_settings", null) == null ? {} : {blue_green_settings = upgrade_settings.value.blue_green_settings}
        content {
          node_pool_soak_duration = lookup(blue_green_settings.value, "node_pool_soak_duration", null)
          //noinspection HILUnresolvedReference
          dynamic standard_rollout_policy {
            for_each = lookup(blue_green_settings.value, "standard_rollout_policy", null) == null ? {} : {standard_rollout_policy = blue_green_settings.value.standard_rollout_policy}
            content {
              batch_percentage = lookup(standard_rollout_policy.value, "batch_percentage", null )
              batch_node_count = lookup(standard_rollout_policy.value, "batch_node_count", null )
              batch_soak_duration = lookup(standard_rollout_policy.value, "batch_soak_duration", null )
            }
          }
        }
      }
    }
  }
}