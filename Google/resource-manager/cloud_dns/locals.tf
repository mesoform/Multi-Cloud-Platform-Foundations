locals {
  cloud_dns_yml = fileexists(var.cloud_dns_yml) ? file(var.cloud_dns_yml) : null
  cloud_dns = try(yamldecode(local.cloud_dns_yml), {})
  cloud_dns_components        = lookup(local.cloud_dns, "components", {})
  cloud_dns_components_specs  = lookup(local.cloud_dns_components, "specs", {})
  cloud_dns_components_common = lookup(local.cloud_dns_components, "common", {})

  cloud_dns_specs = {
    for folder, config in local.cloud_dns_components_specs :
      folder => merge(local.cloud_dns_components_common, config)
  }

  a_records =
}