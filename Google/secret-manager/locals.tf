locals {
  secrets_yml = fileexists(var.secrets_yml) ? file(var.secrets_yml) : null
  secrets = try(yamldecode(local.secrets_yml), {})
  secrets_components        = lookup(local.secrets, "components", {})
  secrets_components_specs  = lookup(local.secrets_components, "specs", {})
  secrets_components_common = lookup(local.secrets_components, "common", {})

  secrets_specs = {
    for secret, config in local.secrets_components_specs :
        secret => merge(local.secrets_components_common, config)
  }


  secrets_iam_merged = {
    for secret, specs in local.secrets_specs : secret => concat(lookup(local.secrets_components_common, "secret_iam", []), lookup(specs, "secret_iam", []))
    if lookup(specs, "secret_iam", null) != null || lookup(local.secrets_components_common, "secret_iam", null) != null
  }

  #Remove duplicate bindings from secrets_iam_merged and ensure all IAM binding fields are present
  #If secrets_iam in components.specs doesn't exist the ones from components.common will be copied into the config in
  #both the definition of local.secrets_specs and local.secrets_iam_merged
  secrets_iam = { for secret, policy in local.secrets_iam_merged : secret =>
    distinct([
      for binding in policy : {
        role = lookup(binding, "role", null)
        members = lookup(binding, "members", null)
        condition = lookup(binding, "condition", {})
      }
    ])
  }

  secrets_labels = {
    for secret, specs in local.secrets_specs :
        secret => merge(lookup(local.secrets_components_common, "labels", {}), lookup(specs, "labels", {}))
  }

  secrets_annotations = {
    for secret, specs in local.secrets_specs :
        secret => merge(lookup(local.secrets_components_common, "annotations", {}), lookup(specs, "annotations", {}))
  }
}

