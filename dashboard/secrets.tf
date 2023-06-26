resource "kubernetes_secret" "ccloud-tls-certs" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "ccloud-tls-certs"
    namespace = "elastic-system"
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
    namespace = "elastic-system"
  }

  data = {
    "plain-jaas.conf" = "${file("./secrets/jaas.txt")}"
  }

  type = "kubernetes.io/generic"
}

resource "kubernetes_secret" "cloud-plain" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "cloud-plain"
    namespace = "elastic-system"
  }

  data = {
    "plain.txt" = "${file("./secrets/cloud-plain.txt")}"
  }

  type = "kubernetes.io/generic"
}

resource "kubernetes_secret" "connector-secrets" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "connector-secrets"
    namespace = "elastic-system"
  }

  data = {
    "connect.txt" = "${file("./secrets/connect.txt")}"
  }

  type = "kubernetes.io/generic"
}

resource "kubernetes_secret" "ca-pair-sslcerts" {
  provider = kubernetes.kubernetes-raw
  metadata {
    name = "ca-pair-sslcerts"
    namespace = "elastic-system"
  }

  data = {
    "tls.crt" = "${file("./secrets/cp-certs/ca.pem")}"
    "tls.key" = "${file("./secrets/cp-certs/ca-key.pem")}"
  }

  type = "kubernetes.io/tls"
}

