locals {
  folders_yml = fileexists(var.folders_yml) ? file(var.folders_yml) : null
  folders = try(yamldecode(local.folders_yml), {})
  folder_components       = try(lookup(local.folders, "components", {}), lookup(local.folders, "components"))
  folder_components_specs = lookup(local.folder_components, "specs", {})  
  parent_id = lookup(local.folder_components, "parent_id", {})
  parent = can(regex("^folders/", local.parent_id)) ? data.google_folder.self[0].name : data.google_organization.self[0].name
  folder_properties = {for key, value in lookup (local.folders.components, "folders", {}) : 
    key => value
  }
}
