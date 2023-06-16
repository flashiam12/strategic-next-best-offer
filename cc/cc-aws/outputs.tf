output "aws_cc_cluster" {
  value = confluent_kafka_cluster.dedicated
  description = "AWS CC Cluster"
}

output "aws_cc_ksql_cluster" {
  value = confluent_ksql_cluster.aws_cc_default
  description = "AWS CC KSQLDB Cluster"
}

output "aws_cc_connectors" {
  value = [confluent_connector.KinesisSource, confluent_connector.S3Sink]
  description = "AWS CC connectors"
}

output "aws_cc_topics" {
  value = confluent_kafka_topic.aws-cc-topics
  description = "AWS CC Topics"
}

output "aws_cc_admin_api_key" {
  value = confluent_api_key.shiv-dedicated-public-kafka-api-key
  description = "AWS CC Admin API Key"
}