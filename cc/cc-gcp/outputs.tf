output "gcp_cc_cluster" {
  value = confluent_kafka_cluster.dedicated.id
  description = "GCP CC Cluster"
}

output "gcp_cc_ksql_cluster" {
  value = confluent_ksql_cluster.gcp_cc_default.id
  description = "GCP CC KSQLDB Cluster"
}

output "gcp_cc_connectors" {
  value = [var.gcp_create_cc_connectors == true ? confluent_connector.PubSubSource:null, var.gcp_create_cc_connectors == true ? confluent_connector.BigQuerySink:null]
  description = "GCP CC connectors"
}

output "gcp_cc_topics" {
  value = local.topic_ids
  description = "GCP CC Topics"
}

output "gcp_cc_admin_api_key" {
  value = confluent_api_key.shiv-dedicated-public-kafka-api-key.id
  description = "GCP CC Admin API Key"
}

output "gcp_cc_admin_api_secret" {
  value = confluent_api_key.shiv-dedicated-public-kafka-api-key.secret
  description = "GCP CC Admin API Secret"
}