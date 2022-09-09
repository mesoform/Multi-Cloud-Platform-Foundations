locals {
  projects_yml = fileexists(var.projects_yml) ? file(var.projects_yml) : null
  projects = try(yamldecode(local.projects_yml), {})
  projects_components       = try(lookup(local.projects, "components", {}), lookup(local.projects, "components"))
  projects_components_specs = lookup(local.projects_components, "specs", {})
  parent_folder = var.parent_folder == null ? lookup(local.projects_components, "folder_id", null) : var.parent_folder
  project_properties = {for key, value in lookup (local.projects_components, "projects", {}) :
    value["name"] => {for name, content in value : name => value["${name}"]}
  }
  projects_iam = { for key, value in local.project_properties :
    key => lookup(local.project_properties[key], "project_iam", {})
  }
}
