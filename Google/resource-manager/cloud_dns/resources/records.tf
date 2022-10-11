data "google_dns_managed_zone" "self" {
  name = var.managed_zone
}

resource google_dns_record_set A_records {
  for_each = var.A_records
}
resource google_dns_record_set CNAME_records {
  for_each = var.CNAME_records
}
resource google_dns_record_set TXT_records {
  for_each = var.TXT_records
}
resource google_dns_record_set MX_records {
  for_each = var.MX_records
}