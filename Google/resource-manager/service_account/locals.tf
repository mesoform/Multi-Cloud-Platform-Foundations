locals {
  service_accounts_yml              = fileexists(var.service_accounts_yml) ? file(var.service_accounts_yml) : null
  service_accounts                  = try(yamldecode(local.service_accounts_yml), {})
  service_accounts_components       = lookup(local.service_accounts, "components", {})
  service_accounts_components_specs = lookup(local.service_accounts_components, "specs", {})

  service_accounts_specs = {
    for service_account, config in local.service_accounts_components_specs :
    service_account => config
  }

  service_accounts_iam = {
    for service_account, specs in local.service_accounts_specs : service_account => lookup(specs, "project_roles", {})
    if lookup(specs, "project_roles", null) != null
  }

  flatten_iam_list = flatten([for service_account, bindings in local.service_accounts_iam :
          flatten([for binding in bindings :{
                  "service_account" = service_account
                  "role" = lookup(binding, "role")
                  "project" = lookup(binding, "project")}
                 ])
          ])
}
