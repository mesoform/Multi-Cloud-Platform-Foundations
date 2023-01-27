output cluster_ids {
  value = { for key, value in google_container_cluster.self : key => tostring(lookup(value, "id", null)) }
}