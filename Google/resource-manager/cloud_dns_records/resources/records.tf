data google_dns_managed_zone zone {
  name = var.managed_zone
  project = var.project_id
}
resource google_dns_record_set A_records {
  for_each = lookup(var.records, "A_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "A"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set AAAA_records {
  for_each = lookup(var.records, "AAAA_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "AAAA"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set ALIAS_records {
  for_each = lookup(var.records, "ALIAS_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "ALIAS"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set CAA_records {
  for_each = lookup(var.records, "CAA_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "CAA"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set CNAME_records {
  for_each = lookup(var.records, "CNAME_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "CNAME"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set DNSKEY_records {
  for_each = lookup(var.records, "DNSKEY_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "DNSKEY"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set DS_records {
  for_each = lookup(var.records, "DS_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "DS"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set HTTPS_records {
  for_each = lookup(var.records, "HTTPS_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "HTTPS"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set IPSECKEY_records {
  for_each = lookup(var.records, "IPSECKEY_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "IPSECKEY"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set MX_records {
  for_each = lookup(var.records, "MX_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "MX"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set NAPTR_records {
  for_each = lookup(var.records, "NAPTR_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "NAPTR"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set PTR_records {
  for_each = lookup(var.records, "PTR_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "PTR"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set SOA_records {
  for_each = lookup(var.records, "SOA_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "SOA"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set SPF_records {
  for_each = lookup(var.records, "SPF_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "SPF"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set SRV_records {
  for_each = lookup(var.records, "SRV_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "SRV"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set SSHFP_records {
  for_each = lookup(var.records, "SSHFP_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "SSHFP"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set SVCB_records {
  for_each = lookup(var.records, "SVCB_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "SVCB"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set TLSA_records {
  for_each = lookup(var.records, "TLSA_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "TLSA"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

resource google_dns_record_set TXT_records {
  for_each = lookup(var.records, "TXT_records", {})
  managed_zone = var.managed_zone
  name = endswith(each.key, ".") ? each.key : "${each.key}.${data.google_dns_managed_zone.zone.dns_name}"
  type = "TXT"
  rrdatas = each.value.rrdatas 
  ttl = each.value.ttl == null ? var.ttl : each.value.ttl
  project =each.value.project_id == null ? var.project_id: each.value.project_id
  dynamic routing_policy {
    for_each = each.value.rrdatas == null? { routing_policy = each.value.routing_policy } : {}
    content {
      //noinspection HILUnresolvedReference
      dynamic geo{
        for_each = routing_policy.value.geo == [] ? {} :  { for geo in routing_policy.value.geo : geo.location => geo} 
        //noinspection HILUnresolvedReference
        content {
          location = geo.value.location
          rrdatas  = geo.value.rrdatas
        }
      }
      //noinspection HILUnresolvedReference
      dynamic wrr {
        for_each = routing_policy.value.wrr == [] ? {} :  { for wrr in routing_policy.value.wrr : wrr.weight => wrr} 
        //noinspection HILUnresolvedReference
        content {
          weight = wrr.value.weight
          rrdatas = wrr.value.rrdatas
        }
      }
    }
  }
}

