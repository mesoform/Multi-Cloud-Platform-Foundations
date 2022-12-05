locals {
  service_accounts_yml              = fileexists(var.service_accounts_yml) ? file(var.service_accounts_yml) : null
  service_accounts                  = try(yamldecode(local.service_accounts_yml), {})

  service_accounts_config = {
    for service_account, config in local.service_accounts :
    service_account => config
  }

  service_accounts_iam = {
    for service_account, specs in local.service_accounts_config : service_account => lookup(specs, "iam_bindings", {})
    if lookup(specs, "iam_bindings", null) != null
  }

  flatten_iam_list = flatten([for service_account, bindings in local.service_accounts_iam :
          flatten([for binding in bindings :{
                  "service_account" = service_account
                  "role" = lookup(binding, "role")
                  "project" = lookup(binding, "project")}
                 ])
          ])
}
