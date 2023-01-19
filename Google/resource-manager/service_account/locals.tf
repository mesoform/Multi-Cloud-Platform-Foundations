locals {
  service_accounts_yml = fileexists(var.service_accounts_yml) ? file(var.service_accounts_yml) : null
  service_accounts = try(yamldecode(local.service_accounts_yml), {})

  service_accounts_components = lookup(local.service_accounts, "components", {})
  service_accounts_components_common = lookup(local.service_accounts_components, "common", {})
  service_accounts_components_specs  = lookup(local.service_accounts_components, "specs", {})

  service_accounts_specs = {
    for service_account, config in local.service_accounts_components_specs :
        service_account => merge(local.service_accounts_components_common, config)
  }

  service_accounts_iam_merged = {
    for service_account, specs in local.service_accounts_specs : service_account => concat(lookup(local.service_accounts_components_common, "service_account_iam", []), lookup(specs, "service_account_iam", []))
    if lookup(specs, "service_account_iam", null) != null || lookup(local.service_accounts_components_common, "service_account_iam", null) != null
  }

  service_accounts_iam = {
    for service_account, policy in local.service_accounts_iam_merged : service_account =>
    distinct([
      for binding in policy : {
        role      = lookup(binding, "role", null)
        members   = lookup(binding, "members", null)
        condition = lookup(binding, "condition", {})
      }
    ])
  }
}
