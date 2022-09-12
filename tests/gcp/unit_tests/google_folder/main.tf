data external test_folder_parent_id {
  query   = {parent_id = local.folders_components_common.parent_id}
  program = ["python", "${path.module}/test_folder_parent_id.py"]
}
output folder_parent_id {
  value = data.external.test_folder_parent_id.result
}

data external test_parent_folder_org_count {
  query   = {
    folder_count = local.parent_folder
    org_count = local.parent_organization
  }
  program = ["python", "${path.module}/test_parent_folder_org_count.py"]
}

output folder_parent_org_count {
  value = data.external.test_parent_folder_org_count.result
}
