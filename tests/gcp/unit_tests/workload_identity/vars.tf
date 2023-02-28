variable workload_identity_pools_yml {
  description = "Path to MCCF configuration file"
  default = "./gke_backup.yaml"
}

variable workload_identity_pools {
  description = "workload_identity_pool configuration object decoded from file (i.e. yamldecode(file(somefile)))"
  type = any
  default = null
}

variable workload_identity_pools_specs {
  description = "specs of backup plans in same format of local.workload_identity_pools_specs. Only for use with clusters module"
  default = null
}
