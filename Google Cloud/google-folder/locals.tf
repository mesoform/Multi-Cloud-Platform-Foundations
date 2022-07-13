locals {
  folders_yml = fileexists(var.folders_yml) ? file(var.folders_yml) : null

  folders = local.folders_yml == null ? {} : yamldecode(local.folders_yml)
# -----------------------------------------------------------------------
#                         data readed from file
# -----------------------------------------------------------------------
  folders_level_1 = flatten([
    for app, config in local.folders :
    lookup(config, "level_1", null)
  ])
  folders_level_2 = flatten([
    for app, config in local.folders :
    lookup(config, "level_2", null)
    if lookup(config, "level_2", null) != null
  ])
  folders_level_3 = flatten([
    for app, config in local.folders :
    lookup(config, "level_3", null)
    if lookup(config, "level_3", null) != null
  ])
#------------------------------------------------------------------------- 
#                     data converted to 
#                     name = "name"
#                     parent = "parent"
#------------------------------------------------------------------------- 
  level_1 = flatten([for folder in local.folders_level_1 : [
    for value in folder["name"] :
    {
      parent = folder["parent"]
      name   = value
    }]
  ])

  level_2 = flatten([for folder in local.folders_level_2 : [
    for value in folder["name"] :
    {
      parent = folder["parent"]
      name   = value
    }]
  ])

  level_3 = flatten([for folder in local.folders_level_3 : [
    for value in folder["name"] :
    {
      parent = folder["parent"]
      name   = value
    }]
  ])
#-------------------------------------------------------------------------
#                    data prepared to use in 
#                    terraform resources
#-------------------------------------------------------------------------
  resource_level_3 = flatten([for key, data in local.level_3 :
    [for key, value in local.data_level_2 : {
      name   = data.name
      parent = value.id
      } if
      value.parent_name == split("/", data.parent)[0] &&
      value.name == split("/", data.parent)[1]
    ]
  ])
  data_level_2 = flatten([
    for key, value in local.resource_level_2 : [
      for key, data in google_folder.level_2[*] : [
        for folder, config in data : {
          name        = value.name
          parent      = config.parent
          id          = config.id
          parent_name = value.parent_name
        } if value.name == config.display_name &&
        value.parent == config.parent
      ]
    ]
  ])
  resource_level_2 = [for key, value in local.level_2 : {
    name        = value.name
    parent      = local.data_level_1["${value.parent}"]
    parent_name = value.parent
    }
  ]

  data_level_1 = {
    for key, value in google_folder.level_1 :
    lookup(value, "display_name", null) => lookup(value, "name", null)
  }
}
