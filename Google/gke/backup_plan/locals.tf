locals {
  backup_plans_yml = fileexists(var.backup_plans_yml) && (var.backup_plans == null || var.backup_plans == {}) ? file(var.backup_plans_yml) : null
  # Fix for if var.backup_plans is null
  backup_plans = try(yamldecode(local.backup_plans_yml), {for key, values in var.backup_plans: key => values}, {})
  backup_plans_components        = lookup(local.backup_plans, "components", {})
  backup_plans_components_specs  = lookup(local.backup_plans_components, "specs", null)
  backup_plans_components_common = lookup(local.backup_plans_components, "common", null)

  backup_plans_specs_unmerged = var.backup_plans_specs == null ? local.backup_plans_components_specs : var.backup_plans_specs

#  # Attempted workarounds which didn't work
#  # This errors if var.backup_plans_specs is {} as the conditions are of different types.
#  backup_plans_specs_unmerged = var.backup_plans_specs == null ? local.backup_plans_components_specs : var.backup_plans_specs
#  # This would still say that var.backup_plans_specs is object with no attributes so type conflict
#  backup_plans_specs_unmerged = var.backup_plans_specs == null || var.backup_plans_specs == {} ? local.backup_plans_components_specs : var.backup_plans_specs == {} ? null : var.backup_plans_specs
#  # This would error in unit tests saying length(null) not allowed. Which is odd because you would think if the first value is true, the second one shouldn't be evaluated.
#  backup_plans_specs_unmerged = var.backup_plans_specs == null || length(var.backup_plans_specs)<=0 ? local.backup_plans_components_specs : var.backup_plans_specs
#  # These would error in deployment tests saying that local.backup_plans_specs contains keys not determined until deployment
#  backup_plans_specs_unmerged = try(length(var.backup_plans_specs)<=0, true)? local.backup_plans_components_specs : var.backup_plans_specs
#  backup_plans_specs_unmerged = try(var.backup_plans_specs == null ? local.backup_plans_components_specs : var.backup_plans_specs, var.backup_plans_specs)

  backup_plans_specs = { for backup_plan, config in local.backup_plans_specs_unmerged :
    backup_plan => merge(local.backup_plans_components_common == null ? {} : local.backup_plans_components_common, config)
  }
}