locals  {


  identity_pool_providers_transformed = concat([
    for pool, specs in var.workload_identity_pool : [
      for provider, provider_specs in lookup(specs, "providers", null): merge({
        pool = pool
        provider = provider
      }, provider_specs)
      if lookup(specs, "providers", null) != null
    ]
  ]...)


  identity_pool_providers_raw = zipmap([for provider in local.identity_pool_providers_transformed: "${provider.pool}_${provider.provider}"], local.identity_pool_providers_transformed )

  identity_pool_providers_map_trusted = {
    for provider, specs in local.identity_pool_providers_raw: provider =>
      contains(keys(local.trusted_issuer_templates), try(specs.oidc.issuer, "null")) ? local.trusted_issuer_templates[specs.oidc.issuer]: null
  }

  identity_pool_providers = {
    for provider, specs in local.identity_pool_providers_raw: provider => {
      project = var.project_id
      provider_id = specs.provider
      pool= specs.pool
      display_name = lookup(specs, "display_name", specs.pool)
      description = lookup(specs, "description", null)
      disabled = lookup(specs, "disabled", false)
      attribute_mapping = merge(
        lookup(local.identity_pool_providers_map_trusted, provider, null) == null ? {} : lookup(local.identity_pool_providers_map_trusted[provider], "attributes", {} ),
        lookup(specs, "attribute_mapping", {})
      )
      attribute_condition = lookup(specs, "attribute_condition", null) == null ? try(
        format(local.identity_pool_providers_map_trusted[provider].condition, specs.owner), null
      ) : specs.attribute_condition
      oidc = lookup(specs, "oidc", null) == null ? null : {
        issuer = lookup(local.identity_pool_providers_map_trusted, provider, null) == null ? specs.oidc.issuer : try(
          format(local.identity_pool_providers_map_trusted[provider].issuer, specs.owner), local.identity_pool_providers_map_trusted[provider].issuer
        )
        allowed_audiences = concat(
          [for item in try(local.identity_pool_providers_map_trusted[provider].allowed_audience, []) : try(format(item, specs.owner), item)],
          try(distinct(specs.oidc.allowed_audiences), [])
        )
      }
      aws = lookup(specs, "aws", null) == null ? null : {
        account_id = specs.aws.account_id
      }
    }
  }
}