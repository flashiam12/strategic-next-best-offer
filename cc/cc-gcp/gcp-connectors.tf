resource "confluent_connector" "PubSubSource" {
  count = var.gcp_create_cc_connectors == true ? 1 : 0
  environment {
    id = data.confluent_environment.default.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }

  config_sensitive = {
    "kafka.api.key": confluent_api_key.shiv-dedicated-public-kafka-api-key.id,
    "kafka.api.secret" : confluent_api_key.shiv-dedicated-public-kafka-api-key.secret,
    "gcp.pubsub.credentials.json" : file(var.gcp_credentials)
  }

  config_nonsensitive = {
    "name" : "hsbc-gcp-activity-next-best-offer",
    "connector.class": "PubSubSource",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "kafka.topic" : local.topic_ids[0],
    "gcp.pubsub.project.id": var.gcp_project_id,
    "gcp.pubsub.topic.id":var.gcp_pub_sub_topic_id,
    "gcp.pubsub.subscription.id": var.gcp_pub_sub_sub_id,
    "tasks.max" : "1"
  }

  depends_on = [
    confluent_kafka_acl.describe-on-cluster,
    confluent_kafka_acl.create-on-prefix-topics,
    confluent_kafka_acl.write-on-prefix-topics,
    confluent_kafka_acl.read-on-prefix-topics
  ]

  lifecycle {
    prevent_destroy = false
  }
}

resource "confluent_connector" "BigQuerySink" {
  count = var.gcp_create_cc_connectors == true ? 1 : 0
  environment {
    id = data.confluent_environment.default.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }

  config_sensitive = {
    "kafka.api.key" : confluent_api_key.shiv-dedicated-public-kafka-api-key.id,
    "kafka.api.secret" : confluent_api_key.shiv-dedicated-public-kafka-api-key.secret,
    "keyfile" : file(var.gcp_credentials)
  }

  config_nonsensitive = {
    "name" : "hsbc-enriched-customer-activity-table",
    "connector.class" : "BigQuerySink",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "project" : var.gcp_project_id,
    "datasets" : split("/", var.gcp_bigtable_dataset)[3],
    "input.data.format" : "JSON",
    "autoCreateTables" : "true"
    "sanitizeTopics" : "true"
    "autoUpdateSchemas" : "true"
    "sanitizeFieldNames" : "true"
    "tasks.max" : "1"
    "topics" : var.gcp_cc_bq_sink_topic
  }

  depends_on = [
    confluent_kafka_acl.describe-on-cluster,
    confluent_kafka_acl.create-on-prefix-topics,
    confluent_kafka_acl.write-on-prefix-topics,
    confluent_kafka_acl.read-on-prefix-topics
  ]

  lifecycle {
    prevent_destroy = false
  }
}