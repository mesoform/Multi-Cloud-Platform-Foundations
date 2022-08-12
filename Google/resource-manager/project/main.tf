resource "google_project" "self" {
  for_each            = local.project_properties
  name                = each.value.name
  project_id          = each.value.project_id
  org_id              = lookup(each.value, "org_id", null)
  folder_id           = lookup(each.value, "folder_id", null)
  billing_account     = lookup(each.value, "billing_account", null)
  skip_delete         = lookup(each.value, "skip_delete", null)
  labels              = lookup(each.value, "labels", null)
  auto_create_network = lookup(each.value, "auto_create_network", null)
}

resource "google_project_iam_policy" "self" {
  for_each    = local.project_properties
  project     = google_project.self[each.key].name
  policy_data = data.google_iam_policy.self[each.key].policy_data
}

data "google_iam_policy" "self" {
  for_each = local.project_properties
  dynamic binding {
    for_each = each.value.project_iam
    content {
      role    = lookup(binding.value, "role", null)
      members = lookup(binding.value, "members", null)
      dynamic "condition" {
      for_each = lookup(binding.value, "condition", null) == null ? {} : { condition : binding.value.condition }
      content {
        title       = lookup(condition.value, "title", null)
        description = lookup(condition.value, "description", null)
        expression  = lookup(condition.value, "expression", null)
      }
    }
  }
  }
}
