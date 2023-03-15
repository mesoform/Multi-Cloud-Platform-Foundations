data external test_common_provider_owner {
  query   = {
    for provider, specs in lookup(local.workload_identity_pools_specs["cicd"], "providers", {}) :
      provider => lookup(specs, "owner", "null")
  }
  program = ["python", "${path.module}/test_common_provider_owner.py"]
}
output test_common_provider_owner {
  value = data.external.test_common_provider_owner.result
}

