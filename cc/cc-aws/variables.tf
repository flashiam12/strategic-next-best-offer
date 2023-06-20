variable "confluent_cloud_api_key" {
  type = string
}

variable "confluent_cloud_api_secret" {
  type = string
}

variable "confluent_cloud_env_id" {
  type = string
}

variable "confluent_cloud_schema_registry_id" {
  type = string
}

variable "aws_cc_cluster_name" {
  type = string
  default = "aws-cc-cluster"
}

variable "aws_cc_cluster_region" {
  type = string
}

variable "aws_cc_kafka_api_name" {
  type = string
  default = "dedicated-kafka-api-key"
}

variable "aws_cc_ksql_cluster_name" {
  type = string
  default = "aws_cc_ksqldb"
}

variable "aws_cc_topics" {
  type = list(string)
  default = [
    "aws-next-best-offers-per-customer-activity-event"
  ]
}

variable "aws_create_cc_connectors" {
  type = bool
  default = false
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