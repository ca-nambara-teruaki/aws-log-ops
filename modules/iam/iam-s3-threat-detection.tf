# iam_policy
resource "aws_iam_policy" "s3-threat-detection" {
  name   = "${var.env_name}-${var.sys_name}-s3-threat-detection"
  policy = file("${path.module}/policies/iam-policy-s3-threat-detection.json")
}

# iam role
resource "aws_iam_role" "s3-threat-detection" {
  name = "${var.env_name}-${var.sys_name}-s3-threat-detection"

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

resource "aws_iam_role_policy_attachment" "s3-threat-detection" {
  role       = aws_iam_role.s3-threat-detection.name
  policy_arn = aws_iam_policy.s3-threat-detection.arn
}
