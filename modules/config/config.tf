resource "aws_iam_service_linked_role" "config-service" {
  aws_service_name = "config.amazonaws.com"
}

resource "aws_config_configuration_recorder" "config" {
  name     = "${var.env_name}-${var.sys_name}-config"
  role_arn = aws_iam_service_linked_role.config-service.arn

  recording_group {
    all_supported                 = false
    include_global_resource_types = false
    resource_types = [
      "AWS::CloudTrail::Trail",
      "AWS::EC2::RouteTable",
      "AWS::EC2::SecurityGroup",
      "AWS::EC2::Subnet",
      "AWS::EC2::VPC",
      "AWS::EC2::VPCEndpoint",
      "AWS::IAM::Group",
      "AWS::IAM::Policy",
      "AWS::IAM::Role",
      "AWS::IAM::User",
      "AWS::Redshift::Cluster",
      "AWS::Redshift::ClusterSecurityGroup",
      "AWS::Redshift::ClusterSubnetGroup",
      "AWS::S3::Bucket",
      "AWS::S3::AccountPublicAccessBlock",
      "AWS::SageMaker::Domain"
    ]
  }

  recording_mode {
    recording_frequency = "CONTINUOUS"
  }
}

resource "aws_config_configuration_recorder_status" "config" {
  name       = aws_config_configuration_recorder.config.name
  is_enabled = true
  depends_on = [aws_config_configuration_recorder.config]
}

resource "aws_config_delivery_channel" "config" {
  name           = "default"
  s3_bucket_name = var.system_logs_bucket
  s3_key_prefix  = "Config"
  depends_on     = [aws_config_configuration_recorder.config]
}
