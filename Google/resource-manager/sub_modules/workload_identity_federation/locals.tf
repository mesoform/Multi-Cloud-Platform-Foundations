locals  {
  bitbucket_workspace = lookup({}, "", "")
  known_issuers = {
    github-actions = "https://token.actions.githubusercontent.com"
    bitbucket-pipelines = "https://api.bitbucket.org/2.0/workspaces/%s/pipelines-config/identity/oidc"
  }
#  identity_pool_providers_merged = { for pool, specs in var.workload_identity_pool : pool => [
#      for provider, provider_specs in lookup(specs, "providers", {}):
#    ]
#  }
  identity_pool_providers_transformed = concat([
    for pool, specs in var.workload_identity_pool : [
      for provider, provider_specs in lookup(specs, "providers", null): merge({
        pool = pool
        provider = provider
      }, provider_specs)
      if lookup(specs, "providers", null) != null
    ]
  ]...)


  identiy_pool_providers = zipmap([for provider in local.identity_pool_providers_transformed: "${provider.pool}_${provider.provider}"], local.identity_pool_providers_transformed )
}