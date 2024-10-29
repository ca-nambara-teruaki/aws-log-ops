# iam_policy
resource "aws_iam_policy" "redshift-threat-detection" {
  name   = "${var.env_name}-${var.sys_name}-redshift-threat-detection"
  policy = file("${path.module}/policies/iam-policy-redshift-threat-detection.json")
}

# iam role
resource "aws_iam_role" "redshift-threat-detection" {
  name = "${var.env_name}-${var.sys_name}-redshift-threat-detection"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift-threat-detection" {
  role       = aws_iam_role.redshift-threat-detection.name
  policy_arn = aws_iam_policy.redshift-threat-detection.arn
}
