data external test_record_types {
  query   = {for record_type, set in local.cloud_dns_zone_records["production-zone"]: record_type => length(set) }
  program = ["python", "${path.module}/test_record_types.py"]
}
output test_record_types {
  value = data.external.test_record_types.result
}
