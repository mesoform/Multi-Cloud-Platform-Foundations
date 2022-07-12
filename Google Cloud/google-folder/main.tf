resource "google_folder" "level_1" {
  for_each     = { for entry in var.folders_map_1 : "${entry.name}.${entry.parent}" => entry }
  display_name = each.value.name
  parent       = each.value.parent
}

resource "google_folder" "level_2" {
  for_each     = { for entry in local.level_2 : "${entry.name}.${entry.parent}" => entry }
  display_name = each.value.name
  parent       = each.value.parent
  depends_on = [
    google.folder.level_1
  ]
}

resource "google_folder" "level_3" {
  for_each     = { for entry in local.level_3 : "${entry.name}.${entry.parent}" => entry }
  display_name = each.value.name
  parent       = each.value.parent
  depends_on = [
    google.folder.level_1,
    google.folder.level_2
  ]
}




