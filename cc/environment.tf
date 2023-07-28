resource "confluent_environment" "default" {
  display_name = var.env_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "confluent_service_account" "env-manager" {
  display_name = "env-manager-sa"
  description  = "Service Account for env"
}

resource "confluent_role_binding" "environment-manager-sa-rb" {
  principal   = "User:${confluent_service_account.env-manager.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.default.resource_name
}

