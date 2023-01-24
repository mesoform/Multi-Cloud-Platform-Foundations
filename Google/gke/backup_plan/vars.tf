variable gke_backup_yml {
  default = "./gke_backup.yaml"
}

variable gke_backup {
  type = any
  default = {}
}

variable gke_backup_specs {
  default = {}
}

variable project_id {
  type = string
  default = null
}

variable cluster_id {
  type = string
  default = null
}