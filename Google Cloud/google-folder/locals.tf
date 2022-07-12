locals {
  level_3 = flatten([for key, data in var.folders_map_3 :
    [for key, value in local.data_level_2 : {
      name   = data.name
      parent = value.id
      } if
      value.parent_name == regex("^(\\w*)/", data.parent)[0] &&
      value.name == regex("/(\\w*)$", data.parent)[0]
    ]
  ])
  data_level_2 = flatten([
    for key, value in local.level_2 : [
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
  level_2 = [for key, data in var.folders_map_2 : {
    name        = data.name
    parent      = local.data_level_1["${data.parent}"]
    parent_name = data.parent
    }
  ]

  data_level_1 = {
    for key, value in google_folder.level_1 :
    lookup(value, "display_name", null) => lookup(value, "name", null)
  }
}
