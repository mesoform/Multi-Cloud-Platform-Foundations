module records {
  for_each = local.cloud_dns_records
  source = "./resources/"
  managed_zone = each.key
  records = each.value
  project_id = lookup(local.cloud_dns_specs[each.key], "project_id", null)
  ttl = lookup(local.cloud_dns_specs[each.key], "ttl", null)
}
