locals {
  gke_backup_yml = fileexists(var.gke_backup_yml) && length(var.gke_backup) <= 0 ? file(var.gke_backup_yml) : null
  gke_backup = try(yamldecode(local.gke_backup_yml), var.gke_backup)
  gke_backup_components        = lookup(local.gke_backup, "components", {})
  gke_backup_components_specs  = lookup(local.gke_backup_components, "specs", null)
  gke_backup_components_common = lookup(local.gke_backup_components, "common", null)
#
#  gke_backup_components        = try(local.gke_backup.components, null)
#  gke_backup_components_specs  = try(local.gke_backup_components.specs, null)
#  gke_backup_components_common = try(local.gke_backup_components.common, null)

#  gke_backup_specs_yaml = try({ for backup_plan, config in local.gke_backup_components_specs :
#    backup_plan => merge({autopilot = true, project_id = lookup(local.gke_backup, "project_id")}, local.gke_backup_components_common, config)
#  }, null)
#  gke_backup_specs = length(var.gke_backup_specs) > 0 ? var.gke_backup_specs : local.gke_backup_specs_yaml
##  gke_backup_specs = length(var.gke_backup_specs) > 0 ? var.gke_backup_specs : local.gke_backup_specs_yaml

  gke_backup_specs_unmerged = length(var.gke_backup_specs)<=0 ? local.gke_backup_components_specs : var.gke_backup_specs

  gke_backup_specs = { for backup_plan, config in local.gke_backup_specs_unmerged :
    backup_plan => merge(local.gke_backup_components_common == null ? {} : local.gke_backup_components_common, config)
  }
#  gke_backup_specs = length(var.gke_backup_specs)<=0 ? { for backup_plan, config in try(local.gke_backup_components_specs, {}) :
#    backup_plan => merge(local.gke_backup_components_common, config)
#  } : var.gke_backup_specs


#  gke_backup_retention_policy = { for backup_plan, specs in local.gke_backup_specs:
#    backup_plan => {
#
#    }
#    if contains(keys(specs), "retention_policy") || lookup(lookup(specs, "backup_schedule", {})
#  }
  gke_backups_create_key = { for backup_plan, specs in local.gke_backup_specs :
    backup_plan => {

    }
    if lookup(specs, "create_kms_key", false)

  }
}