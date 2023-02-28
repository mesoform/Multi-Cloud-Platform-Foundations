data external test_oidc_provider_issuers {
  query   = {
    for provider, specs in local.identity_pool_providers :
      provider => specs.oidc.issuer
    if lookup(specs, "oidc", null) != null
  }
  program = ["python", "${path.module}/test_oidc_provider_issuers.py"]
}
output test_record_types {
  value = data.external.test_oidc_provider_issuers.result
}
