variable gke_backup_yml {
  default = "resources/gke_backups.yaml"
}

variable gke_backup {
  type = any
  default = {}
}

variable gke_backup_specs {
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