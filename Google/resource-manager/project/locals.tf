locals {
  projects_yml = fileexists(var.projects_yml) ? file(var.projects_yml) : null
  projects = try(yamldecode(local.projects_yml), {})
  projects_components       = try(lookup(local.projects, "components", {}), lookup(local.projects, "components"))
  projects_components_specs = lookup(local.projects_components, "specs", {})  
  project_properties = {for key, value in lookup (local.projects_components, "projects", {}) : 
    key => {for name, content in value : name => value["${name}"]}
  }

}
