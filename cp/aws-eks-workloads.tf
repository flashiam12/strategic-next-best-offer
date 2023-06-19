locals {
  cp_cc_fqdn = "cp-controlcenter.hsbc-ops.selabs.net"
  cp_connect_fqdn = "cp-connect.hsbc-ops.selabs.net"
  cp_ksql_fqdn = "cp-ksqldb.hsbc-ops.selabs.net"
  cp_sr_fqdn = "cp-schema-registry.hsbc-ops.selabs.net"
  # eks_vpc_public_subnet = module.ops-vpc.public_subnets
  eks_vpc_public_subnet = join(", ", [for s in module.ops-vpc.public_subnets : s])
  cp_kafka_bootstrap = "cp-hsbc-ops.hsbc-ops.selabs.net"
  cp_kafka_broker_0 = "cp-hsbc-src0.hsbc-ops.selabs.net"
  cp_kafka_broker_1 = "cp-hsbc-src1.hsbc-ops.selabs.net"
  cp_kafka_broker_2 = "cp-hsbc-src2.hsbc-ops.selabs.net"
  k8s_dashboard = "k8-hsbc-ops.hsbc-ops.selabs.net"
}

data "kubectl_file_documents" "cp-cluster" {
    content = file("${path.module}/apps/cp-cluster.yaml")
}

resource "kubectl_manifest" "cp-cluster" {
  for_each  = data.kubectl_file_documents.cp-cluster.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent-operator,
    kubernetes_secret.ca-pair-sslcerts,
    kubernetes_secret.credential,
    kubernetes_secret.rest-credential,
    kubernetes_secret.password-encoder-secret
  ]
}

data "kubectl_file_documents" "cp-connectors" {
    content = file("${path.module}/apps/cp-connectors.yaml")
}

resource "kubectl_manifest" "cp-connectors" {
  for_each  = data.kubectl_file_documents.cp-connectors.manifests
  yaml_body = each.value
  depends_on = [
    kubectl_manifest.cp-connect
  ]
}

data "kubectl_file_documents" "cp-connect" {
    content = file("${path.module}/apps/cp-connect.yaml")
}

resource "kubectl_manifest" "cp-connect" {
  for_each  = data.kubectl_file_documents.cp-connect.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent-operator,
    kubernetes_secret.ca-pair-sslcerts,
    kubernetes_secret.credential,
    kubernetes_secret.rest-credential,
    kubernetes_secret.password-encoder-secret,
    kubectl_manifest.cp-cluster
  ]
}

data "kubectl_file_documents" "cp-ksql" {
    content = file("${path.module}/apps/cp-ksql.yaml")
}

resource "kubectl_manifest" "cp-ksql" {
  for_each  = data.kubectl_file_documents.cp-ksql.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent-operator,
    kubernetes_secret.ca-pair-sslcerts,
    kubernetes_secret.credential,
    kubernetes_secret.rest-credential,
    kubernetes_secret.password-encoder-secret,
    kubectl_manifest.cp-cluster
  ]
}

data "kubectl_file_documents" "cp-controlcenter" {
    content = file("${path.module}/apps/cp-controlcenter.yaml")
}

resource "kubectl_manifest" "cp-controlcenter" {
  for_each  = data.kubectl_file_documents.cp-controlcenter.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent-operator,
    kubernetes_secret.ca-pair-sslcerts,
    kubernetes_secret.credential,
    kubernetes_secret.rest-credential,
    kubernetes_secret.password-encoder-secret,
    kubectl_manifest.cp-cluster,
    kubectl_manifest.cp-connect,
    kubectl_manifest.cp-ksql
  ]
}

data "kubectl_file_documents" "cp-cc-restclass" {
    content = file("${path.module}/apps/cp-cc-restclass.yaml")
}

resource "kubectl_manifest" "cp-cc-restclass" {
  for_each  = data.kubectl_file_documents.cp-cc-restclass.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent-operator,
    kubernetes_secret.rest-credential,
    kubernetes_secret.restclass-ccloud,
    kubectl_manifest.cp-cluster
  ]
}

data "kubectl_file_documents" "cp-topics" {
    content = file("${path.module}/apps/cp-topics.yaml")
}

resource "kubectl_manifest" "cp-topics" {
  for_each  = data.kubectl_file_documents.cp-topics.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent-operator,
    kubectl_manifest.cp-cc-restclass
  ]
}

data "kubectl_file_documents" "cp-cc-aws-cluster-link" {
    content = file("${path.module}/apps/cp-cc-aws-cluster-connect.yaml")
}

resource "kubectl_manifest" "cp-cc-aws-cluster-link" {
  for_each  = data.kubectl_file_documents.cp-cc-aws-cluster-link.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent-operator,
    kubectl_manifest.cp-cc-restclass,
    kubernetes_secret.jaasconfig-ccloud,
    kubernetes_secret.ccloud-tls-certs,
    kubernetes_secret.credential
  ]
}

data "kubectl_file_documents" "cp-controlcenter-ingress" {
    content = templatefile("${path.module}/apps/ingress/cp-controlcenter-ingress.yaml", {
      aws_acm_cert_arn = "${aws_acm_certificate.default.arn}", 
      cp_controlcenter_fqdn = "${local.cp_cc_fqdn}",
      aws_eks_vpc_public_subnet = "${local.eks_vpc_public_subnet}"
      }
    )
}

