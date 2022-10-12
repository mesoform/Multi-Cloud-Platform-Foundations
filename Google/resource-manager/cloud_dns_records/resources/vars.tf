variable "managed_zone" {
  type = string
  description = "Zone recordset applies to"
  nullable = false
}
variable "records" {
  type = map(list(object({
    name    = string
    type    = optional(string, "A")
    rrdatas = optional(list, [])
    geo     = optional(list(object({
                location = string
                rrdatas = list(string)
              })))
    wwr     = optional(list(object({
                weight = number
                rrdatas = list(string)
              })))
  })))
  default = {}
}
