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
  chart      = "${path.module}/dependencies/confluent-for-kubernetes"
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

