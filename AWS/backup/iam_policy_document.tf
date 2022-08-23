data "aws_iam_policy_document" "backup_assume_role" {
  policy_id = "EC2AssumeRole"
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    effect    = "Allow"
    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}