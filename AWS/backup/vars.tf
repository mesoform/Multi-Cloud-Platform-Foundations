variable "region" {
  default = "us-east-1"
}

variable "environment" {
    description = "Resources name prefix"
    default = "dev"
}
variable "schedule" {
    description = "Backup schedule in cron format"
    default = "cron(0 0/2 * * ? *)"
}
variable "lifecycle_delete_after" {
    description = "Number of days after creation that a recovery point is deleted"
    default = 14
}
variable "resources" {
    description = "ARN of resources to be backuped"
    default = [
         "arn:aws:s3:::db-input",
         "arn:aws:rds:us-east-1:087315625315:db:docdb-2022-08-22-22-34-38"
    ]
}