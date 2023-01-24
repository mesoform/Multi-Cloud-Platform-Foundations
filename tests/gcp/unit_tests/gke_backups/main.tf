data external cluster {
  query   = { for plan, specs in local.gke_backup_specs: plan => lookup(specs, "cluster_id", "")}
  program = ["python", "${path.module}/test_cluster.py"]
}
output test_cluster {
  value = data.external.cluster.result
}
