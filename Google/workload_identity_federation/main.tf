//noinspection HILUnresolvedReference
data google_project self {
  project_id = var.project_id == null ? local.workload_identity_pools.project_id : var.project_id
}

module workload_identity_pools {
  source                 = "./workload_identity_pool"
  for_each               = local.workload_identity_pools_specs
  project_id             = data.google_project.self.id
  workload_identity_pool = each.value
}