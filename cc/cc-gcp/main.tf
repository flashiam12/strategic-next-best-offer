### DEFAULTING DATA TO ROOT ENVIRONMENT ###

data "confluent_environment" "default" {
  id = var.confluent_cloud_env_id
}

#####################################################################

### DEFAULTING DATA TO ROOT SCHEMA REGISTRY ###

data "confluent_schema_registry_cluster" "default" {
  id = var.confluent_cloud_schema_registry_id
  environment {
    id = data.confluent_environment.default.id
  }
}
