locals {
  elastic_ui_fqdn = "elastic-webui.hsbc-ops.selabs.net"
  elastic_http_fqdn = "elastic-http.hsbc-ops.selabs.net"
  elastic_kibana_fqdn = "elastic-kibana.hsbc-ops.selabs.net"
}
resource "helm_release" "elastic-operator" {
  name       = "elastic-operator"
  chart      = "${path.module}/dependencies/eck-operator"
  namespace = "elastic-system"
  cleanup_on_fail = true
  create_namespace = true
  values = [file("${path.module}/dependencies/eck-operator/values.yaml")]
  depends_on = [
   data.aws_eks_cluster.cluster 
  ]
}

resource "helm_release" "confluent-operator" {
  name       = "confluent-operator"
  chart      =  "${path.module}/dependencies/confluent-for-kubernetes"
  namespace = "elastic-system"
  cleanup_on_fail = true
  create_namespace = false
  values = [file("${path.module}/dependencies/confluent-for-kubernetes/values.yaml")]
  depends_on = [
    data.aws_eks_cluster.cluster,
    helm_release.elastic-operator
  ]
}

data "kubectl_file_documents" "cfk-permissions" {
    content = file("${path.module}/dependencies/confluent-for-kubernetes/cfk-permission.yaml")
}

resource "kubectl_manifest" "cfk-permissions" {
  for_each  = data.kubectl_file_documents.cfk-permissions.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent-operator
  ]
}

data "kubectl_file_documents" "elastic" {
    content = file("${path.module}/workloads/elastic.yaml")
}

resource "kubectl_manifest" "elastic" {
  for_each  = data.kubectl_file_documents.elastic.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.elastic-operator
  ]
}

data "kubectl_file_documents" "elastic-ui-ingress" {
    content = templatefile("${path.module}/workloads/elastic-ui-ingress.yaml",{
      aws_acm_cert_arn = "${var.aws_acm_arn}", 
      elastic_ui_fqdn = "${local.elastic_ui_fqdn}",
      aws_eks_vpc_public_subnet = "${var.aws_public_subnet}"
      })
}

resource "kubectl_manifest" "elastic-ui-ingress" {
  for_each  = data.kubectl_file_documents.elastic-ui-ingress.manifests
  yaml_body = each.value
  depends_on = [
    kubectl_manifest.elastic
  ]

}

data "kubectl_file_documents" "elastic-http-ingress" {
    content = templatefile("${path.module}/workloads/elasticsearch-http-ingress.yaml",{
      aws_acm_cert_arn = "${var.aws_acm_arn}", 
      elastic_http_fqdn = "${local.elastic_http_fqdn}",
      aws_eks_vpc_public_subnet = "${var.aws_public_subnet}"
      })
}

resource "kubectl_manifest" "elastic-http-ingress" {
  for_each  = data.kubectl_file_documents.elastic-http-ingress.manifests
  yaml_body = each.value
  depends_on = [
    kubectl_manifest.elastic
  ]

}

data "kubectl_file_documents" "elastic-kibana-ingress" {
    content = templatefile("${path.module}/workloads/elastic-kibana-ingress.yaml",{
      aws_acm_cert_arn = "${var.aws_acm_arn}", 
      elastic_kibana_fqdn = "${local.elastic_kibana_fqdn}",
      aws_eks_vpc_public_subnet = "${var.aws_public_subnet}"
      })
}

resource "kubectl_manifest" "elastic-kibana-ingress" {
  for_each  = data.kubectl_file_documents.elastic-kibana-ingress.manifests
  yaml_body = each.value
  depends_on = [
    kubectl_manifest.elastic
  ]

}

data "kubectl_file_documents" "cc-connect" {
    content = file("${path.module}/workloads/cc-connect.yaml")
}

resource "kubectl_manifest" "cc-connect" {
  for_each  = data.kubectl_file_documents.cc-connect.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent-operator
  ]
}

data "kubectl_file_documents" "cc-connectors" {
    content = file("${path.module}/workloads/cc-connectors.yaml")
}

resource "kubectl_manifest" "cc-connectors" {
  for_each  = data.kubectl_file_documents.cc-connectors.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.confluent-operator
  ]
}

