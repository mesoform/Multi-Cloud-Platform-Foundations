locals {
  folders_yml = fileexists(var.folders_yml) ? file(var.folders_yml) : null
  folders = try(yamldecode(local.folders_yml), {})
  folder_components       = try(lookup(local.folders, "components", {}), lookup(local.folders, "components"))
  folder_components_specs = lookup(local.folder_components, "specs", {})  
  parent_id = lookup(local.folder_components, "parent_id", {})
  folder_properties = {for key, value in lookup (local.folder_components, "folders", {}) : 
    key => {for name, content in value : name => value["${name}"]}
  }
}
