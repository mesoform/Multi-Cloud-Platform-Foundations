locals {
  workload_identity_pools_yml = fileexists(var.workload_identity_pools_yml) && (var.workload_identity_pools == null || var.workload_identity_pools == {}) ? file(var.workload_identity_pools_yml) : null
  # Fix for if var.workload_identity_pools is null
  workload_identity_pools = try(yamldecode(local.workload_identity_pools_yml), {for key, values in var.workload_identity_pools: key => values}, {})
  workload_identity_pools_components        = lookup(local.workload_identity_pools, "components", {})
  workload_identity_pools_components_specs  = lookup(local.workload_identity_pools_components, "specs", null)
  workload_identity_pools_components_common = lookup(local.workload_identity_pools_components, "common", null)

  workload_identity_pools_specs_unmerged = var.workload_identity_pools_specs == null ? local.workload_identity_pools_components_specs : var.workload_identity_pools_specs

  workload_identity_pools_specs = { for workload_identity_pool, config in local.workload_identity_pools_specs_unmerged :
    workload_identity_pool => merge({pool_id = workload_identity_pool},local.workload_identity_pools_components_common == null ? {} : local.workload_identity_pools_components_common, config)
  }
}