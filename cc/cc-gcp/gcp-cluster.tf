### CREATING DEDICATED CLUSTER WITH PUBLIC ENDPOINTS

resource "confluent_kafka_cluster" "dedicated" {
  display_name = var.gcp_cc_cluster_name
  availability = "MULTI_ZONE"
  cloud        = "GCP"
  region       = var.gcp_cc_cluster_region
  dedicated {
    cku = 2
  }

  environment {
    id = data.confluent_environment.default.id
  }

  lifecycle {
    prevent_destroy = true
  }
}

#####################################################################

### CREATING API KEY TO MANAGE CLUSTER FROM ADMIN SA AS PRINCIPAL ###

resource "confluent_api_key" "shiv-dedicated-public-kafka-api-key" {
  display_name = var.gcp_cc_kafka_api_name
  description  = "Kafka API Key owned by default admin service account"
  
  owner {
    id          = confluent_service_account.default.id
    api_version = confluent_service_account.default.api_version
    kind        = confluent_service_account.default.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.dedicated.id
    api_version = confluent_kafka_cluster.dedicated.api_version
    kind        = confluent_kafka_cluster.dedicated.kind

    environment {
      id = data.confluent_environment.default.id
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

#################################################################

### CLUSTER ROLE BINDING FOR DEDICATED CLUSTER TO DEFAULT SERVICE ACCOUNT ###


resource "confluent_role_binding" "default-sa-rb-dedicated-public" {
  principal   = "User:${confluent_service_account.default.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.dedicated.rbac_crn
}

##################################################################

### KAFKA ACL ON DEFAULT SERVICE ACCOUNT ###

### DESCRIBE CLUSTER

resource "confluent_kafka_acl" "describe-on-cluster" {
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }
  resource_type = "CLUSTER"
  resource_name = "kafka-cluster"
  pattern_type  = "LITERAL"
  principal     = "User:${confluent_service_account.default.id}"
  host          = "*"
  operation     = "DESCRIBE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dedicated.rest_endpoint
  credentials {
    key    = confluent_api_key.shiv-dedicated-public-kafka-api-key.id
    secret = confluent_api_key.shiv-dedicated-public-kafka-api-key.secret
  }
}

### WRITE ON PREFIX TOPICS

resource "confluent_kafka_acl" "write-on-prefix-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }
  resource_type = "TOPIC"
  resource_name = "aws-cc-acl-write-topic"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.default.id}"
  host          = "*"
  operation     = "WRITE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dedicated.rest_endpoint
  credentials {
    key    = confluent_api_key.shiv-dedicated-public-kafka-api-key.id
    secret = confluent_api_key.shiv-dedicated-public-kafka-api-key.secret
  }
}

resource "confluent_kafka_acl" "read-on-prefix-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }
  resource_type = "TOPIC"
  resource_name = "aws-cc-acl-write-topic"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.default.id}"
  host          = "*"
  operation     = "READ"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dedicated.rest_endpoint
  credentials {
    key    = confluent_api_key.shiv-dedicated-public-kafka-api-key.id
    secret = confluent_api_key.shiv-dedicated-public-kafka-api-key.secret
  }
}

### CREATE ON PREFIX TOPIC 

resource "confluent_kafka_acl" "create-on-prefix-topics" {
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }
  resource_type = "TOPIC"
  resource_name = "aws-cc-acl-create-topic"
  pattern_type  = "PREFIXED"
  principal     = "User:${confluent_service_account.default.id}"
  host          = "*"
  operation     = "CREATE"
  permission    = "ALLOW"
  rest_endpoint = confluent_kafka_cluster.dedicated.rest_endpoint
  credentials {
    key    = confluent_api_key.shiv-dedicated-public-kafka-api-key.id
    secret = confluent_api_key.shiv-dedicated-public-kafka-api-key.secret
  }
}

##################################################################





