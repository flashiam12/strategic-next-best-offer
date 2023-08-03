resource "confluent_connector" "KinesisSource" {
  count = var.aws_create_cc_connectors == true ? 1 : 0
  environment {
    id = data.confluent_environment.default.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }

  config_sensitive = {
    "kafka.api.key": confluent_api_key.shiv-dedicated-public-kafka-api-key.id
    "kafka.api.secret" : confluent_api_key.shiv-dedicated-public-kafka-api-key.secret,
    "aws.access.key.id" : var.aws_api_key,
    "aws.secret.key.id": var.aws_api_secret
  }

  config_nonsensitive = {
    "name" : "hsbc-aws-customer-propensity-stream",
    "connector.class": "KinesisSource",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "kafka.topic" : "aws-customer-propensity-score",
    "kinesis.stream": var.aws_kinesis_stream,
    "kinesis.region" : var.aws_kinesis_stream_region,
    "kinesis.position": "LATEST",
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

resource "confluent_connector" "S3Sink" {
  count = var.aws_create_cc_connectors == true ? 1 : 0
  environment {
    id = data.confluent_environment.default.id
  }
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }

  config_sensitive = {
    "kafka.api.key": confluent_api_key.shiv-dedicated-public-kafka-api-key.id
    "kafka.api.secret" : confluent_api_key.shiv-dedicated-public-kafka-api-key.secret,
    "aws.access.key.id" : var.aws_api_key,
    "aws.secret.access.key": var.aws_api_secret
  }

  config_nonsensitive = {
    "name" : "hsbc-aws-next-best-offer-per-activity-bucket",
    "connector.class": "S3_SINK",
    "kafka.auth.mode": "KAFKA_API_KEY",
    "input.data.format": "JSON_SR",
    "output.data.format": "JSON",
    "compression.codec": "JSON - gzip",
    "s3.compression.level": "6",
    "s3.bucket.name": var.aws_s3_bucket,
    "time.interval" : "HOURLY",
    "flush.size": "1000",
    "tasks.max" : "1",
    "topics": "aws-next-best-offers-per-customer-current-activity-event-result",
    # "store.kafka.keys": true,
    "schema.compatibility": "FULL"
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