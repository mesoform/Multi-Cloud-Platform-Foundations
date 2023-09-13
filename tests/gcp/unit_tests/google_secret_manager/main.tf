data external test_labels {
  query = local.secrets_labels["second_test"]
  program = ["python", "${path.module}/test_labels.py"]
}

output labels {
  value = data.external.test_labels.result
}

data external test_annotations {
  query = local.secrets_annotations["second_test"]
  program = ["python", "${path.module}/test_annotations.py"]
}

output annotations {
  value = data.external.test_annotations.result
}

data external test_iam_bindings_count {
  query   = {
    for secret, policies in local.secrets_iam: secret => length(policies)
  }
  program = ["python", "${path.module}/test_iam_bindings_count.py"]
}

output iam_bindings_count {
  value = data.external.test_iam_bindings_count.result
}

