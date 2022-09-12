data external test_skip_delete {
  query   = { skip_delete : local.projects_specs["staging-sandbox"].skip_delete }
  program = ["python", "${path.module}/test_skip_delete.py"]
}
output "skip_delete" {
  value = data.external.test_skip_delete.result
}
data external test_iam_bindings_count {
  query   = {
    staging_sandbox_count = length(local.projects_iam["staging-sandbox"])
    test_project_count = length(local.projects_iam["test-project"])
  }
  program = ["python", "${path.module}/test_iam_bindings_count.py"]
}
output "iam_bindings_count" {
  value = data.external.test_skip_delete.result
}
data external test_labels {
  query = local.projects_labels["staging-sandbox"]
  program = ["python", "${path.module}/test_labels.py"]
}

output labels {
  value = data.external.test_labels.result
}

