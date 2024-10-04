output "trail_role" {
  value = aws_iam_role.trail
}

output "redshift_threat_detection_role" {
  value = aws_iam_role.redshift-threat-detection
}

output "s3_threat_detection_role" {
  value = aws_iam_role.s3-threat-detection
}
