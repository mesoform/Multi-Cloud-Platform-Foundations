locals {
  projects_yml = fileexists(var.projects_yml) ? file(var.projects_yml) : null
  projects = try(yamldecode(local.projects_yml), {})
  projects_components        = lookup(local.projects, "components", {})
  projects_components_specs  = lookup(local.projects_components, "specs", {})
  projects_components_common = lookup(local.projects_components, "common", {})

  parent_folder = var.parent_folder == null ? lookup(local.projects_components_common, "folder_id", null) : var.parent_folder

  projects_specs = {
    for project, config in local.projects_components_specs :
        project => merge(local.projects_components_common, config)
  }

  projects_iam_merged = {
    for project, specs in local.projects_specs : project => concat(lookup(local.projects_components_common, "project_iam", []), lookup(specs, "project_iam", []))
    if lookup(specs, "project_iam", null) != null || lookup(local.projects_components_common, "project_iam", null) != null
  }

  #Remove duplicate bindings from project_iam_merged and ensure all IAM binding fields are present
  #If project_iam in components.specs doesn't exist the ones from components.copied will be copied into the config in
  #both the definition of both local.projects_specs and local.project_iam_merged
  projects_iam = { for project, policy in local.projects_iam_merged : project =>
    distinct([
      for binding in policy : {
        role = lookup(binding, "role", null)
        members = lookup(binding, "members", null)
        condition = lookup(binding, "condition", {condition = null})
      }
    ])
  }


  projects_labels = {
    for project, specs in local.projects_specs :
        project => merge(lookup(local.projects_components_common, "labels", {}), lookup(specs, "labels", {}))
  }
}
