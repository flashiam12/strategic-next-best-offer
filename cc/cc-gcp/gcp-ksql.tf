resource "confluent_role_binding" "default-sa-rb-schema-registry-resource-owner" {
  principal   = "User:${confluent_service_account.app-ksql.id}"
  role_name   = "ResourceOwner"
  crn_pattern = format("%s/%s", data.confluent_schema_registry_cluster.default.resource_name, "subject=*")

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_ksql_cluster" "gcp_cc_default" {
  display_name = var.gcp_cc_ksql_cluster_name
  csu          = 1
  kafka_cluster {
    id = confluent_kafka_cluster.dedicated.id
  }
  credential_identity {
    id = confluent_service_account.default.id
  }
  environment {
    id = data.confluent_environment.default.id
  }
  depends_on = [
    confluent_role_binding.default-sa-rb-schema-registry-resource-owner,
    data.confluent_schema_registry_cluster.default
  ]

  lifecycle {
    prevent_destroy = true
  }
}