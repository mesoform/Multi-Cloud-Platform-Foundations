# output "level_1_folders" {
#   value = google_folder.level_1[*]
# }

# output "level_2_folders" {
#   value = google_folder.level_2[*]
# }

output "data_level_2" {
  value = local.data_level_2
}

output "level_3" {
  value = local.level_3
}

# output "level_2" {
#   value = local.level_2
# }

output "level_1" {
  value = local.data_level_1
}