data external test_folder_parent_id {
  query   = {parent_id = local.folders_components_common.parent_id}
  program = ["python", "${path.module}/test_folder_parent_id.py"]
}
output folder_parent_id {
  value = data.external.test_folder_parent_id.result
}

data external test_folder_iam {
  query   = {for folder, bindings in local.folders_iam: folder => tostring(length(bindings))}
  program = ["python", "${path.module}/test_iam_bindings_count.py"]
}
output test_folder_iam {
  value = data.external.test_folder_parent_id.result
}
