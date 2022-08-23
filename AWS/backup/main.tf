resource "aws_backup_vault" "self" {
  name        = "${var.environment}_backup_vault"
}

resource "aws_backup_plan" "self" {
  name = "${var.environment}_backup_plan"
  rule {
    rule_name         = "${var.environment}_backup_rule"
    target_vault_name = aws_backup_vault.self.name
    schedule          = var.schedule
    lifecycle {
      delete_after = var.lifecycle_delete_after
    }
  }
}

resource "aws_backup_selection" "self" {
  iam_role_arn = aws_iam_role.self.arn
  name         = "${var.environment}_backup_selection"
  plan_id      = aws_backup_plan.self.id

  resources = var.resources
}

resource "aws_iam_role" "self" {
  name               = "${var.environment}_backup_role"
  assume_role_policy = data.aws_iam_policy_document.backup_assume_role.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup",
    "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
  ]
}