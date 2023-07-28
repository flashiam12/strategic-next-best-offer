variable "aws_eks_cluster_name" {
  type = string
}
variable "aws_eks_node_group_arn" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "aws_api_key" {
  type = string
}
variable "aws_api_secret" {
  type = string
}
variable "aws_trigger_ci" {
  type = bool
  default = true
}

variable "aws_rds_db_user" {
  type = string
}

variable "aws_rds_db_pass" {
  type = string
}

variable "aws_rds_db_uri" {
  type = string
}

variable "aws_rds_db_name" {
  type = string
}

variable "gcp_credentials_path" {
  type = string
}

variable "confluent_kafka_api_key" {
  type = string
}

variable "confluent_kafka_api_secret" {
  type = string
}

variable "confluent_sr_api_key" {
  type = string
}

variable "confluent_sr_api_secret" {
  type = string
}