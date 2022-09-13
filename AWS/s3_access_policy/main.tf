resource "aws_iam_instance_profile" "self" {
  name = "access_profile"
  role = aws_iam_role.ec2_s3_access_role.name
}

resource aws_iam_role ec2_s3_access_role {
  name                = "ec2_s3_access_role"
  assume_role_policy  = data.aws_iam_policy_document.ec2_assume_role_policy.json
  managed_policy_arns = [
    aws_iam_policy.ec2_access_to_objects_role_policy.arn,
    aws_iam_policy.ec2_access_to_buckets_role_policy.arn,
  ]
}



