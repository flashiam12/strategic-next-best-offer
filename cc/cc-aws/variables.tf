variable "confluent_cloud_api_key " {
  type = string
}

variable "confluent_cloud_api_secret" {
  type = string
}

variable "confluent_cloud_env_id" {
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

variable "confluent_cloud_schema_registry_id" {
  type = string
}

variable "aws_cc_ksql_cluster_name" {
  type = string
  default = "aws_cc_ksqldb"
}

variable "aws_cc_topics" {
  type = list(string)
  default = [
    "EnrichedCustomersBehavior",
    "NextBestOffersPerCustomerActivityEvent",
    "NewOffersPerActivityType"
  ]
}

variable "aws_landing_api_key" {
  type = string
}

variable "aws_landing_api_secret" {
  type = string
}
