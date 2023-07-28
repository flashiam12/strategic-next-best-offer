resource "kubernetes_secret" "default" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "apps-secret"
    namespace = "internal"
  }
  data = {
    DB_USER = var.aws_rds_db_user
    DB_PASS = var.aws_rds_db_pass
    DB_URI = var.aws_rds_db_uri
    DB_NAME = var.aws_rds_db_name
    KAFKA_SASL_USERNAME = var.confluent_kafka_api_key
    KAFKA_SASL_PASSWORD = var.confluent_kafka_api_secret
    SR_AUTH = "${var.confluent_sr_api_key}:${var.confluent_sr_api_secret}"
  }
}

resource "kubernetes_secret" "gcp-creds" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "gcp-credentials"
    namespace = "internal"
  }

  data = {
    "service-account.json" = file(var.gcp_credentials_path)
  }

  type = "kubernetes.io/generic"
}