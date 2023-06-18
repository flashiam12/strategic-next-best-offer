resource "confluent_schema_registry_cluster" "essentials" {
  package = "ESSENTIALS"

  environment {
    id = confluent_environment.default.id
  }

  region {
    # See https://docs.confluent.io/cloud/current/stream-governance/packages.html#stream-governance-regions
    id = "sgreg-1"
  }

  lifecycle {
    prevent_destroy = true
  }
}