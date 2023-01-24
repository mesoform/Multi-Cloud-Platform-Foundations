locals {
  gke_backup_yml = fileexists(var.gke_backup_yml) && length(var.gke_backup) <= 0 ? file(var.gke_backup_yml) : null
  gke_backup = try(yamldecode(local.gke_backup_yml), var.gke_backup)
  gke_backup_components        = lookup(local.gke_backup, "components", {})
  gke_backup_components_specs  = lookup(local.gke_backup_components, "specs", null)
  gke_backup_components_common = lookup(local.gke_backup_components, "common", null)

#  gke_backup_specs_yaml = try({ for backup_plan, config in local.gke_backup_components_specs :
#    backup_plan => merge({autopilot = true, project_id = lookup(local.gke_backup, "project_id")}, local.gke_backup_components_common, config)
#  }, null)
#  gke_backup_specs = length(var.gke_backup_specs) > 0 ? var.gke_backup_specs : local.gke_backup_specs_yaml
##  gke_backup_specs = length(var.gke_backup_specs) > 0 ? var.gke_backup_specs : local.gke_backup_specs_yaml

#  gke_backup_specs_unmerged = length(var.gke_backup_specs)<=0 ? local.gke_backup_components_specs : var.gke_backup_specs

#  gke_backup_specs_unmerged_2 = var.gke_backup_specs == null ||

#  gke_backup_specs_unmerged = var.gke_backup_specs == null || length(var.gke_backup_specs)<=0 ? local.gke_backup_components_specs : var.gke_backup_specs
  gke_backup_specs_unmerged = one(var.gke_backup_specs == null ? [] : [var.gke_backup_specs]) == null ? local.gke_backup_components_specs : var.gke_backup_specs
#  gke_backup_specs_unmerged = try(length(var.gke_backup_specs)<=0, true) ? local.gke_backup_components_specs : var.gke_backup_specs

  gke_backup_specs = { for backup_plan, config in local.gke_backup_specs_unmerged :
    backup_plan => merge(local.gke_backup_components_common == null ? {} : local.gke_backup_components_common, config)
  }
}