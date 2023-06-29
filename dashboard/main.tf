data "aws_caller_identity" "current" {}

data "aws_eks_cluster_auth" "cluster" {
    name = var.aws_eks_cluster_name
}
data "aws_eks_cluster" "cluster" {
    name = var.aws_eks_cluster_name
}
data "aws_route53_zone" "default" {
  name         = "selabs.net"
  private_zone = false
}
data "aws_lb" "default" {
  name = "cp-ingress"
}
resource "aws_route53_record" "elastic-ui" {
  allow_overwrite = true
  name            = local.elastic_ui_fqdn
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.default.dns_name
    zone_id                = data.aws_lb.default.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "elastic-http" {
  allow_overwrite = true
  name            = local.elastic_http_fqdn
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.default.dns_name
    zone_id                = data.aws_lb.default.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "elastic-kibana" {
  allow_overwrite = true
  name            = local.elastic_kibana_fqdn
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.default.dns_name
    zone_id                = data.aws_lb.default.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "grafana" {
  allow_overwrite = true
  name            = local.grafana_fqdn
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.default.dns_name
    zone_id                = data.aws_lb.default.zone_id
    evaluate_target_health = true
  }
}
resource "aws_route53_record" "prometheus" {
  allow_overwrite = true
  name            = local.prometheus_fqdn
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.default.dns_name
    zone_id                = data.aws_lb.default.zone_id
    evaluate_target_health = true
  }
}