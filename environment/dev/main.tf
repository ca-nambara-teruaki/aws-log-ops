module "iam" {
  source         = "../../modules/iam"
  env_name       = var.env_name
  sys_name       = var.sys_name
  aws_account_id = data.aws_caller_identity.current.account_id
}

module "s3" {
  source         = "../../modules/s3"
  env_name       = var.env_name
  sys_name       = var.sys_name
  aws_account_id = data.aws_caller_identity.current.account_id
}

module "vpc" {
  source                 = "../../modules/vpc"
  env_name               = var.env_name
  sys_name               = var.sys_name
  aws_account_id         = data.aws_caller_identity.current.account_id
  vpc_cidr               = var.vpc_cidr
  public_subnet_config   = var.public_subnet_config
  private_subnet_config  = var.private_subnet_config
  system_logs_bucket_arn = module.s3.system_logs_bucket.arn
}

module "config" {
  source             = "../../modules/config"
  env_name           = var.env_name
  sys_name           = var.sys_name
  system_logs_bucket = module.s3.system_logs_bucket.bucket
  depends_on         = [module.s3]
}

module "trail" {
  source              = "../../modules/trail"
  env_name            = var.env_name
  sys_name            = var.sys_name
  aws_account_id      = data.aws_caller_identity.current.account_id
  cloudtrail_iam_role = module.iam.trail_role.arn
  system_logs_bucket  = module.s3.system_logs_bucket.bucket
  depends_on          = [module.iam, module.s3]
}
