locals {
  prometheus_fqdn = "prometheus.hsbc-ops.selabs.net"
  grafana_fqdn = "grafana.hsbc-ops.selabs.net"
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  chart      = "${path.module}/dependencies/prometheus"
  namespace = "monitoring"
  cleanup_on_fail = true
  create_namespace = true
  set {
    name = "alertmanager.persistentVolume.storageClass"
    value = "gp3"
  }
  set {
    name = "server.persistentVolume.storageClass"
    value = "gp3"
  }
  set {
    name = "server.service.type"
    value = "NodePort"
  }
}


resource "helm_release" "grafana" {
  name       = "grafana"
  chart      = "${path.module}/dependencies/grafana"
  namespace = "monitoring"
  cleanup_on_fail = true
  create_namespace = false
#   values = [file("./configs/grafana.yaml")]
  set {
    name = "service.type"
    value = "NodePort"
  }
  set {
    name = "persistence.storageClassName"
    value = "gp3"
  }
  set {
    name = "persistence.enabled"
    value = true
  }
  set {
    name = "adminPassword"
    value = "password"
  }
  depends_on = [ helm_release.prometheus ]
}

# resource "helm_release" "loki" {
#   name       = "loki"
#   chart      = "${path.module}/dependencies/loki"
#   namespace = "monitoring"
#   cleanup_on_fail = true
#   create_namespace = false
# #   values = [file("./configs/grafana.yaml")]
#   set {
#     name = "service.type"
#     value = "NodePort"
#   }
#   set {
#     name = "persistence.storageClass"
#     value = "gp3"
#   }
#   set {
#     name = "minio.enabled"
#     value = true
#   }
#   depends_on = [ helm_release.grafana]
# }

data "kubectl_file_documents" "prometheus-ingress" {
    content = templatefile("${path.module}/workloads/prometheus-ingress.yaml",{
      aws_acm_cert_arn = "${var.aws_acm_arn}", 
      prometheus_http_fqdn = "${local.prometheus_fqdn}",
      aws_eks_vpc_public_subnet = "${var.aws_public_subnet}"
      })
}

resource "kubectl_manifest" "prometheus-ingress" {
  for_each  = data.kubectl_file_documents.prometheus-ingress.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.prometheus
  ]
}

data "kubectl_file_documents" "grafana-ingress" {
    content = templatefile("${path.module}/workloads/grafana-ingress.yaml",{
      aws_acm_cert_arn = "${var.aws_acm_arn}", 
      grafana_http_fqdn = "${local.grafana_fqdn}",
      aws_eks_vpc_public_subnet = "${var.aws_public_subnet}"
      })
}

resource "kubectl_manifest" "grafana-ingress" {
  for_each  = data.kubectl_file_documents.grafana-ingress.manifests
  yaml_body = each.value
  depends_on = [
    helm_release.prometheus
  ]
}