variable backup_plans_yml {
  default = "resources/backup_plans.yaml"
}

variable backup_plans {
  type = any
  default = null
}

variable backup_plans_specs {
  default = null
}

variable project_id {
  type = string
  default = "something"
}

variable cluster_id {
  type = string
  default = null
}