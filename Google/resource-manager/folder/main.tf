locals {
  parent = can(regex("^folders/", local.parent_id)) ? data.google_folder.self[0].name : data.google_organization.self[0].name
}

data "google_folder" "self" {
  count  = can(regex("^folders/", local.parent_id)) ? 1 : 0
  folder = local.parent_id
}

data "google_organization" "self" {
  count        = can(regex("^organizations/", local.parent_id)) ? 1 : 0
  organization = local.parent_id
}

resource "google_folder" "self" {
  for_each     = local.folder_properties
  display_name = each.value.display_name
  parent       = local.parent
}

resource "google_folder_iam_policy" "self" {
  for_each    = local.folder_properties
  folder      = google_folder.self[each.key].name
  policy_data = data.google_iam_policy.self[each.key].policy_data
}

data "google_iam_policy" "self" {
  for_each = local.folder_properties
  dynamic binding {
    for_each = each.value.folder_iam
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


# data "google_iam_policy" "self" {
#   for_each = local.folder_properties
#   binding {
#     role    = each.value.folder_iam.role
#     members = each.value.folder_iam.members
#     dynamic "condition" {
#       for_each = lookup(each.value.folder_iam, "condition", null) == null ? {} : { condition : each.value.folder_iam.condition }
#       content {
#         title       = lookup(condition.value, "title", null)
#         description = lookup(condition.value, "description", null)
#         expression  = lookup(condition.value, "expression", null)
#       }
#     }
#   }
# }

 output "folder_properties" {
   value = local.folder_properties
 }

 output "folder_iam" {
   value = data.google_iam_policy.self[*]
 }