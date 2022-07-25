locals {
  folders_yml = fileexists(var.folders_yml) ? file(var.folders_yml) : null
  folders = local.folders_yml == null ? {} : yamldecode(local.folders_yml)
  parent_id = lookup(local.folders.components, "parent_id", {})
  parent = can(regex("^folders/", local.parent_id)) ? data.google_folder.self[0].name : data.google_organization.self[0].name
  names = toset(lookup (local.folders.components, "display_name", []))
}
