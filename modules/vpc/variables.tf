variable "env_name" {
  type = string
}
variable "sys_name" {
  type = string
}

variable "aws_account_id" {
  type = string
}

# VPC 
variable "vpc_cidr" {
  type = string
}

variable "public_subnet_config" {
  type = map(any)
}

variable "private_subnet_config" {
  type = map(any)
}

variable "system_logs_bucket_arn" {
  type = string
}

