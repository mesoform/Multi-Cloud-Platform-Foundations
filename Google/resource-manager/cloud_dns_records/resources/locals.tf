locals {
  records = {for type, set in var.records: type => {for item in set: item.name => item}}
}