locals {
  test_var = lookup(local.folder_components, "parent_id", null) == null ? {} : { parent_id : local.folder_components.parent_id }
}

data "external" "test_google_folder" {
  query   = local.test_var
  program = ["python", "${path.module}/test_google_folder.py"]
}
output "google_folder" {
  value = data.external.test_google_folder.result
}



