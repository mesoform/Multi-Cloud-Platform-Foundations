locals {

  clusters_yml_file = fileexists(var.clusters_yml) ? file(var.clusters_yml) : null
  clusters = try(yamldecode(local.clusters_yml_file), {})
  clusters_components        = lookup(local.clusters, "components", {})
  clusters_components_specs  = lookup(local.clusters_components, "specs", {})
  clusters_components_common = lookup(local.clusters_components, "common", {})
  clusters_specs = { for cluster, config in local.clusters_components_specs :
    cluster => merge({
        autopilot = true,  # Enable autopilot by default
        project_id = var.project_id == null ? try(local.clusters.project_id, local.clusters_components_common.project_id): var.project_id
      },
      local.clusters_components_common,
      config
    )
  }

  clusters_node_pools_merged = {
    for clusters, specs in local.clusters_specs:
      clusters => merge(lookup(local.clusters_components_common, "node_pools", {} ), lookup(specs, "node_pools", {}))
    if !specs.autopilot && !(contains(keys(specs), "node_pools") && lookup(specs, "node_pools", null)==null)
  }

  clusters_node_pools = {for map in flatten([for cluster, node_pools in local.clusters_node_pools_merged: [for node_pool, specs in node_pools: merge(specs, {cluster=cluster, name=node_pool})]]): replace("${map.cluster}_${map.name}", "-","_") => map}

  clusters_backup_plans = {
    for cluster, specs in local.clusters_components_specs: cluster => merge(lookup(local.clusters_components_common, "backup_plans", {}), {
        for backup, config in lookup(specs, "backup_plans", {}): backup => merge({
            location = local.clusters_specs[cluster].location
            project_id = local.clusters_specs[cluster].project_id
        }, config)
    })
    if lookup(specs, "backup_plans", null) != null || lookup(local.clusters_components_common, "backup_plans", null) != null
  }
}