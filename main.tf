module "cc" {
  source = "./cc"
  env_name = var.confluent_env_name
  confluent_api_key = var.confluent_cloud_api_key
  confluent_api_secret = var.confluent_cloud_api_secret
  aws_cc_cluster_region = var.aws_region
  gcp_cc_cluster_region = var.gcp_region
  aws_api_key = var.aws_api_key
  aws_api_secret = var.aws_secret_key
  aws_kinesis_stream = module.external.aws_kinesis_stream_name
  aws_kinesis_stream_region = var.aws_region
  aws_s3_bucket = module.external.aws_s3_bucket_name
  gcp_project_id = var.gcp_project_id
  gcp_region = var.gcp_region
  gcp_zone = var.gcp_zone
  gcp_credentials = var.gcp_cred_path
  gcp_service_account_email = var.gcp_sa_email
  gcp_pub_sub_topic_id = module.external.gcp_pub_sub_topic_id
  gcp_pub_sub_sub_id = module.external.gcp_pub_sub_sub_id
  gcp_bigtable_dataset = module.external.gcp_bigtable_dataset
}

module "cp" {
  source = "./cp"
  aws_api_key = var.aws_api_key
  aws_api_secret = var.aws_secret_key
  aws_region = var.aws_region
}

module "external" {
  source = "./external"
  aws_api_key = var.aws_api_key
  aws_api_secret = var.aws_secret_key
  aws_region = var.aws_region
  aws_ops_vpc_id = module.cp.aws_ops_vpc_id
  gcp_project_id = var.gcp_project_id
  gcp_region = var.gcp_region
  gcp_zone = var.gcp_zone
  gcp_credentials = var.gcp_cred_path
  gcp_service_account_email = var.gcp_sa_email
}

module "devops" {
  source = "./devops"
  aws_eks_cluster_name = module.cp.aws_ops_eks_cluster_name
  aws_eks_node_group_arn = module.cp.aws_ops_eks_node_group_role_arn
  aws_region = var.aws_region
  aws_api_key = var.aws_api_key
  aws_api_secret = var.aws_secret_key
  aws_trigger_ci = false
  aws_rds_db_name = module.external.aws_rds_db_name
  aws_rds_db_pass = module.external.aws_rds_db_password
  aws_rds_db_uri = module.external.aws_rds_db_address
  aws_rds_db_user = module.external.aws_rds_db_username
  gcp_credentials_path = "secrets/service-account.json"
  confluent_kafka_api_key = module.cc.aws_cc_api_key
  confluent_kafka_api_secret = module.cc.aws_cc_api_secret
  confluent_sr_api_key = module.cc.confluent_sr_api_key
  confluent_sr_api_secret = module.cc.confluent_sr_api_secret
}

module "dashboard" {
  source = "./dashboard"
  aws_api_key = var.aws_api_key
  aws_api_secret = var.aws_secret_key
  aws_eks_cluster_name = module.cp.aws_ops_eks_cluster_name
  aws_region = var.aws_region
  aws_acm_arn = module.cp.aws_acm_cert_arn
  aws_public_subnet = module.cp.aws_public_subnet
}


module "vpc-peering_example_single-account-single-region-with-options" {
  source  = "grem11n/vpc-peering/aws"
  version = "6.0.0"
  
  providers = {
    aws.this = aws
    aws.peer = aws
  }
  
  this_vpc_id = module.cp.aws_ops_vpc_id
  peer_vpc_id = module.external.aws_db_vpc_id

  auto_accept_peering = true

  // Peering options for requester
  this_dns_resolution        = true

  // Peering options for accepter
  peer_dns_resolution        = true

  tags = {
    Name        = "ops-eks-db-vpc-peering"
    Environment = "ops"
    Kind        = "strategic"
    Terraform   = "True"
  }
}