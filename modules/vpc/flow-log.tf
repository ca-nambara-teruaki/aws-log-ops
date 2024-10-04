resource "aws_flow_log" "vpc_flow_logs" {
  log_destination      = "${var.system_logs_bucket_arn}/VpcFlowLogs/${aws_vpc.vpc.id}/"
  log_destination_type = "s3"
  traffic_type         = "ALL"
  vpc_id               = aws_vpc.vpc.id

  destination_options {
    file_format                = "parquet"
    hive_compatible_partitions = false
  }
}
