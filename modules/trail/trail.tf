resource "aws_cloudwatch_log_group" "trail_log_group" {
  name = "${var.sys_name}-${var.env_name}-trail"
}

resource "aws_cloudtrail" "trail" {
  name                          = "${var.sys_name}-${var.env_name}-trail"
  s3_bucket_name                = var.system_logs_bucket
  s3_key_prefix                 = "trail"
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.trail_log_group.arn}:*"
  cloud_watch_logs_role_arn  = var.cloudtrail_iam_role

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3"]
    }
  }
  depends_on = [aws_cloudwatch_log_group.trail_log_group]
}
