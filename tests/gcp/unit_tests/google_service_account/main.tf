data external test_disabled {
  query = {
    disabled : local.service_accounts_specs["test-account-disabled-noiam"].disabled
    disabled : local.service_accounts_specs["test-account-single-iam-condition"].disabled
    disabled : local.service_accounts_specs["test-account-multi-iam"].disabled
}
  program = ["python", "${path.module}/test_disabled.py"]
}
output "disabled" {
  value = data.external.test_disabled.result
}

data external test_iam_bindings_count {
  query   = {
    test_account2_bindings_count = length(local.service_accounts_iam["test-account-single-iam-condition"])
    test_account3_bindings_count = length(local.service_accounts_iam["test-account-multi-iam"])
  }
  program = ["python", "${path.module}/test_iam_bindings_count.py"]
}

output "iam_bindings_count" {
  value = data.external.test_iam_bindings_count.result
}

data external test_iam_members_count {
  query   = {
    test_account2_members_count = length(distinct(flatten(local.service_accounts_iam["test-account-single-iam-condition"].*.members)))
    test_account3_members_count = length(distinct(flatten(local.service_accounts_iam["test-account-multi-iam"].*.members)))
  }
  program = ["python", "${path.module}/test_iam_members_count.py"]
}

output "iam_members_count" {
  value = data.external.test_iam_members_count.result
}
