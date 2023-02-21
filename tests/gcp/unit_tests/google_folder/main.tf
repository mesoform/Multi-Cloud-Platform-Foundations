data external test_folder_parent_id {
  query   = {parent_id = local.folders_components_common.parent_id}
  program = ["python", "${path.module}/test_folder_parent_id.py"]
}
output folder_parent_id {
  value = data.external.test_folder_parent_id.result
}

data external test_essential_contacts{
  query = {
    for project, essential_contacts in local.folders_essential_contacts: project => keys(lookup(essential_contacts, "contacts", {}))[0]
  }
  program = ["python", "${path.module}/test_essential_contacts.py"]
}

output test_essential_contacts {
  value = data.external.test_essential_contacts.result
}