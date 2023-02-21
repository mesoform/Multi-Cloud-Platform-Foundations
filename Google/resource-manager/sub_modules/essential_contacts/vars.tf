variable essential_contacts {
  type = map(list(string))
  default = {}
  validation {
    condition = alltrue([for key in keys(var.essential_contacts): (length(regexall("\\w*@\\w*\\.\\w*", key)) > 0)])
    error_message = "Key for map must be valid email address."
  }
}

variable language_tag {
  type = string
  default = "en-GB"
}

variable parent_id {
  type = string
  validation {
    condition = contains(["folders", "projects", "organizations"], split("/", var.parent_id)[0])
    error_message = "Invalid parent id, must take format 'organizations/{organization_id}', 'folders/{folder_id}' or 'projects/{project_id}'"
  }
}