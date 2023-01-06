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

data external test_parent {
  query   = {
    parent_folder = local.projects_parent["staging-sandbox"].parent_folder == null ? "null" : local.projects_parent["staging-sandbox"].parent_folder
    parent_org = local.projects_parent["staging-sandbox"].parent_org == null ? "null" : local.projects_parent["staging-sandbox"].parent_org
  }
  program = ["python", "${path.module}/test_parent.py"]
}

output test_parents {
  value = data.external.test_parent.result
}

data external test_services {
  query   = { for service, map in local.projects_services: service => map.disable_on_destroy
  }
  program = ["python", "${path.module}/test_services.py"]
}

output test_services {
  value = data.external.test_services.result
}

