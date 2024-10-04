# S3 Buckets

resource "aws_s3_bucket" "system_logs" {
  bucket              = "${var.aws_account_id}-${var.env_name}-${var.sys_name}-system-logs"
  object_lock_enabled = true

  force_destroy = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "server_access_logs" {
  bucket = aws_s3_bucket.system_logs.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256" // SSE-S3
    }
  }
}

resource "aws_s3_bucket_public_access_block" "system_logs_conf" {
  bucket                  = aws_s3_bucket.system_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "system_logs_policy" {
  bucket = aws_s3_bucket.system_logs.id
  policy = templatefile("${path.module}/policies/policy.json", {
    bucket_arn = aws_s3_bucket.system_logs.arn,
    account_id = var.aws_account_id
  })
}


output "system_logs_bucket" {
  value = aws_s3_bucket.system_logs
}
