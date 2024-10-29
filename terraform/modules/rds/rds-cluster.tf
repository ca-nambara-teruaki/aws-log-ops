locals {
  rds_cluster_id = "${var.env_name}-${var.sys_name}-rds"
}

# cluster
resource "aws_rds_cluster" "cluster" {
  cluster_identifier = local.rds_cluster_id
  engine_mode        = "provisioned"
  engine             = "aurora-mysql"
  engine_version     = "8.0.mysql_aurora.3.05.2"
  database_name      = var.rds.database_name

  ## general configurations
  master_username                     = "admin"
  manage_master_user_password         = true
  db_subnet_group_name                = aws_db_subnet_group.db_subnet_group.id
  db_cluster_parameter_group_name     = aws_rds_cluster_parameter_group.cluster_parameter.name
  db_instance_parameter_group_name    = aws_db_parameter_group.db_parameter.name
  vpc_security_group_ids              = var.rds.vpc_security_group_ids
  iam_roles                           = [aws_iam_role.rds_role.arn]
  iam_database_authentication_enabled = true

  serverlessv2_scaling_configuration {
    max_capacity = var.rds.max_capacity
    min_capacity = var.rds.min_capacity
  }

  ## configurations for operation purpose
  preferred_backup_window      = "16:00-17:00"
  preferred_maintenance_window = "sun:17:30-sun:18:30"
  backup_retention_period      = var.rds.backup_retention_period
  final_snapshot_identifier    = "${var.env_name}-${var.sys_name}-snapshot"
  skip_final_snapshot          = true

  ## configurations for security purpose
  allow_major_version_upgrade     = false
  storage_encrypted               = true
  enabled_cloudwatch_logs_exports = ["audit", "error", "slowquery"]

  tags = {
    Environment = var.env_name
  }
  depends_on = [
    aws_cloudwatch_log_group.rds_log_group_error,
    aws_cloudwatch_log_group.rds_log_group_audit,
    aws_cloudwatch_log_group.rds_log_group_slowquery
  ]
}

resource "aws_rds_cluster_instance" "instance" {
  count                        = var.rds.instance_count
  cluster_identifier           = aws_rds_cluster.cluster.id
  identifier_prefix            = "${var.env_name}-${var.sys_name}-${count.index}-"
  instance_class               = "db.serverless"
  engine                       = aws_rds_cluster.cluster.engine
  engine_version               = aws_rds_cluster.cluster.engine_version
  auto_minor_version_upgrade   = false
  db_subnet_group_name         = aws_db_subnet_group.db_subnet_group.id
  db_parameter_group_name      = aws_db_parameter_group.db_parameter.name
  publicly_accessible          = false
  performance_insights_enabled = var.rds.performance_insights
  monitoring_role_arn          = var.rds.enhanced_monitoring ? aws_iam_role.rds_role.arn : ""
  monitoring_interval          = var.rds.enhanced_monitoring ? 10 : 0
  ca_cert_identifier           = "rds-ca-rsa2048-g1"

  tags = {
    Environment = var.env_name
  }
}
