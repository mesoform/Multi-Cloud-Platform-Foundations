module records {
  for_each = local.cloud_dns_records
  source = "resources/"
  managed_zone = each.key
  records = each.value
}