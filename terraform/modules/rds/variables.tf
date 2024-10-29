variable "env_name" {
  type = string
}
variable "sys_name" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "system_logs_bucket_arn" {
  type = string
}

variable "rds_cluster_id" {
  type = string
}

variable "logs_to_firehose_iam_role_arn" {
  type = string
}

variable "firehose_to_s3_iam_role_arn" {
  type = string
}
