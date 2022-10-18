variable "projects_yml" {
}

variable "parent_folder" {
  type = string
  description = "Numeric ID of parent folder"
  default = null
}

variable "parent_org" {
  type = string
  description = "Numeric ID of parent organization"
  default = null
}
