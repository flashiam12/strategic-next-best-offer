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