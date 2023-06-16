resource "confluent_service_account" "default" {
  display_name = "admin-sa-aws"
  description  = "Service Account for administrative tasks in environment"
}

resource "confluent_role_binding" "default" {
  principal   = "User:${confluent_service_account.default.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = data.confluent_environment.default.resource_name
}