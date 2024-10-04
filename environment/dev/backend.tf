# terraform {
#   backend "s3" {
#     bucket = "terraform-state-${data.aws_caller_identity.current.account_id}"
#     key    = "aws-ops/${var.env_name}/terraform.tfstate"
#     region = "ap-northeast-1"
#   }
# }
