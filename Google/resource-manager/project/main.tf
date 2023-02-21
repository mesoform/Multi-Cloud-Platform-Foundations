//noinspection ConflictingProperties,HILUnresolvedReference
resource google_project self {
  for_each            = local.projects_specs
  name                = lookup(each.value, "name", each.key)
  project_id          = each.value.project_id
  org_id              = local.projects_parent[each.key].parent_org == null ? null : trimprefix(local.projects_parent[each.key].parent_org, "organizations/")
  folder_id           = local.projects_parent[each.key].parent_folder == null ? null : trimprefix(local.projects_parent[each.key].parent_folder, "folders/")
  billing_account     = lookup(each.value, "billing_account", null)
  skip_delete         = lookup(each.value, "skip_delete", null)
  labels              = local.projects_labels[each.key]
  auto_create_network = lookup(each.value, "auto_create_network", null)
}

resource google_project_iam_policy self {
  for_each    = local.projects_iam
  project     = google_project.self[each.key].id
  policy_data = data.google_iam_policy.self[each.key].policy_data
}

data google_iam_policy self {
  for_each = local.projects_iam
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

resource time_sleep self {
  count = local.enable_service_delay == null ? 0 : 1
  depends_on = [google_project_iam_policy.self]
  create_duration = local.enable_service_delay
}

//noinspection HILUnresolvedReference
resource google_project_service self {
  for_each = local.projects_services
  depends_on = [time_sleep.self]

  project = google_project.self[each.value.project].id
  service = each.value.service
  disable_on_destroy = each.value.disable_on_destroy
  disable_dependent_services = each.value.disable_dependent_services
}

module essential_contacts {
  source = "../sub_modules/essential_contacts"
  for_each = local.projects_essential_contacts
  parent_id = google_project.self[each.key].id
  language_tag = lookup(each.value, "language_tag", "en-GB")
  essential_contacts = lookup(each.value, "contacts", {})
}