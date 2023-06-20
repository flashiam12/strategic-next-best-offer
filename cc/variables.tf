variable "env_name" {
  type = string
  default = "hsbc"
}

variable "confluent_api_key" {
  type = string
}

variable "confluent_api_secret" {
  type = string
}

variable "aws_cc_cluster_region" {
  type = string
}

variable "gcp_cc_cluster_region" {
  type = string
}
variable "aws_api_key" {
  type = string
}

variable "aws_api_secret" {
  type = string
}

variable "aws_kinesis_stream" {
  type = string
}

variable "aws_kinesis_stream_region" {
  type = string
}

variable "aws_s3_bucket" {
  type = string
}

variable "gcp_project_id" {
  type = string
}

variable "gcp_region"{
  type = string
}

variable "gcp_zone" {
  type = string
}

variable "gcp_credentials" {
  type = string
}

variable "gcp_service_account_email" {
  type = string
}

variable "gcp_pub_sub_topic_id" {
  type = string
}

variable "gcp_pub_sub_sub_id" {
  type = string
}

variable "gcp_bigtable_dataset" {
  type = string
}







