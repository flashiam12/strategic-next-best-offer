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