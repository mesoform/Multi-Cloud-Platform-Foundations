data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    sid = 1
    actions = [
      "sts:AssumeRole",
      ]
    effect    = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data aws_iam_policy_document ec2_access_to_objects_role_policy {
  statement {
    actions   = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:s3:::${var.bucket_name}/*",
    ]
  }
}

data aws_iam_policy_document ec2_access_to_buckets_role_policy {
  statement {
    actions   = [
      "s3:ListBucket",
      "s3:ListAllMyBuckets"
    ]
    effect    = "Allow"
    resources = [
      "arn:aws:s3:::*",
    ]
  }
}