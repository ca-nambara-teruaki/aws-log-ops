variable "env_name" {
  type    = string
  default = "dev"
}

variable "sys_name" {
  type    = string
  default = "cmn"
}

data "aws_caller_identity" "current" {}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_config" {
  type = map(any)
  default = {
    az-a = { az = "ap-northeast-1a", cidr = "10.10.10.0/24" },
    az-c = { az = "ap-northeast-1c", cidr = "10.10.20.0/24" }
  }
}

variable "private_subnet_config" {
  type = map(any)
  default = {
    az-a = { az = "ap-northeast-1a", cidr = "10.10.30.0/24" },
    az-c = { az = "ap-northeast-1c", cidr = "10.10.40.0/24" }
  }
}
