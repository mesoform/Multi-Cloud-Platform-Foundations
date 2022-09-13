resource "aws_iam_policy" "ec2_access_to_objects_role_policy" {
  name = "ec2_access_to_objects"
  policy = data.aws_iam_policy_document.ec2_access_to_objects_role_policy.json
}

resource "aws_iam_policy" "ec2_access_to_buckets_role_policy" {
  name = "ec2_access_to_buckets"
  policy = data.aws_iam_policy_document.ec2_access_to_buckets_role_policy.json
}
