resource "confluent_environment" "default" {
  display_name = var.env_name

  lifecycle {
    prevent_destroy = true
  }
}