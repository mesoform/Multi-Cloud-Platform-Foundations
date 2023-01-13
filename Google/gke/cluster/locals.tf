locals {

  clusters_yml_file = fileexists(var.clusters_yml) ? file(var.clusters_yml) : null
  clusters = try(yamldecode(local.clusters_yml_file), {})
  clusters_components        = lookup(local.clusters, "components", {})
  clusters_components_specs  = lookup(local.clusters_components, "specs", {})
  clusters_components_common = lookup(local.clusters_components, "common", {})
  clusters_specs = { for cluster, config in local.clusters_components_specs :
    cluster => merge({
        autopilot = true,  # Set autop
        project_id = var.project_id == null ? lookup(local.clusters, "project_id", local.clusters_components_common.project_id): var.project_id
      },
      local.clusters_components_common,
      config
    )
  }

  clusters_node_pools_merged = {
    for clusters, specs in local.clusters_specs:
      clusters => merge(lookup(local.clusters_components_common, "node_pools", {} ), lookup(specs, "node_pools", {}))
    if !specs.autopilot && !(contains(keys(specs), "node_pools") && lookup(specs, "node_pools", null)==null)
#    if !specs.autopilot && length(lookup(specs, "node_pools", {})) <= 0
#    (!(contains(keys(specs), "node_pools") && lookup(specs, "node_pools", null)==null) && length(lookup(local.clusters_components_common, "node_pools", {})) <= 0)
#    if !(specs.autopilot || length(lookup(specs, "node_pools", {})) <= 0) || length(lookup(local.clusters_components_common, "node_pools", {})) <= 0
  }

  clusters_node_pools = {for map in flatten([for cluster, node_pools in local.clusters_node_pools_merged: [for node_pool, specs in node_pools: merge(specs, {cluster=cluster, name=node_pool})]]): replace("${map.cluster}_${map.name}", "-","_") => map}

#  clusters_node_pools_merged = {
#    for clusters, specs in local.clusters_specs: clusters => merge({
#      location = specs.location
#      node_locations = lookup(specs, "node_location", [])
#    }, lookup(local.clusters_components_common, "node_pools", {}))
#    if !(specs.autopilot || lookup(specs, "node_pools", null) == null) || lookup(local.clusters_components_common, "node_pools", null) != null
#  }
  clusters_gke_backups = {
    for cluster, specs in local.clusters_specs: cluster => {
      for backup, config in specs.gke_backups: backup => merge({
        location = specs.location
      }, config)}
    if lookup(specs, "gke_backups", null) != null
  }
#  clusters_gke_backup = {
#    for cluster, specs in local.clusters_specs: cluster => merge({
#      location = specs.location
#    }, specs.gke_backup)
#    if lookup(specs, "gke_backup", null) != null
#  }
#  cluster_node_pools = {for cluster, node_pools in local.cluster_node_pools_merged: }
}