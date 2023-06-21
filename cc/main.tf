module "aws-cc" {
  source = "./cc-aws"
  confluent_cloud_api_key  = var.confluent_api_key
  confluent_cloud_api_secret = var.confluent_api_secret
  confluent_cloud_env_id = confluent_environment.default.id
  confluent_cloud_schema_registry_id = confluent_schema_registry_cluster.essentials.id
  aws_cc_cluster_region = var.aws_cc_cluster_region
  aws_api_key = var.aws_api_key
  aws_api_secret = var.aws_api_secret
  aws_kinesis_stream = var.aws_kinesis_stream
  aws_kinesis_stream_region = var.aws_kinesis_stream_region
  aws_s3_bucket = var.aws_s3_bucket
  aws_create_cc_connectors = true
}

data "confluent_kafka_cluster" "aws-cc-cluster" {
  id = module.aws-cc.aws_cc_cluster
  environment {
    id = confluent_environment.default.id
  }
}

module "gcp-cc" {
  source = "./cc-gcp"
  confluent_cloud_api_key  = var.confluent_api_key
  confluent_cloud_api_secret = var.confluent_api_secret
  confluent_cloud_env_id = confluent_environment.default.id
  confluent_cloud_schema_registry_id = confluent_schema_registry_cluster.essentials.id
  gcp_cc_cluster_region = var.gcp_cc_cluster_region
  gcp_project_id = var.gcp_project_id
  gcp_region = var.gcp_region
  gcp_zone = var.gcp_zone
  gcp_credentials = var.gcp_credentials
  gcp_service_account_email = var.gcp_service_account_email
  gcp_pub_sub_topic_id = var.gcp_pub_sub_topic_id
  gcp_pub_sub_sub_id = var.gcp_pub_sub_sub_id
  gcp_bigtable_dataset = var.gcp_bigtable_dataset
  gcp_cc_bq_sink_topic = "cp-enriched-customer-behaviour"
  gcp_create_cc_connectors = true
}

data "confluent_kafka_cluster" "gcp-cc-cluster" {
  id = module.gcp-cc.gcp_cc_cluster
  environment {
    id = confluent_environment.default.id
  }
}

locals {
  aws_cc_api_key = module.aws-cc.aws_cc_admin_api_key
  aws_cc_api_secret = module.aws-cc.aws_cc_admin_api_secret
  gcp_cc_api_key = module.gcp-cc.gcp_cc_admin_api_key
  gcp_cc_api_secret = module.gcp-cc.gcp_cc_admin_api_secret
}

resource "confluent_cluster_link" "aws-gcp-cc-link" {
  link_name = "aws_to_gcp_cc_cluster_link"
  source_kafka_cluster {
    id                 = data.confluent_kafka_cluster.aws-cc-cluster.id
    bootstrap_endpoint = data.confluent_kafka_cluster.aws-cc-cluster.bootstrap_endpoint
    credentials {
      key    = local.aws_cc_api_key
      secret = local.aws_cc_api_secret
    }
  }

  destination_kafka_cluster {
    id            = data.confluent_kafka_cluster.gcp-cc-cluster.id 
    rest_endpoint = data.confluent_kafka_cluster.gcp-cc-cluster.rest_endpoint
    credentials {
      key    = local.gcp_cc_api_key
      secret = local.gcp_cc_api_secret
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_cluster_link" "gcp-aws-cc-link" {
  link_name = "gcp_to_aws_cc_cluster_link"
  source_kafka_cluster {
    id                 = data.confluent_kafka_cluster.gcp-cc-cluster.id 
    bootstrap_endpoint = data.confluent_kafka_cluster.gcp-cc-cluster.bootstrap_endpoint
    credentials {
      key    = local.gcp_cc_api_key
      secret = local.gcp_cc_api_secret
    }
  }

  destination_kafka_cluster {
    id            = data.confluent_kafka_cluster.aws-cc-cluster.id
    rest_endpoint = data.confluent_kafka_cluster.aws-cc-cluster.rest_endpoint
    credentials {
      key    = local.aws_cc_api_key
      secret = local.aws_cc_api_secret
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}
