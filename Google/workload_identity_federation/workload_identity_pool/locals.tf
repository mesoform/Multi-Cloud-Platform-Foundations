locals  {
  identity_pool_providers_map_trusted = {
    for provider, specs in var.workload_identity_pool.providers: provider =>
      contains(keys(local.trusted_issuer_templates), try(specs.oidc.issuer, "null")) ? local.trusted_issuer_templates[specs.oidc.issuer]: null
  }
  identity_pool_providers = {
    for provider, specs in var.workload_identity_pool.providers: provider => {
      project = var.project_id
      provider_id = provider
      display_name = lookup(specs, "display_name", provider)
      description = lookup(specs, "description", null)
      disabled = lookup(specs, "disabled", false)
      attribute_mapping = merge(
        lookup(local.identity_pool_providers_map_trusted, provider, null) == null ? {} : lookup(local.identity_pool_providers_map_trusted[provider], "attributes", {} ),
        lookup(specs, "attribute_mapping", {})
      )
      //noinspection HILUnresolvedReference
      attribute_condition = lookup(specs, "attribute_condition", null) == null ? try(
        specs.oidc.issuer == "bitbucket" ? format(local.identity_pool_providers_map_trusted[provider].condition, specs.workspace_uuid) :format(local.identity_pool_providers_map_trusted[provider].condition, specs.owner),
        null
      ) : specs.attribute_condition
      oidc = lookup(specs, "oidc", null) == null ? null : {
        //noinspection HILUnresolvedReference
        issuer = lookup(local.identity_pool_providers_map_trusted, provider, null) == null ? specs.oidc.issuer : try(
          format(local.identity_pool_providers_map_trusted[provider].issuer, specs.owner), local.identity_pool_providers_map_trusted[provider].issuer
        )
        //noinspection HILUnresolvedReference
        allowed_audiences = concat(
          [ for item in try(local.identity_pool_providers_map_trusted[provider].allowed_audiences, []) : try(
            specs.oidc.issuer == "bitbucket" ? format(item, specs.workspace_uuid) : format(item, specs.owner), # Bitbucket uses workspace UUID instead of workspace name (i.e. specs.owner)
            item
          )],
          try(distinct(specs.oidc.allowed_audiences), [])
        )
      }
      aws = lookup(specs, "aws", null) == null ? null : {
        account_id = specs.aws.account_id
      }
    }
  }
}