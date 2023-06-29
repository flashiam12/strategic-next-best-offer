data "aws_region" "current" {}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-focal-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_security_group_rule" "service_ssh_in_1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [module.ops-vpc.vpc_cidr_block]
  security_group_id = module.ops-vpc.default_security_group_id
  description       = "bastion service access"
}

resource "aws_security_group_rule" "service_ssh_external_1" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ops-vpc.default_security_group_id
  description       = "bastion service access"
}

resource "aws_security_group_rule" "service_http_external_1" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ops-vpc.default_security_group_id
  description       = "bastion service access"
}

resource "aws_security_group_rule" "service_http_external_egress_1" {
  type              = "egress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ops-vpc.default_security_group_id
  description       = "bastion service access"
}

resource "aws_security_group_rule" "service_https_external_egress_1" {
  type              = "egress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ops-vpc.default_security_group_id
  description       = "bastion service access"
}

resource "aws_security_group_rule" "service_kafka_external_egress_1" {
  type              = "egress"
  from_port         = 9092
  to_port           = 9092
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.ops-vpc.default_security_group_id
  description       = "bastion service access"
}

module "bastion_host" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  name = "hsbc-ops-bastion"

  ami                    = "ami-0fcf52bcf5db7b003"
  instance_type          = "t3.large"
  key_name               = "vibin_checkride"
  monitoring             = true
  vpc_security_group_ids = [module.ops-vpc.default_security_group_id]
  subnet_id              = module.ops-vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "ops"
    Owner = "Shiv"
  }
}

data "aws_lb" "cp-ingress" {
  name = "cp-ingress"
  depends_on = [ 
    kubectl_manifest.cp-controlcenter-ingress,
    kubectl_manifest.cp-ksql-ingress,
    kubectl_manifest.cp-sr-ingress,
    kubectl_manifest.cp-connect-ingress
   ]
}

data "aws_lb" "cp-ksqldb-bootstrap"{
  tags = {
    "service.k8s.aws/stack" = "confluent/ksqldb-clone-bootstrap-lb"
  }
  depends_on = [ 
    kubectl_manifest.cp-ksql-clone
  ]
}

data "aws_lb" "cp-kafka-1" {
  tags = {
    "service.k8s.aws/stack" = "confluent/kafka-1-lb"
  }
  depends_on = [ 
    kubectl_manifest.cp-cluster
   ]
}

data "aws_lb" "cp-kafka-0" {
  tags = {
    "service.k8s.aws/stack" = "confluent/kafka-0-lb"
  }
  depends_on = [ 
    kubectl_manifest.cp-cluster
   ]
}

data "aws_lb" "cp-kafka-2" {
  tags = {
    "service.k8s.aws/stack" = "confluent/kafka-2-lb"
  }
  depends_on = [ 
    kubectl_manifest.cp-cluster
   ]
}

data "aws_lb" "cp-kafka-bootstrap" {
  tags = {
    "service.k8s.aws/stack" = "confluent/kafka-bootstrap-lb"
  }
  depends_on = [ 
    kubectl_manifest.cp-cluster
   ]
}

