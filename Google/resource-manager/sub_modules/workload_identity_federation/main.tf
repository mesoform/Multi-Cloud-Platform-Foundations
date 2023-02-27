//noinspection HILUnresolvedReference
resource google_iam_workload_identity_pool self {
  for_each = var.workload_identity_pool
  project = var.project_id
  workload_identity_pool_id = each.key
  display_name = each.value.display_name == null ?  each.key : each.value.display_name
  description = each.value.description
  disable = each.value.disable
}

//noinspection HILUnresolvedReference
resource google_iam_workload_identity_pool_provider self {
  for_each = local.identity_pool_providers
  project = var.project_id
  workload_identity_pool_id = each.value.pool
  workload_identity_pool_provider_id = each.value.provider
  display_name = lookup(each.value, "display_name", each.value.pool)
  description = lookup(each.value, "description", "")
  disabled = lookup(each.value, "disabled", false)
  attribute_mapping = lookup(each.value, "attribute_mapping", {})
  attribute_condition = lookup(each.value, "attribute_condition", {} )
  dynamic "aws" {
    for_each = lookup(each.value, "aws", null) == null ? {} : each.value.aws
    content {
      account_id = aws.value.account_id
    }
  }
  dynamic "oidc" {
    for_each = lookup(each.value, "aws", null) == null ? {} : each.value.aws
    content {
      issuer_uri = lookup(local.known_issuers, oidc.issuer, oidc.issuer)
      allowed_audiences = lookup(oidc.value, "allowed_audiences")
    }
  }
}