resource "kubectl_manifest" "cp-controlcenter-ingress" {
  # for_each  = data.kubectl_file_documents.cp-ingress.manifests
  yaml_body = data.kubectl_file_documents.cp-controlcenter-ingress.content
  depends_on = [
    helm_release.confluent-operator,
    kubectl_manifest.cp-cc-restclass,
    kubernetes_secret.jaasconfig-ccloud,
    kubernetes_secret.ccloud-tls-certs,
    kubernetes_secret.credential,
    kubectl_manifest.cp-controlcenter
  ]
}

data "kubectl_file_documents" "cp-connect-ingress" {
    content = templatefile("${path.module}/apps/ingress/cp-connect-ingress.yaml", {
      aws_acm_cert_arn = "${aws_acm_certificate.default.arn}", 
      cp_connect_fqdn = "${local.cp_connect_fqdn}",
      aws_eks_vpc_public_subnet = "${local.eks_vpc_public_subnet}"
      }
    )
}

resource "kubectl_manifest" "cp-connect-ingress" {
  # for_each  = data.kubectl_file_documents.cp-ingress.manifests
  yaml_body = data.kubectl_file_documents.cp-connect-ingress.content
  depends_on = [
    helm_release.confluent-operator,
    kubectl_manifest.cp-cc-restclass,
    kubernetes_secret.jaasconfig-ccloud,
    kubernetes_secret.ccloud-tls-certs,
    kubernetes_secret.credential,
    kubectl_manifest.cp-connect
  ]
}

data "kubectl_file_documents" "cp-ksql-ingress" {
    content = templatefile("${path.module}/apps/ingress/cp-ksql-ingress.yaml", {
      aws_acm_cert_arn = "${aws_acm_certificate.default.arn}", 
      cp_ksql_fqdn = "${local.cp_ksql_fqdn}",
      aws_eks_vpc_public_subnet = "${local.eks_vpc_public_subnet}"
      }
    )
}

resource "kubectl_manifest" "cp-ksql-ingress" {
  # for_each  = data.kubectl_file_documents.cp-ingress.manifests
  yaml_body = data.kubectl_file_documents.cp-ksql-ingress.content
  depends_on = [
    helm_release.confluent-operator,
    kubectl_manifest.cp-cc-restclass,
    kubernetes_secret.jaasconfig-ccloud,
    kubernetes_secret.ccloud-tls-certs,
    kubernetes_secret.credential,
    kubectl_manifest.cp-ksql
  ]
}

data "kubectl_file_documents" "cp-sr-ingress" {
    content = templatefile("${path.module}/apps/ingress/cp-sr-ingress.yaml", {
      aws_acm_cert_arn = "${aws_acm_certificate.default.arn}",
      cp_sr_fqdn = "${local.cp_sr_fqdn}",
      aws_eks_vpc_public_subnet = "${local.eks_vpc_public_subnet}"
      }
    )
}

resource "kubectl_manifest" "cp-sr-ingress" {
  # for_each  = data.kubectl_file_documents.cp-ingress.manifests
  yaml_body = data.kubectl_file_documents.cp-sr-ingress.content
  depends_on = [
    helm_release.confluent-operator,
    kubectl_manifest.cp-cc-restclass,
    kubernetes_secret.jaasconfig-ccloud,
    kubernetes_secret.ccloud-tls-certs,
    kubernetes_secret.credential,
    kubectl_manifest.cp-cluster
  ]
}

data "kubectl_file_documents" "k8s-dashboard" {
  content = file("${path.module}/apps/k8s-dashboard.yaml")
}

resource "kubectl_manifest" "k8s-dashboard" {
  for_each  = data.kubectl_file_documents.k8s-dashboard.manifests
  yaml_body = each.value
  depends_on = [
    aws_eks_node_group.default-node-pool
  ]
}

data "kubectl_file_documents" "k8s-dashboard-admin" {
  content = file("${path.module}/apps/k8s-dashboard-admin.yaml")
}

resource "kubectl_manifest" "k8s-dashboard-admin" {
  for_each  = data.kubectl_file_documents.k8s-dashboard-admin.manifests
  yaml_body = each.value
  depends_on = [
    aws_eks_node_group.default-node-pool
  ]
}

data "kubectl_file_documents" "k8s-dashboard-ingress" {
    content = templatefile("${path.module}/apps/ingress/k8s-dashboard-ingress.yaml", {
      aws_acm_cert_arn = "${aws_acm_certificate.default.arn}",
      k8_dashboard_fqdn = "${local.k8s_dashboard}",
      aws_eks_vpc_public_subnet = "${local.eks_vpc_public_subnet}"
      }
    )
}

resource "kubectl_manifest" "k8s-dashboard-ingress" {
  # for_each  = data.kubectl_file_documents.cp-ingress.manifests
  yaml_body = data.kubectl_file_documents.k8s-dashboard-ingress.content
  depends_on = [
    kubectl_manifest.k8s-dashboard
  ]
}