# log groups
resource "aws_cloudwatch_log_group" "rds_log_group_error" {
  name              = "/aws/rds/cluster/${local.local.rds_cluster_name}/error"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "rds_log_group_audit" {
  name              = "/aws/rds/cluster/${local.local.rds_cluster_name}/audit"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "rds_log_group_slowquery" {
  name              = "/aws/rds/cluster/${local.local.rds_cluster_name}/slowquery"
  retention_in_days = 7
}

# subscription filter
resource "aws_cloudwatch_log_subscription_filter" "rds_logs_subscription_error" {
  name            = "${var.env_name}-${var.sys_name}-rds-logs-subscription-error"
  log_group_name  = aws_cloudwatch_log_group.rds_log_group_error.name
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.rds_logs_stream_error.arn
  role_arn        = var.logs_to_firehose_iam_role_arn
}

resource "aws_cloudwatch_log_subscription_filter" "rds_logs_subscription_audit" {
  name            = "${var.env_name}-${var.sys_name}-rds-logs-subscription-audit"
  log_group_name  = aws_cloudwatch_log_group.rds_log_group_audit.name
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.rds_logs_stream_audit.arn
  role_arn        = var.logs_to_firehose_iam_role_arn
}

resource "aws_cloudwatch_log_subscription_filter" "rds_logs_subscription_slowquery" {
  name            = "${var.env_name}-${var.sys_name}-rds-logs-subscription-slowquery"
  log_group_name  = aws_cloudwatch_log_group.rds_log_group_slowquery.name
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.rds_logs_stream_slowquery.arn
  role_arn        = var.logs_to_firehose_iam_role_arn
}

# kinesis firehose
resource "aws_kinesis_firehose_delivery_stream" "rds_logs_stream_error" {
  name        = "${var.env_name}-${var.sys_name}-rds-logs-stream-error"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = var.firehose_to_s3_iam_role_arn
    bucket_arn         = var.system_logs_bucket_arn
    buffering_size     = 128
    buffering_interval = 300

    prefix              = "${var.env_name}/RDS/${local.rds_cluster_id}/error/dt=!{timestamp:yyyy}-!{timestamp:MM}-!{timestamp:dd}/"
    error_output_prefix = "${var.env_name}/RDS/${local.rds_cluster_id}/error_error"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "rds_logs_stream_audit" {
  name        = "${var.env_name}-${var.sys_name}-rds-logs-stream-audit"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = var.firehose_to_s3_iam_role_arn
    bucket_arn         = var.system_logs_bucket_arn
    buffering_size     = 128
    buffering_interval = 300

    prefix              = "${var.env_name}/RDS/${local.rds_cluster_id}/audit/dt=!{timestamp:yyyy}-!{timestamp:MM}-!{timestamp:dd}/"
    error_output_prefix = "${var.env_name}/RDS/${local.rds_cluster_id}/audit_error"
  }
}

resource "aws_kinesis_firehose_delivery_stream" "rds_logs_stream_slowquery" {
  name        = "${var.env_name}-${var.sys_name}-rds-logs-stream-slowquery"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn           = var.firehose_to_s3_iam_role_arn
    bucket_arn         = var.system_logs_bucket_arn
    buffering_size     = 128
    buffering_interval = 300

    prefix              = "${var.env_name}/RDS/${local.rds_cluster_id}/slowquery/dt=!{timestamp:yyyy}-!{timestamp:MM}-!{timestamp:dd}/"
    error_output_prefix = "${var.env_name}/RDS/${local.rds_cluster_id}/slowquery_error"
  }
}
