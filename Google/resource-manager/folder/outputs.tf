output folder_names {
  value = { for key, value in google_folder.self : key => lookup(value, "name", null) }
}