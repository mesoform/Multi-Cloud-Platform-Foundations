locals {
  folders_yml = fileexists(var.folders_yml) ? file(var.folders_yml) : null
  folders = try(yamldecode(local.folders_yml), {})
  folders_components        = lookup(local.folders, "components", {})
  folders_components_specs  = lookup(local.folders_components, "specs", {})
  folders_components_common = lookup(local.folders_components, "common", {})

  parent_id = var.parent_folder == null ? lookup(local.folders_components_common, "parent_id", null) : var.parent_folder

  parent_folder = can(regex("^folders/", local.parent_id)) ? 1 : 0
  parent_organization = can(regex("^organizations/", local.parent_id)) ? 1: 0


  folders_specs = {
    for folder, config in local.folders_components_specs :
      folder => merge(local.folders_components_common, config)
  }


  folders_iam_merged = {
    for folder, specs in local.folders_specs : folder => concat(lookup(local.folders_components_common, "folder_iam", []), lookup(specs, "folder_iam", []))
    if lookup(specs, "folder_iam", null) != null || lookup(local.folders_components_common, "folder_iam", null) != null
  }

  #Remove duplicate bindings from folder_iam_merged and ensure all IAM binding fields are present
  #If folder_iam in components.specs doesn't exist the ones from components.copied will be copied into the config in
  #both the definition of both local.folder_specs and local.folder_iam_merged
  folders_iam = { for folder, policy in local.folders_iam_merged : folder =>
    distinct([
      for binding in policy : {
        role = lookup(binding, "role", null)
        members = lookup(binding, "members", null)
        condition = lookup(binding, "condition", { condition = null })
      }
    ])
#    distinct([
#      for binding in policy : {
#        role = lookup(binding, "role", null)
#        members = lookup(binding, "members", null)
#        condition = lookup(binding, "condition", { condition = null })
#      }
#    ])
  }
}
