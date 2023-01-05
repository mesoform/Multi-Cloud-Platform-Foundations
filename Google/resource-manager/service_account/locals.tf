locals {
  service_accounts_yml = fileexists(var.service_accounts_yml) ? file(var.service_accounts_yml) : null
  service_accounts     = try(yamldecode(local.service_accounts_yml), {})

  service_accounts_iam = {
    for service_account, specs in local.service_accounts : service_account => lookup(specs, "service_account_iam", {})
    if lookup(specs, "service_account_iam", null) != null
  }

  service_accounts_binding = {
    for project, policy in local.service_accounts_iam : project =>
    distinct([
      for binding in policy : {
        role      = lookup(binding, "role", null)
        members   = lookup(binding, "members", null)
        condition = lookup(binding, "condition", {})
      }
    ])
  }
}
