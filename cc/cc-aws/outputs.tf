output "aws_cc_cluster" {
  value = confluent_kafka_cluster.dedicated.id
  description = "AWS CC Cluster"
}

output "aws_cc_ksql_cluster" {
  value = confluent_ksql_cluster.aws_cc_default.id
  description = "AWS CC KSQLDB Cluster"
}

output "aws_cc_connectors" {
  value = [var.aws_create_cc_connectors == true ? confluent_connector.KinesisSource[0].id:null, var.aws_create_cc_connectors == true ? confluent_connector.S3Sink[0].id:null]
  description = "AWS CC connectors"
}

output "aws_cc_topics" {
  value = local.topic_ids
  description = "AWS CC Topics"
}

output "aws_cc_admin_api_key" {
  value = confluent_api_key.shiv-dedicated-public-kafka-api-key.id
  description = "AWS CC Admin API Key"
}

output "aws_cc_admin_api_secret" {
  value = confluent_api_key.shiv-dedicated-public-kafka-api-key.secret
  description = "AWS CC Admin API Secret"
}