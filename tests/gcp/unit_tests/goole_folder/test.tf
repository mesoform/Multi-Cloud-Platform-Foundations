
data external test_google_folder {
  query   = local.level_1[0]
  program = ["python", "${path.module}/test_google_folder.py"]
}
output docker_config {
  value = data.external.test_google_folder.result
}



