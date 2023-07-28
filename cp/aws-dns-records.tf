
data "aws_route53_zone" "default" {
  name         = "selabs.net"
  private_zone = false
}

resource "aws_route53_record" "cp-controlcenter-ingress" {
  allow_overwrite = true
  name            = local.cp_cc_fqdn
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.cp-ingress.dns_name
    zone_id                = data.aws_lb.cp-ingress.zone_id
    evaluate_target_health = true
  }
}

# resource "aws_route53_record" "cp-controlcenter-clone-ingress" {
#   allow_overwrite = true
#   name            = local.cp_cc_clone_fqdn
#   type            = "A"
#   zone_id         = data.aws_route53_zone.default.zone_id
#   alias {
#     name                   = data.aws_lb.cp-ingress.dns_name
#     zone_id                = data.aws_lb.cp-ingress.zone_id
#     evaluate_target_health = true
#   }
# }

resource "aws_route53_record" "cp-ksql-ingress" {
  allow_overwrite = true
  name            = local.cp_ksql_fqdn
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.cp-ingress.dns_name
    zone_id                = data.aws_lb.cp-ingress.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cp-connect-ingress" {
  allow_overwrite = true
  name            = local.cp_connect_fqdn
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.cp-ingress.dns_name
    zone_id                = data.aws_lb.cp-ingress.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cp-connect-clone-ingress" {
  allow_overwrite = true
  name            = local.cp_connect_clone_fqdn
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.cp-ingress.dns_name
    zone_id                = data.aws_lb.cp-ingress.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cp-sr-ingress" {
  allow_overwrite = true
  name            = local.cp_sr_fqdn
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.cp-ingress.dns_name
    zone_id                = data.aws_lb.cp-ingress.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "k8-dashboard-ingress" {
  allow_overwrite = true
  name            = local.k8s_dashboard
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.cp-ingress.dns_name
    zone_id                = data.aws_lb.cp-ingress.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cp-kafka-bootstarp" {
  allow_overwrite = true
  name            = local.cp_kafka_bootstrap
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.cp-kafka-bootstrap.dns_name
    zone_id                = data.aws_lb.cp-kafka-bootstrap.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cp-kafka-broker-0" {
  allow_overwrite = true
  name            = local.cp_kafka_broker_0
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.cp-kafka-0.dns_name
    zone_id                = data.aws_lb.cp-kafka-0.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cp-kafka-broker-1" {
  allow_overwrite = true
  name            = local.cp_kafka_broker_1
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.cp-kafka-1.dns_name
    zone_id                = data.aws_lb.cp-kafka-1.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cp-kafka-broker-2" {
  allow_overwrite = true
  name            = local.cp_kafka_broker_2
  type            = "A"
  zone_id         = data.aws_route53_zone.default.zone_id
  alias {
    name                   = data.aws_lb.cp-kafka-2.dns_name
    zone_id                = data.aws_lb.cp-kafka-2.zone_id
    evaluate_target_health = true
  }
}

# resource "aws_route53_record" "cp-ksqldb-bootstrap" {
#   allow_overwrite = true
#   name            = local.cp_ksql_clone_fqdn
#   type            = "A"
#   zone_id         = data.aws_route53_zone.default.zone_id
#   alias {
#     name                   = data.aws_lb.cp-ksqldb-bootstrap.dns_name
#     zone_id                = data.aws_lb.cp-ksqldb-bootstrap.zone_id
#     evaluate_target_health = true
#   }
# }