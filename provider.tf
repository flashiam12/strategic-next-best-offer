terraform {
  required_providers {
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 4.0"
    # }
    confluent = {
      source = "confluentinc/confluent"
      version = "1.43.0"
    }
    # google = {
    #   source = "hashicorp/google"
    #   version = "4.69.1"
    # }
    # restapi = {
    #   source = "Mastercard/restapi"
    #   version = "1.18.0"
    # }
  }
}

# provider "aws" {
#   region = var.aws_region
#   access_key = var.aws_access_key
#   secret_key = var.aws_secret_key
# }

# provider "google" {
#   project     = var.gcp_project_id
#   region      = var.gcp_region
#   credentials = var.gcp_service_account_file
# }

provider "confluent" {
  cloud_api_key       = var.confluent_cloud_api_key   
  cloud_api_secret    = var.confluent_cloud_api_secret
}