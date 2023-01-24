variable backup_plans_yml {
  description = "Path to MCCF configuration file"
  default = "./gke_backup.yaml"
}

variable backup_plans {
  description = "backup_plan configuration object decoded from file (i.e. yamldecode(file(somefile)))"
  type = any
  default = null
}

variable backup_plans_specs {
  description = "specs of backup plans in same format of local.backup_plans_specs. Only for use with clusters module"
  default = null
}

variable project_id {
  type = string
  default = null
}

# This variable should be used when creating a backup plan for a cluster that has been created through terraform
# therefore using the cluster_id from creating that resource as the input for the cluster_id in this module
variable cluster_id {
  type = string
  default = null
}