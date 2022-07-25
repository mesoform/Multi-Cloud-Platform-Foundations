
data google_folder self {
  count = can(regex("^folders/", local.parent_id)) ? 1 : 0
  folder = local.parent_id
}

data google_organization self {
  count = can(regex("^organizations/", local.parent_id)) ? 1 : 0
  organization = local.parent_id
}

resource google_folder self {
  for_each     = local.names
  display_name = each.value
  parent       = local.parent
}