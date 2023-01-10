data external test_disabled {
  query   = { disabled : local.service_accounts_specs["test-account"].disabled }
  program = ["python", "${path.module}/test_disabled.py"]
}
output "disabled" {
  value = data.external.test_disabled.result
}

data external test_iam_bindings_count {
  query   = {
    test_account_count = length(local.service_accounts_iam["test-account"])
    test_account2_count = length(local.service_accounts_iam["test-account2"])
  }
  program = ["python", "${path.module}/test_iam_bindings_count.py"]
}

output "iam_bindings_count" {
  value = data.external.test_iam_bindings_count.result
}
