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
    "gcp-new-offers-per-activity-type"
  ]
}

variable "gcp_create_cc_connectors" {
  type = bool
  default = false
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

variable "gcp_cc_bq_sink_topic" {
  type = string
}