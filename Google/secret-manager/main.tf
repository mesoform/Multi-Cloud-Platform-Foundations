data google_project self {
  project_id = var.project_id == null ? local.secrets.project_id : var.project_id
}

resource google_secret_manager_secret self {
  for_each        = local.secrets_specs
  project         = data.google_project.self.project_id
  secret_id       = lookup(each.value, "secret_id", each.key)
  labels          = local.secrets_labels[each.key]
  annotations     = local.secrets_annotations[each.key]
  version_aliases = lookup(each.value, "version_aliases", {})
  expire_time     = lookup(each.value, "expire_time", null)
  ttl             = lookup(each.value, "ttl", null)
  version_destroy_ttl = lookup(each.value, "ttl", null)
  replication {
    dynamic auto {
      for_each = lookup(each.value, "user_managed_replicas", false) == false ? true : null
      content {
        dynamic customer_managed_encryption {
          for_each = lookup(each.value, "kms_key_name", null) == null ? {} : {
            kms_key_name = each.value.kms_key_name
          }
          content {
            kms_key_name = customer_managed_encryption.value
          }
        }
      }
    }
    dynamic user_managed {
      for_each = lookup(each.value, "user_managed_replicas", null) == null ? {} : { user_managed_replicas = toset(each.value.user_managed_replicas) }
      content {
        dynamic replicas {
          for_each = user_managed.value
          content {
            location = replicas.value.location
            dynamic customer_managed_encryption {
              for_each = lookup(replicas.value, "kms_key_name", null) == null ? {} : {
                kms_key_name = replicas.value.kms_key_name
              }
              content {
                kms_key_name = customer_managed_encryption.value
              }
            }
          }
        }
      }
    }
  }
  dynamic topics {
    for_each = lookup(each.value, "topics", null) == null ? toset([]) : toset(each.value.topics)
    content {
      name = topics.value
    }
  }
  dynamic rotation {
    for_each = lookup(each.value, "rotation", null) == null ? {} : { rotation = each.value.rotation }
    content {
      next_rotation_time = lookup(rotation.value, "next_rotation_time", null)
      rotation_period    = lookup(rotation.value, "rotation_period", null)
    }
  }
}

data google_iam_policy self {
  for_each = local.secrets_iam
  dynamic binding {
    for_each = each.value
    content {
      role    = lookup(binding.value, "role", null)
      members = lookup(binding.value, "members", null)
      //noinspection HILUnresolvedReference
      dynamic "condition" {
        for_each = length(lookup(binding.value, "condition", {})) == 0 ? {} : { condition : binding.value.condition }
        content {
          title       = lookup(condition.value, "title", null)
          description = lookup(condition.value, "description", null)
          expression  = lookup(condition.value, "expression", null)
        }
      }
    }
  }
}


resource google_secret_manager_secret_iam_policy policy {
  for_each    = local.secrets_iam
  project     = google_secret_manager_secret.self[each.key].project
  secret_id   = google_secret_manager_secret.self[each.key].secret_id
  policy_data = data.google_iam_policy.self[each.key].policy_data
}