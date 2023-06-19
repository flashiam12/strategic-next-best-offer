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
