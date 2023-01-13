data google_project self {
  project_id = var.project_id == null ? local.clusters.project_id : var.project_id
}

# Data resource for retrieving available kubernetes versions
//noinspection HILUnresolvedReference
data google_container_engine_versions self {
  for_each = local.clusters_specs
  location = each.value.location
  project = data.google_project.self.project_id
  version_prefix = lookup(each.value, "release_channel_version", null)
}


//noinspection HILUnresolvedReference
resource google_container_cluster self {
  for_each = local.clusters_specs
  name = replace(each.key, "_", "-")
  project = lookup(each.value, "project_id", data.google_project.self.project_id)
  location =  each.value.location
  enable_autopilot = each.value.autopilot ? true : null
  node_locations = lookup(each.value, "node_locations", null)
  cluster_ipv4_cidr = lookup(each.value, "cluster_ipv4_cidr", null)
  datapath_provider = lookup(each.value, "datapath_provider", null)
  enable_intranode_visibility = each.value.autopilot ? null : lookup(each.value, "enable_intranode_visibility", false)
  enable_kubernetes_alpha = lookup(each.value, "enable_kubernetes_alpha", false)
  enable_l4_ilb_subsetting = lookup(each.value, "enable_l4_ilb_subsetting", false)
  enable_legacy_abac = lookup(each.value, "enable_legacy_abac", false)
  enable_shielded_nodes = each.value.autopilot ? null : lookup(each.value, "enable_shielded_nodes", true )
  logging_service = lookup(each.value, "logging_service", null)
  min_master_version = lookup(each.value, "min_master_vesrion", null)
  monitoring_service = lookup(each.value, "monitoring_service", null)
  networking_mode = each.value.autopilot ? null : lookup(each.value, "networking_mode", "ROUTES")
  node_version = lookup(each.value, "node_version", null)
  private_ipv6_google_access = lookup(each.value, "private_ipv6_google_access", null)
  remove_default_node_pool = each.value.autopilot ? null : try(length(lookup(each.value, "node_pools", {} )) <= 0, true) ? false : lookup(each.value, "remove_default_node_pool", true)
#  remove_default_node_pool = each.value.autopilot ? null : lookup(each.value, "node_pools", {} ) == null || length(lookup(each.value, "node_pools", {} )) <= 0 ? false : lookup(each.value, "remove_default_node_pool", true)
  initial_node_count = each.value.autopilot ? null : lookup(each.value, "remove_default_node_pool", true) || try(length(lookup(each.value, "node_pools", {} )) >= 0, false) ? 1 : lookup(each.value, "initial_node_count", null )
#  ip_allocation_policy {}
  //noinspection HILUnresolvedReference
  dynamic addons_config {
    for_each = lookup(each.value, "addons_config", null) == null ? {} : {addons_config = each.value.addons_config}
    content {
      dynamic cloudrun_config {
        for_each = contains(keys(addons_config.value), "cloudrun_config") ? {cloudrun_config = {enabled = addons_config.value.cloudrun_config}} : {}
        content {
          disabled = !lookup(addons_config.value, "cloudrun_config", false)
          load_balancer_type = lookup(each.value, "cloudrun_internal_lb", false) == false ? null : "LOAD_BALANCER_TYPE_INTERNAL"
        }
      }
      dynamic dns_cache_config {
        for_each = contains(keys(addons_config.value), "dns_cache_config") ? {dns_cache_config = {enabled = addons_config.value.dns_cache_config}} : {}
        content {
          enabled = lookup(addons_config.value, "dns_cache_config", false)
        }
      }
      dynamic gce_persistent_disk_csi_driver_config {
        for_each = contains(keys(addons_config.value), "gce_persistent_disk_csi_driver_config") ? {gce_persistent_disk_csi_driver_config = {enabled = addons_config.value.gce_persistent_disk_csi_driver_config}} : {}
        content {
          enabled = lookup(addons_config.value, "gce_persistent_disk_csi_driver_config", false)
        }
      }
      dynamic gcp_filestore_csi_driver_config {
        for_each = contains(keys(addons_config.value), "gcp_filestore_csi_driver_config") ? {dns_cache_config = {enabled = addons_config.value.gcp_filestore_csi_driver_config}} : {}
        content {
          enabled  = lookup(addons_config.value, "gcp_filestore_csi_driver_config", false)
        }
      }
      dynamic gke_backup_agent_config {
        for_each = contains(keys(addons_config.value), "gke_backup_agent_config") ? {gke_backup_agent_config = {enabled = addons_config.value.gke_backup_agent_config}} : {}
        content {
          enabled = lookup(addons_config.value, "gke_backup_agent_config", false)
        }
      }
      dynamic horizontal_pod_autoscaling {
        for_each = contains(keys(addons_config.value), "horizontal_pod_autoscaling") ? {horizontal_pod_autoscaling = {enabled = addons_config.value.horizontal_pod_autoscaling}} : {}
        content {
          disabled = !lookup(addons_config.value, "horizontal_pod_autoscaling", true)
        }
      }
      dynamic http_load_balancing {
        for_each = contains(keys(addons_config.value), "http_load_balancing") ? {http_load_balancing = {enabled = addons_config.value.http_load_balancing}} : {}
        content {
          disabled = !lookup(addons_config.value, "http_load_balancing", true)
        }
      }
      dynamic network_policy_config {
        for_each = contains(keys(addons_config.value), "network_policy_config") ? {network_policy_config = {enabled = addons_config.value.network_policy_config}} : {}
        content {
          disabled = !lookup(addons_config.value, "network_policy_config", false)
        }
      }
      ## Addons in beta
      #      istio_config {
      #        disabled = !lookup(addons_config.value, "istio_config", false)
      #      }
      #      identity_service_config {
      #        enabled = lookup(addons_config.value, "identity_service_config", false )
      #      }
      #      kalm_config {
      #        enabled = lookup(addons_config.value, "kalm_config", false)
      #      }
      #      config_connector_config {
      #        enabled = lookup(addons_config.value, "config_connector_config", false)
      #      }
    }
  }

  dynamic authenticator_groups_config {
    for_each = lookup(each.value, "authenticator_groups_config", {} )
    content {
      security_group = authenticator_groups_config.value.security_group
    }
  }

  dynamic binary_authorization {
    for_each = lookup(each.value, "binary_authorization", {})
    content {
      evaluation_mode = binary_authorization.value.evaluation_mode
    }
  }

  //noinspection HILUnresolvedReference
  dynamic cluster_autoscaling {
    for_each = lookup(each.value, "cluster_autoscaling", null) == null ? {} : {cluster_autoscaling = each.value.cluster_autoscaling}
    //noinspection HILUnresolvedReference
    content {
      enabled = each.value.autopilot ? null : lookup(cluster_autoscaling.value, "enabled", null)
      //noinspection HILUnresolvedReference
      dynamic auto_provisioning_defaults {
        for_each = lookup(cluster_autoscaling.value, "auto_provisioning_defaults", null) == null ? {} : {auto_provisioning_defaults = cluster_autoscaling.value.auto_provisioning_defaults}
        content {
          boot_disk_kms_key = lookup(auto_provisioning_defaults.value, "boot_disk_kms_key", null)
          disk_size = lookup(auto_provisioning_defaults.value, "disk_size", null)
          disk_type = lookup(auto_provisioning_defaults.value, "disk_type", null)
          image_type = lookup(auto_provisioning_defaults.value, "image_type", null)
          min_cpu_platform = lookup(auto_provisioning_defaults.value, "min_cpu_platform", null)
          oauth_scopes = lookup(auto_provisioning_defaults.value, "oauth_scopes", null)
          service_account = lookup(auto_provisioning_defaults.value, "service_account", null)
          //noinspection HILUnresolvedReference
          dynamic management {
            for_each = lookup(auto_provisioning_defaults.value, "management", null) == null ? {} : {management = auto_provisioning_defaults.value.management}
            content {
              auto_upgrade = lookup(management.value, "auto_upgrade", null)
              auto_repair = lookup(management.value, "auto_repair", null)
            }
          }
          //noinspection HILUnresolvedReference
          dynamic upgrade_settings {
            for_each = lookup(auto_provisioning_defaults.value, "upgrade_settings", null) == null ? {} : {upgrade_settings = auto_provisioning_defaults.value.upgrade_settings}
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
          dynamic shielded_instance_config {
            for_each = lookup(auto_provisioning_defaults.value, "shielded_instance_config", null) == null ? {} : {shielded_instance_config = auto_provisioning_defaults.value.shielded_instance_config}
            content {
              enable_secure_boot = lookup(shielded_instance_config.value, "enable_secure_boot", false )
              enable_integrity_monitoring = lookup(shielded_instance_config.value, "enable_integrity_monitoring", true )
            }
          }
        }
      }
      //noinspection HILUnresolvedReference
      dynamic resource_limits {
        for_each = lookup(cluster_autoscaling.value, "resource_limits", {})
        content {
          resource_type = resource_limits.key
          minimum = lookup(resource_limits.value, "minimum", null)
          maximum = lookup(resource_limits.value, "maximum", null)
        }
      }
    }
  }

  dynamic confidential_nodes {
    for_each = lookup(each.value, "confidential_nodes", null) == null ? {} : {confidential_nodes = each.value.confidential_nodes}
    content {
      enabled = lookup(confidential_nodes.value, "enabled", false)
    }
  }

  dynamic cost_management_config {
    for_each = lookup(each.value, "cost_management_config", null) == null ? {} : {cost_management_config = each.value.cost_management_config}
    content {
      enabled = lookup(cost_management_config.value, "enabled", false)
    }
  }

  //noinspection HILUnresolvedReference
  dynamic database_encryption {
    for_each = lookup(each.value, "database_encryption", null) == null ? {} : {database_encryption = each.value.database_encryption}
    //noinspection HILUnresolvedReference
    content {
      state = database_encryption.value.state
      key_name = database_encryption.value.key_name
    }
  }

  dynamic default_snat_status {
    for_each = lookup(each.value, "default_snat_status", null) == null ? {} : {default_snat_status = each.value.default_snat_status}
    content {
      disabled = lookup(default_snat_status.value, "disabled", false)
    }
  }

  dynamic dns_config {
    for_each = lookup(each.value, "dns_config", {})
    content {
      cluster_dns = lookup(dns_config.value, "cluster_dns", "PROVIDER_UNSPECIFIED")
      cluster_dns_scope = lookup(dns_config.value, "cluster_dns_scope", "DNS_SCOPE_UNSPECIFIED")
      cluster_dns_domain = lookup(dns_config.value,"cluster_dns_domain", null )
    }
  }
#
#  //noinspection HILUnresolvedReference
  dynamic ip_allocation_policy {
    for_each = lookup(each.value, "autopilot", true) ? {ip_allocation_policy = {}} : lookup(each.value, "ip_allocation_policy", null) == null ? {} : {ip_allocation_policy = each.value.ip_allocation_policy}
    content {
      cluster_ipv4_cidr_block = lookup(ip_allocation_policy.value, "cluster_ipv4_cidr_block", null)
      cluster_secondary_range_name = lookup(ip_allocation_policy.value, "cluster_secondary_range_name", null)
      services_secondary_range_name = lookup(ip_allocation_policy.value, "services_secondary_range_name", null)
      services_ipv4_cidr_block = lookup(ip_allocation_policy.value, "service_ipv4_cidr_block", null)
    }
  }

  dynamic logging_config {
    for_each = lookup(each.value, "logging_config", null) == null ? {} : {logging_config: each.value.logging_config}
    content {
      enable_components = lookup(logging_config.value, "enable_components", [])
    }
  }

  dynamic master_auth {
    for_each = lookup(each.value, "master_auth", null ) == null ? {} : {master_auth: each.value.master_auth}
    content {
      client_certificate_config {
        issue_client_certificate = lookup(master_auth.value, "issue_client_certificate", true)
      }
    }
  }

  dynamic master_authorized_networks_config {
    for_each = lookup(each.value, "master_authorized_networks_config", null) == null ? {} : {master_authorized_networks_config: each.value.master_authorized_networks_config}
    content {
      dynamic cidr_blocks {
        for_each = lookup(master_authorized_networks_config.value, "cidr_blocks", [])
        content {
          cidr_block = lookup(cidr_blocks.value, "cidr_block", null)
          display_name = lookup(cidr_blocks.value, "display_name", null)
        }
      }
      gcp_public_cidrs_access_enabled = lookup(master_authorized_networks_config.value, "gcp_public_cidrs_access_enabled", null)
    }
  }

  dynamic mesh_certificates {
    for_each = lookup(each.value, "mesh_certificates", null) == null ? {} : {mesh_certificates = each.value.mesh_certificates}
    content {
      enable_certificates = lookup(mesh_certificates.value, "enabled", false)
    }
  }

  dynamic monitoring_config {
    for_each = lookup(each.value, "monitoring_config", null) == null ? {} : {monitoring_config: each.value.monitoring_config}
    content{
      enable_components = lookup(monitoring_config.value, "enable_components", [])
      managed_prometheus {
        enabled = lookup(monitoring_config.value, "managed_prometheus", false)
      }
    }
  }

  #  pod_security_policy_config {}
  dynamic notification_config{
    for_each = lookup(each.value, "notification_config", null) == null ? {} : {notification_config: each.value.notification_config}
    content {
      pubsub {
        enabled = notification_config.value.enabled
        topic = lookup(notification_config.value, "topic", null)
        dynamic filter {
          for_each = lookup(notification_config.value, "filter", null) == null ? {} : {filter = notification_config.value.filter}
          content {
            event_type = lookup(filter.value, "event_type", null )
          }
        }
      }
    }
  }

  dynamic release_channel {
    for_each = lookup(each.value, "release_channel", null) == null ? {} : {release_channel = each.value.release_channel}
    content {
      channel = lookup(release_channel.value, "channel", "REGULAR")
    }
  }

  dynamic service_external_ips_config {
    for_each = lookup(each.value, "service_external_ips_config", null) == null ? {} : {service_external_ips_config = each.value.service_external_ips_config}
    content {
      enabled = lookup(service_external_ips_config.value, "enabled", true)
    }
  }

  dynamic vertical_pod_autoscaling {
    for_each = lookup(each.value, "vertical_pod_autoscaling", null) == null ? {} : {confidential_nodes = each.value.vertical_pod_autoscaling}
    content {
      enabled = lookup(confidential_nodes.value, "enabled", false)
    }
  }

  dynamic workload_identity_config {
    for_each = each.value.autopilot ? {} : lookup(each.value, "workload_identity_config", null) == null ? {} : {workload_identity_config = each.value.workload_identity_config}
    content {
      workload_pool = lookup(workload_identity_config.value, "workload_pool", null )
    }
  }
}



module gke_backup {
  source = "../backup"
  for_each = local.clusters_gke_backups
  gke_backup_specs = {for backup, config in each.value: backup => merge({cluster_id = google_container_cluster.self[each.key].id}, config)}
  project_id = data.google_project.self.project_id
#  gke_backup_specs = merge(each.value, {cluster_id = google_container_cluster.self[each.key].id})
}

