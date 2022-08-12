locals {
  test_var = lookup(local.project_properties[0], "skip_delete", null) == null ? {} : { skip_delete : local.project_properties[0].skip_delete }
}

data "external" "test_google_project" {
  query   = local.test_var
  program = ["python", "${path.module}/test_google_project.py"]
}
output "google_project" {
  value = data.external.test_google_project.result
}

