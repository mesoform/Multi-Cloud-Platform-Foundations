//noinspection ConflictingProperties,HILUnresolvedReference
resource google_service_account self {
  for_each = local.service_accounts_specs
  account_id = lookup(each.value, "account_id", each.key)
  display_name = lookup(each.value, "display_name", null)
  description = lookup(each.value, "description", null)
  project = lookup(each.value, "project", null)
  disabled = lookup(each.value, "disabled", false)
}

resource google_project_iam_member self {
  for_each = { for idx, binding in local.flatten_iam_list : idx => binding }
  project = each.value.project
  member = "serviceAccount:${google_service_account.self["${each.value.service_account}"].email}"
  role = each.value.role

#  dynamic "condition" {
#     for_each = length(lookup(binding.value, "condition", {})) == 0 ? {} : { condition : binding.value.condition }
#     content {
#       title       = lookup(condition.value, "title", null)
#       description = lookup(condition.value, "description", null)
#       expression  = lookup(condition.value, "expression", null)
#     }
#  }
}
