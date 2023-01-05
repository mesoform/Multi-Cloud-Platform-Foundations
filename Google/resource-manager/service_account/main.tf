//noinspection ConflictingProperties,HILUnresolvedReference
resource google_service_account self {
  for_each = local.service_accounts
  account_id = lookup(each.value, "account_id", each.key)
  display_name = lookup(each.value, "display_name", null)
  description = lookup(each.value, "description", null)
  project = lookup(each.value, "project", null)
  disabled = lookup(each.value, "disabled", false)
}

resource google_service_account_iam_policy self {
  for_each    = local.service_accounts_binding
  service_account_id = google_service_account.self[each.key].id
  policy_data = data.google_iam_policy.self[each.key].policy_data
}

data google_iam_policy self {
  for_each = local.service_accounts_binding
  dynamic binding {
    for_each = each.value
    content {
      role    = lookup(binding.value, "role", null)
      members = lookup(binding.value, "members", null)
      //noinspection HILUnresolvedReference
      dynamic "condition" {
        for_each = length(lookup(binding.value, "condition", {})) == 0 ? {} : { condition : binding.value.condition }
        content {
          title       = lookup(condition.value, "title", null)
          description = lookup(condition.value, "description", null)
          expression  = lookup(condition.value, "expression", null)
        }
      }
    }
  }
}
