data "google_dns_managed_zone" "self" {
  name = var.managed_zone
}

resource google_dns_record_set A_records {
  for_each = lookup(var.records, "A_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "A"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set AAAA_records {
  for_each = lookup(var.records, "AAAA_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "AAAA"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set ALIAS_records {
  for_each = lookup(var.records, "ALIAS_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "ALIAS"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set CAA_records {
  for_each = lookup(var.records, "CAA_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "CAA"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set CNAME_records {
  for_each = lookup(var.records, "CNAME_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "CNAME"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set DNSKEY_records {
  for_each = lookup(var.records, "DNSKEY_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "DNSKEY"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set DS_records {
  for_each = lookup(var.records, "DS_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "DS"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set HTTPS_records {
  for_each = lookup(var.records, "HTTPS_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "HTTPS"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set IPSECKEY_records {
  for_each = lookup(var.records, "IPSECKEY_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "IPSECKEY"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set MX_records {
  for_each = lookup(var.records, "MX_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "MX"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set NAPTR_records {
  for_each = lookup(var.records, "NAPTR_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "NAPTR"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set PTR_records {
  for_each = lookup(var.records, "PTR_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "PTR"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set SOA_records {
  for_each = lookup(var.records, "SOA_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "SOA"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set SPF_records {
  for_each = lookup(var.records, "SPF_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "SPF"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set SRV_records {
  for_each = lookup(var.records, "SRV_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "SRV"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set SSHFP_records {
  for_each = lookup(var.records, "SSHFP_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "SSHFP"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set SVCB_records {
  for_each = lookup(var.records, "SVCB_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "SVCB"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set TLSA_records {
  for_each = lookup(var.records, "TLSA_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "TLSA"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

resource google_dns_record_set TXT_records {
  for_each = lookup(var.records, "TXT_records", [])
  managed_zone = data.google_dns_managed_zone.self.name
  name = lookup(each.value, "name", null) == null ? data.google_dns_managed_zone.self.dns_name : each.value.name
  type = "TXT"
  rrdatas = lookup(each.value, "rrdatas")
  routing_policy {
    dynamic geo{
      for_each = lookup(each.value, "geo", [])
      content {
        location = geo.value.location
        rrdatas  = geo.value.rrdatas
      }
    }
    dynamic wwr {
      for_each = lookup(each.value, "wwr", [])
      content {
        weight = wwr.value.weight
        rrdatas = wwr.value.rrdatas
      }
    }
  }
}

