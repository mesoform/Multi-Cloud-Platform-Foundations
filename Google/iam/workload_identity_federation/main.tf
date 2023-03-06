module workload_identity_pools {
  source                 = "github.com/mesoform/terraform-infrastructure-modules//gcp/iam/workload_identity_federation?ref=06fd7e1879a9d968a74f2f278af1232644228fe2"
  for_each               = local.workload_identity_pools_specs
  project_id             = var.project_id == null ? local.workload_identity_pools.project_id : var.project_id
  workload_identity_pool = each.value
}