module workload_identity_pools {
  source                           = "github.com/mesoform/terraform-infrastructure-modules//gcp/iam/workload_identity_federation?ref=v2.2.1"
  for_each                         = local.workload_identity_pools_specs
  project_id                       = var.project_id == null ? local.workload_identity_pools.project_id : var.project_id
  pool_id                          = each.value.pool_id
  display_name                     = lookup(each.value, "display_name", null)
  description                      = lookup(each.value, "description", "")
  disabled                         = lookup(each.value, "disabled" , false)
  workload_identity_pool_providers = lookup(each.value, "providers", {})
}