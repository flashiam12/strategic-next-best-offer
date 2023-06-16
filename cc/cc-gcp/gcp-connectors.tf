resource "confluent_connector" "PubSubSource" {
  environment {
    id = data.confluent_environment.default.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }

  config_sensitive = {

  }

  config_nonsensitive = {
  }

  depends_on = [
    confluent_kafka_acl.describe-on-cluster,
    confluent_kafka_acl.create-on-prefix-topics,
    confluent_kafka_acl.write-on-prefix-topics,
    confluent_kafka_acl.read-on-prefix-topics
  ]

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_connector" "BigQuerySink" {
  environment {
    id = data.confluent_environment.default.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }

  config_sensitive = {

  }

  config_nonsensitive = {
  }

  depends_on = [
    confluent_kafka_acl.describe-on-cluster,
    confluent_kafka_acl.create-on-prefix-topics,
    confluent_kafka_acl.write-on-prefix-topics,
    confluent_kafka_acl.read-on-prefix-topics
  ]

  lifecycle {
    prevent_destroy = true
  }
}