//noinspection ConflictingProperties,HILUnresolvedReference
resource "google_project" "self" {
  for_each            = local.projects_specs
  name                = lookup(each.value, "name", each.key)
  project_id          = each.value.project_id
  org_id              = local.parent_folder == null ? lookup(each.value, "org_id", null) : null
  folder_id           = local.parent_folder
  billing_account     = lookup(each.value, "billing_account", null)
  skip_delete         = lookup(each.value, "skip_delete", null)
  labels              = local.projects_labels[each.key]
  auto_create_network = lookup(each.value, "auto_create_network", null)
}

resource "google_project_iam_policy" "self" {
  for_each    = local.projects_iam
  project     = google_project.self[each.key].name
  policy_data = data.google_iam_policy.self[each.key].policy_data
}

data "google_iam_policy" "self" {
  for_each = local.projects_iam
  dynamic binding {
    for_each = each.value
    content {
      role    = lookup(binding.value, "role", null)
      members = lookup(binding.value, "members", null)
      //noinspection HILUnresolvedReference
      dynamic "condition" {
      for_each = lookup(binding.value, "condition", { condition = null }) == { condition = null } ? {} : { condition : binding.value.condition }
        content {
          title       = lookup(condition.value, "title", null)
          description = lookup(condition.value, "description", null)
          expression  = lookup(condition.value, "expression", null)
        }
      }
    }
  }
}
