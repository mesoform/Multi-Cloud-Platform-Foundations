variable project_id {
  type = string
}

variable workload_identity_pool {
  type = map(object({
    display_name = optional(string, null)
    description = optional(string, "")
    disable = optional(bool, false)
    providers = optional(map(any))
  }))
}

