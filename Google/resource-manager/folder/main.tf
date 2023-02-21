resource "google_folder" "self" {
  for_each     = local.folders_specs
  display_name = lookup(each.value, "display_name", each.key)
  parent       = local.parent_id
}

resource "google_folder_iam_policy" "self" {
  for_each    = local.folders_iam
  folder      = google_folder.self[each.key].name
  policy_data = data.google_iam_policy.self[each.key].policy_data
}

data "google_iam_policy" "self" {
  for_each = local.folders_iam
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
          expression  = lookup(condition.value, "expression", {condition = null})
        }
      }
    }
  }
}

module essential_contacts {
  source = "../sub_modules/essential_contacts"
  for_each = local.folders_essential_contacts
  parent_id = google_folder.self[each.key].name
  language_tag = lookup(each.value, "language_tag", "en-GB")
  essential_contacts = lookup(each.value, "contacts", {})
}