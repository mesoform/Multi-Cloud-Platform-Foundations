locals {
  cloud_dns_records_yml = fileexists(var.cloud_dns_records_yml) ? file(var.cloud_dns_records_yml) : null
  cloud_dns_records = try(yamldecode(local.cloud_dns_records_yml), {})
  cloud_dns_records_components        = lookup(local.cloud_dns_records, "components", {})
  cloud_dns_records_components_specs  = lookup(local.cloud_dns_records_components, "specs", {})
  cloud_dns_records_components_common = lookup(local.cloud_dns_records_components, "common", {})

  cloud_dns_records_specs = {
    for zone, record_type in local.cloud_dns_records_components_specs :
      zone => merge(local.cloud_dns_records_components_common, record_type)
  }

  cloud_dns_record_sets = {
    for zone, record_type in local.cloud_dns_records_components_specs: zone => {
      A_records = lookup(record_type, "A_records", [])
      AAAA_records = lookup(record_type, "AAAA_records", [])
      ALIAS_records = lookup(record_type, "ALIAS_records", [])
      CAA_records = lookup(record_type, "CAA_records", [])
      CNAME_records = lookup(record_type, "CNAME_records", [])
      DNSKEY_records = lookup(record_type, "DNSKEY_records", [])
      DS_records = lookup(record_type, "DS_records", [])
      HTTPS_records = lookup(record_type, "HTTPS_records", [])
      IPSECKEY_records = lookup(record_type, "IPSECKEY_records", [])
      MX_records = lookup(record_type, "MX_records", [])
      NAPTR_records = lookup(record_type, "NAPTR_records", [])
      PTR_records = lookup(record_type, "PTR_records", [])
      SOA_records = lookup(record_type, "SOA_records", [])
      SPF_records = lookup(record_type, "SPF_records", [])
      SRV_records = lookup(record_type, "SRV_records", [])
      SSHFP_records = lookup(record_type, "SSHFP_records", [])
      SVCB_records = lookup(record_type, "SVCB_records", [])
      TLSA_records = lookup(record_type, "TLSA_records", [])
      TXT_records = lookup(record_type, "TXT_records", [])
    }
  }
}