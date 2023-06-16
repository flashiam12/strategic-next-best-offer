variable "confluent_cloud_api_key " {
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

variable "gcp_cc_cluster_name" {
  type = string
  default = "gcp-cc-cluster"
}

variable "gcp_cc_cluster_region" {
  type = string
}

variable "gcp_cc_kafka_api_name" {
  type = string
  default = "dedicated-kafka-api-key"
}

variable "gcp_cc_ksql_cluster_name" {
  type = string
  default = "gcp_cc_ksqldb"
}

variable "gcp_cc_topics" {
  type = list(string)
  default = [
    "EnrichedCustomersBehavior",
    "NewOffersPerActivityType"
  ]
}

variable "gcp_landing_service_account" {
  type = string
}