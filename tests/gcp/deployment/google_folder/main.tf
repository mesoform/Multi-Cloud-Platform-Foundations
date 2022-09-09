module folders{
  source = "../../../../Google/resource-manager/folder"
  folders_yml = "resource/folders.yaml"
}

module "sub_folders" {
  source = "../../../../Google/resource-manager/folder"
  folders_yml = "resource/sub-folders.yaml"
  parent_folder = module.folders.folder_names["python"]
}
