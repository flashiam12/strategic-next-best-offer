data "aws_vpc" "default" {
  id = var.aws_ops_vpc_id
}

data "aws_region" "current" {}