output "GCP_cc_cluster" {
  value = confluent_kafka_cluster.dedicated
  description = "GCP CC Cluster"
}

output "GCP_cc_ksql_cluster" {
  value = confluent_ksql_cluster.gcp_cc_default
  description = "GCP CC KSQLDB Cluster"
}

output "GCP_cc_connectors" {
  value = [confluent_connector.PubSubSource, confluent_connector.BigQuerySink]
  description = "GCP CC connectors"
}

output "GCP_cc_topics" {
  value = confluent_kafka_topic.gcp-cc-topics
  description = "GCP CC Topics"
}

output "GCp_cc_admin_api_key" {
  value = confluent_api_key.shiv-dedicated-public-kafka-api-key
  description = "GCP CC Admin API Key"
}