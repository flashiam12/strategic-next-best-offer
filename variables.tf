variable "confluent_env_name" {
  type = string
  default = "next-big-offer"
}

variable "confluent_cloud_api_key" {
  type = string
}

variable "confluent_cloud_api_secret" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "aws_api_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

# variable "gcp_service_account_file" {
#   type = string
# }