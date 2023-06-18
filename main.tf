module "cc" {
  source = "./cc"
  env_name = var.confluent_env_name
  confluent_api_key = var.confluent_cloud_api_key
  confluent_api_secret = var.confluent_cloud_api_secret
  aws_cc_cluster_region = var.aws_region
  gcp_cc_cluster_region = var.gcp_region
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
}