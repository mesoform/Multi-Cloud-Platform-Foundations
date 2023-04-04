output pool_id {
  value = { for module, outputs in module.workload_identity_pools : module => lookup(outputs, "pool_id", null) }
}