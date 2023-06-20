resource "confluent_connector" "PubSubSource" {
  count = var.gcp_create_cc_connectors == true ? 1 : 0
  environment {
    id = data.confluent_environment.default.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }

  config_sensitive = {
    "kafka.api.key": var.confluent_cloud_api_key,
    "kafka.api.secret" : var.confluent_cloud_api_secret,
    "gcp.pubsub.credentials.json" : var.gcp_credentials
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
    prevent_destroy = true
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