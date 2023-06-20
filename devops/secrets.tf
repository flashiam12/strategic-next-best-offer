resource "kubernetes_secret" "default" {
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