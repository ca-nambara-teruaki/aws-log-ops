resource "aws_glue_catalog_database" "logs" {
  name = "${var.env_name}_${var.sys_name}_logs"
}
