locals {
  folders_yml = fileexists(var.folders_yml) ? file(var.folders_yml) : null
  folders = try(yamldecode(local.folders_yml), {})
  folder_components       = try(lookup(local.folders, "components", {}), lookup(local.folders, "components"))
  folder_components_specs = lookup(local.folder_components, "specs", {})  
  parent_id = var.parent_folder == null ? lookup(local.folder_components, "parent_id", null) : var.parent_folder
  folder_properties = {for key, value in lookup (local.folder_components, "folders", {}) :
    value["display_name"] => {for name, content in value : name => value["${name}"]}
  }
  //noinspection HILUnresolvedReference
  folder_iam = { for key, value in local.folder_properties :
    key => local.folder_properties[key].folder_iam
    if lookup(local.folder_properties[key], "folder_iam", null) != null
  }
}
