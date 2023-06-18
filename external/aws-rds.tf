locals {
  db_name    = "hsbc-ops-db"
  region  = data.aws_region.current.name

  tags = {
    Name        = local.db_name
    Kind        = "Strategic"
    Terraform   = "True"
    Environment = "Ops"
  }
}

data "aws_caller_identity" "current" {}



################################################################################
# RDS Module
################################################################################

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "5.6.0"

  identifier = local.db_name

  # All available versions: https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html#PostgreSQL.Concepts
  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14" # DB parameter group
  major_engine_version = "14"         # DB option group
  instance_class       = "db.t3.small"

  allocated_storage     = 20
  max_allocated_storage = 100

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  db_name  = "hsbcOpsDB"
  username = "opsAdmin"
  port     = 5432

  multi_az                = true
  db_subnet_group_name    = module.db-ops-vpc.database_subnet_group_name
  # subnet_ids              = 
  vpc_security_group_ids  = [module.db_security_group.security_group_id]

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "hsbc-ops-db"
  monitoring_role_use_name_prefix       = true
  monitoring_role_description           = "Description for monitoring role"
  parameter_group_name                  = "cdc-settings"

  tags = local.tags
  db_option_group_tags = {
    "Sensitive" = "low"
  }
  db_parameter_group_tags = {
    "Sensitive" = "low"
  }
}

module "kms" {
  source      = "terraform-aws-modules/kms/aws"
  version     = "~> 1.0"
  description = "KMS key for cross region automated backups replication"

  # Aliases
  aliases                 = [local.db_name]
  aliases_use_name_prefix = true

  key_owners = [data.aws_caller_identity.current.arn]

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "db_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.db_name
  description = "RDS Default security group"
  vpc_id      = module.db-ops-vpc.vpc_id
  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = data.aws_vpc.default.cidr_block
    }
  ]

  tags = local.tags
}