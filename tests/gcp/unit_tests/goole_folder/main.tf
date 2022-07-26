locals {
  test_var = lookup(local.folder_components, "parent_id", null) == null ? {} : { parent_id : local.folder_components.parent_id }
}

data "google_folder" "self" {
  count  = can(regex("^folders/", local.parent_id)) ? 1 : 0
  folder = local.parent_id
}

data "google_organization" "self" {
  count        = can(regex("^organizations/", local.parent_id)) ? 1 : 0
  organization = local.parent_id
}

data "external" "test_google_folder" {
  query   = local.test_var
  program = ["python", "${path.module}/test_google_folder.py"]
}
output "google_folder" {
  value = data.external.test_google_folder.result
}



