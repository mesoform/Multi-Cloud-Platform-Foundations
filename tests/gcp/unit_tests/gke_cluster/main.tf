data external autopilot_enabled {
  query   = {for cluster, specs in local.clusters_specs: cluster => tostring(specs.autopilot)}
  program = ["python", "${path.module}/test_autopilot_enabled.py"]
}
output test_autopilot_enabled {
  value = data.external.autopilot_enabled.result
}

data external project_id {
  query   = {for cluster, specs in local.clusters_specs: cluster => specs.project_id}
  program = ["python", "${path.module}/test_project_id.py"]
}
output test_project_id {
  value = data.external.project_id.result
}

data external node_pool {
  query   = { standard = "standard_${try(keys(local.clusters_specs.standard.node_pools)[0], "")}"
              standard_default_cluster = try(local.clusters_node_pools["standard_default"].cluster, "")
              standard_default_name = try(local.clusters_node_pools["standard_default"].name, "")
            }
  program = ["python", "${path.module}/test_node_pool.py"]
}
output test_node_pool {
  value = data.external.node_pool.result
}

data external gke_backups {
  query   = { for cluster, specs in local.clusters_specs: cluster => length(lookup(local.clusters_gke_backups, cluster, {}))}
  program = ["python", "${path.module}/test_gke_backups.py"]
}
output test_gke_backups {
  value = data.external.gke_backups.result
}
