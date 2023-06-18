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