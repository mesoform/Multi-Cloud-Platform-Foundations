//noinspection HILUnresolvedReference
resource google_iam_workload_identity_pool self {
  for_each = var.workload_identity_pool
  project = var.project_id
  workload_identity_pool_id = replace(each.key, "_", "-")
  display_name = each.value.display_name == null ?  each.key : each.value.display_name
  description = each.value.description
  disabled = each.value.disabled
}


resource google_iam_workload_identity_pool_provider self {
  for_each = local.identity_pool_providers
  project = each.value.project
  workload_identity_pool_id = google_iam_workload_identity_pool.self[each.value.pool].workload_identity_pool_id
  workload_identity_pool_provider_id = replace(each.value.provider_id, "_", "-")
  display_name = each.value.display_name
  description = each.value.description
  disabled = each.value.disabled
  attribute_mapping = each.value.attribute_mapping
  attribute_condition = each.value.attribute_condition
  dynamic "aws" {
    for_each = lookup(each.value, "aws", null) == null ? {} : { aws = each.value.aws}
    content {
      account_id = aws.value.account_id
    }
  }
  dynamic "oidc" {
    for_each = lookup(each.value, "oidc", null) == null ? {} : { oidc = each.value.oidc }
    content {
      issuer_uri = oidc.value.issuer
      allowed_audiences = lookup(oidc.value, "allowed_audiences", []) == [] ? null : oidc.value.allowed_audiences
    }
  }
}