resource "kubernetes_secret" "ccloud-tls-certs" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "ccloud-tls-certs"
    namespace = "confluent"
  }

  data = {
    "fullchain.pem" = "${file("./secrets/cloud-certs/fullchain.pem")}"
    "cacerts.pem" = "${file("./secrets/cloud-certs/cacert.pem")}"
  }

  type = "kubernetes.io/generic"
}

resource "kubernetes_secret" "jaasconfig-ccloud" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "jaasconfig-ccloud"
    namespace = "confluent"
  }

  data = {
    "plain-jaas.conf" = "${file("./secrets/jaas.txt")}"
  }

  type = "kubernetes.io/generic"
}

resource "kubernetes_secret" "restclass-ccloud" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "restclass-ccloud"
    namespace = "confluent"
  }

  data = {
    "basic.txt" = "${file("./secrets/basic.txt")}"
  }

  type = "kubernetes.io/generic"
}

resource "kubernetes_secret" "ca-pair-sslcerts" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "ca-pair-sslcerts"
    namespace = "confluent"
  }

  data = {
    "tls.crt" = "${file("./secrets/cp-certs/ca.pem")}"
    "tls.key" = "${file("./secrets/cp-certs/ca-key.pem")}"
  }

  type = "kubernetes.io/tls"
}

resource "kubernetes_secret" "credential" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "credential"
    namespace = "confluent"
  }

  data = {
    "plain-users.json" = "${file("./secrets/creds-kafka-sasl-users.json")}"
    "plain.txt" = "${file("./secrets/creds-client-kafka-sasl-user.txt")}"
    "basic.txt" = "${file("./secrets/creds-basic-user.txt")}"
  }

  type = "kubernetes.io/generic"
}

resource "kubernetes_secret" "rest-credential" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "rest-credential"
    namespace = "confluent"
  }

  data = {
    "basic.txt" = "${file("./secrets/rest-credential.txt")}"
  }

  type = "kubernetes.io/generic"
}

resource "kubernetes_secret" "password-encoder-secret" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "password-encoder-secret"
    namespace = "confluent"
  }

  data = {
    "password-encoder.txt" = "${file("./secrets/passwordencoder.txt")}"
  }

  type = "kubernetes.io/generic"
}

resource "kubernetes_secret" "connector-secrets" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "connector-secrets"
    namespace = "confluent"
  }

  data = {
    "connect.txt" = "${file("./secrets/connect.txt")}"
  }

  type = "kubernetes.io/generic"
}

resource "aws_acm_certificate" "default" {
  domain_name       = "*.hsbc-ops.selabs.net"
  validation_method = "DNS"
}

resource "aws_route53_record" "cert" {
  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.default.zone_id
}

resource "aws_acm_certificate_validation" "default" {
  certificate_arn         = aws_acm_certificate.default.arn
  validation_record_fqdns = [for record in aws_route53_record.cert : record.fqdn]
}

resource "kubernetes_secret" "cloud-plain" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "cloud-plain"
    namespace = "confluent"
  }

  data = {
    "plain.txt" = "${file("./secrets/cloud-plain.txt")}"
  }

  type = "kubernetes.io/generic"
}

resource "kubernetes_secret" "cloud-sr-basic" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "cloud-sr-basic"
    namespace = "confluent"
  }

  data = {
    "basic.txt" = "${file("./secrets/cloud-aws-sr-basic.txt")}"
  }

  type = "kubernetes.io/generic"
}

data "kubernetes_secret" "ksql-cert" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "ksqldb-generated-jks"
    namespace = "confluent"
  }
}

resource "local_file" "ksql_tls_key" {
  content  = data.kubernetes_secret.ksql-cert.data["tls.key"]
  filename = "secrets/cp-ksql-certs/tls.key"
}

resource "local_file" "ksql_tls_crt" {
  content  = data.kubernetes_secret.ksql-cert.data["tls.crt"]
  filename = "secrets/cp-ksql-certs/tls.crt"
}

resource "local_file" "ksql_tls_ca" {
  content  = data.kubernetes_secret.ksql-cert.data["ca.crt"]
  filename = "secrets/cp-ksql-certs/ca.crt"
}



module "ksql-acm" {
  source              = "clouddrove/acm/aws"
  version             = "1.3.0"
  name                = "ksql-cert"
  environment         = "ops"
  label_order         = ["name","environment"]
  private_key         = local_file.ksql_tls_key.filename
  certificate_body    = local_file.ksql_tls_crt.filename
  certificate_chain   = local_file.ksql_tls_ca.filename
  import_certificate  = true
  depends_on = [ 
    local_file.ksql_tls_ca, 
    local_file.ksql_tls_crt,
    local_file.ksql_tls_key
   ]
}

# resource "kubernetes-secrets" "ksql-tls-certs" {
#   provider = kubernetes.kubernetes-raw
#   metadata {
#     name = "ksql-tls-certs"
#     namespace = "confluent"
#   }

#   data = {
#     "fullchain.pem" = ""
#     "cacerts.pem" = ""
#     "privkey.pem" = ""
#   }

#   type = "kubernetes.io/generic"
# }