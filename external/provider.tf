terraform {
  required_providers {
    # aws = {
    #   source  = "hashicorp/aws"
    #   version = "~> 4.0"
    # }
  }
}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_api_key
  secret_key = var.aws_api_secret
}

provider "google" {
  project     = var.gcp_project_id
  region      = var.gcp_region
  zone        = var.gcp_zone
  credentials = file(var.gcp_credentials)
}