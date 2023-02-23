resource google_essential_contacts_contact self {
  for_each = var.essential_contacts
  parent = var.parent_id
  email = each.key
  language_tag = var.language_tag
  notification_category_subscriptions = each.value
}