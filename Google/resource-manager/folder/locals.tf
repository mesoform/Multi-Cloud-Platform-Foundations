locals {
  folders_yml = fileexists(var.folders_yml) ? file(var.folders_yml) : null
  folders = try(yamldecode(local.folders_yml), {})
  folders_components        = lookup(local.folders, "components", {})
  folders_components_specs  = lookup(local.folders_components, "specs", {})
  folders_components_common = lookup(local.folders_components, "common", {})

  parent_id = var.parent_folder == null ? lookup(local.folders_components_common, "parent_id", null) : var.parent_folder

  folders_specs = {
    for folder, config in local.folders_components_specs :
      folder => merge(local.folders_components_common, config)
  }

  set_iam_policy = {
    for folder, specs in local.folders_specs: folder => lookup(specs, "folder_iam", false) != false || lookup(local.folders_components_common, "folder_iam", false) != false
  }

  # If blank IAM policy is set, but common components are set, ignore the override common with blank IAM.
  folders_iam_merged = {
    for folder, specs in local.folders_specs : folder => lookup(specs, "folder_iam", []) == null ? [] :
      concat( lookup(local.folders_components_common, "folder_iam", []), lookup(specs, "folder_iam", []))
    if local.set_iam_policy[folder]
  #    if lookup(specs, "folder_iam", null) != null || lookup(local.folders_components_common, "folder_iam", null) != null
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
  }
}
