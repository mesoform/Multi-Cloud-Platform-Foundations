variable "managed_zone" {
  type = string
  description = "Zone recordset applies to"
  nullable = false
}

variable "project_id" {
  type = string
  nullable = false
}

variable "ttl" {
  type = number
  default = null
}

variable "records" {
  type = map(list(object({
    name    = optional(string)
    rrdatas = optional(list(string))
    ttl     = optional(string)
    routing_policy = optional(object({
      geo     = optional(list(object({
        location = string
        rrdatas = list(string)
      })), [])
      wrr     = optional(list(object({
        weight = number
        rrdatas = list(string)
      })), [])
    }), {})
  })))
  default = {}
}