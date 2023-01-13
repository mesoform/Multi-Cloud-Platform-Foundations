locals {
  clusters_yaml_path = "resources/gke_clusters.yaml"
  clusters_yml = templatefile(local.clusters_yaml_path, {project_id = var.project_id})
  gke_backup = yamldecode(templatefile("resources/gke_backups.yaml", { project_id = var.project_id}))
}

module gke_clusters {
  source = "../../../../Google/gke/cluster"
  clusters_yml = local.clusters_yaml_path
  project_id = var.project_id
}

module gke_backup_separate {
  source = "../../../../Google/gke/backup"
  gke_backup = local.gke_backup
  cluster_id = module.gke_clusters.cluster_ids["manual"]
}

