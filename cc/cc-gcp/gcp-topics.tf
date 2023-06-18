locals {
  topic_names = var.gcp_cc_topics
}

resource "confluent_kafka_topic" "gcp-cc-topics" {
  count = length(local.topic_names)
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }
  topic_name         = local.topic_names[count.index]
  rest_endpoint      = confluent_kafka_cluster.dedicated.rest_endpoint
  credentials {
    key    = confluent_api_key.shiv-dedicated-public-kafka-api-key.id
    secret = confluent_api_key.shiv-dedicated-public-kafka-api-key.secret
  }

  lifecycle {
    prevent_destroy = false
  }
  depends_on = [ 
    confluent_kafka_acl.create-on-prefix-topics, 
    confluent_kafka_acl.describe-on-cluster, 
    confluent_kafka_acl.write-on-prefix-topics, 
    confluent_kafka_acl.read-on-prefix-topics 
  ]
}

locals {
  topic_ids = [ for topic in confluent_kafka_topic.gcp-cc-topics : topic.id ]
}