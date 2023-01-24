locals {
  backup_plans_yml = fileexists(var.backup_plans_yml) && (var.backup_plans == null || var.backup_plans == {}) ? file(var.backup_plans_yml) : null
  # Fix for if var.backup_plans is null
  backup_plans = try(yamldecode(local.backup_plans_yml), {for key, values in var.backup_plans: key => values}, {})
  backup_plans_components        = lookup(local.backup_plans, "components", {})
  backup_plans_components_specs  = lookup(local.backup_plans_components, "specs", null)
  backup_plans_components_common = lookup(local.backup_plans_components, "common", null)

  backup_plans_specs_unmerged = var.backup_plans_specs == null ? local.backup_plans_components_specs : var.backup_plans_specs

  backup_plans_specs = { for backup_plan, config in local.backup_plans_specs_unmerged :
    backup_plan => merge(local.backup_plans_components_common == null ? {} : local.backup_plans_components_common, config)
  }
}