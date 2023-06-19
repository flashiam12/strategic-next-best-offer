data "kubectl_file_documents" "namespace" {
    content = file("${path.module}/workloads/internal-ns.yaml")
}

resource "kubectl_manifest" "namespace" {
  for_each  = data.kubectl_file_documents.namespace.manifests
  yaml_body = each.value
  depends_on = [
    null_resource.build
  ]
}

data "kubectl_file_documents" "customer-registration" {
    content = file("${path.module}/workloads/customer-registration-service-cron.yaml")
}

resource "kubectl_manifest" "customer-registration" {
  for_each  = data.kubectl_file_documents.customer-registration.manifests
  yaml_body = each.value
  depends_on = [
    null_resource.build
  ]
}
