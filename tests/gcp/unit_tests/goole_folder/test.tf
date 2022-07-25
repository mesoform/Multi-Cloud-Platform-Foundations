
data external test_google_folder {
  query   = local.parent_id
  program = ["python", "${path.module}/test_google_folder.py"]
}
output docker_config {
  value = data.external.test_google_folder.result
}



