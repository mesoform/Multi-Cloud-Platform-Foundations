locals {
  clusters_yaml_path = "resources/clusters.yaml"
  clusters_yml = templatefile(local.clusters_yaml_path, {project_id = var.project_id})
  backup_plans = yamldecode(templatefile("resources/backup_plans.yaml", { project_id = var.project_id}))
}

module gke_clusters {
  source = "../../../../Google/gke/cluster"
  clusters_yml = local.clusters_yaml_path
  project_id = var.project_id
}

module gke_backup_separate {
  source = "../../../../Google/gke/backup_plan"
  backup_plans = local.backup_plans
  cluster_id = module.gke_clusters.cluster_ids["standard"]
}

