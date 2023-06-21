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

data "kubectl_file_documents" "pg-nginx-proxy" {
    content = file("${path.module}/workloads/pg-nginx-proxy.yaml")
}

resource "kubectl_manifest" "pg-nginx-proxy" {
  for_each  = data.kubectl_file_documents.pg-nginx-proxy.manifests
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

data "kubectl_file_documents" "customer-activity" {
    content = file("${path.module}/workloads/customer-activity-service-cron.yaml")
}

resource "kubectl_manifest" "customer-activity" {
  for_each  = data.kubectl_file_documents.customer-activity.manifests
  yaml_body = each.value
  depends_on = [
    null_resource.build
  ]
}

data "kubectl_file_documents" "customer-propensity" {
    content = file("${path.module}/workloads/customer-propensity-service-cron.yaml")
}

resource "kubectl_manifest" "customer-propensity" {
  for_each  = data.kubectl_file_documents.customer-propensity.manifests
  yaml_body = each.value
  depends_on = [
    null_resource.build
  ]
}

data "kubectl_file_documents" "activity-offer" {
    content = file("${path.module}/workloads/activity-offer-service-cron.yaml")
}

resource "kubectl_manifest" "activity-offer" {
  for_each  = data.kubectl_file_documents.activity-offer.manifests
  yaml_body = each.value
  depends_on = [
    null_resource.build
  ]
}
