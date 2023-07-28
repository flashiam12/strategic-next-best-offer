output "aws_cc_cluster" {
  value = module.aws-cc.aws_cc_cluster
}
output "gcp_cc_cluster" {
  value = module.gcp-cc.gcp_cc_cluster
}
output "aws_cc_connectors" {
  value = module.aws-cc.aws_cc_connectors
}
output "gcp_cc_connectors" {
  value = module.gcp-cc.gcp_cc_connectors
}
output "aws_cc_topics" {
  value = module.aws-cc.aws_cc_topics
}
output "gcp_cc_topics" {
  value = module.gcp-cc.gcp_cc_topics
}
output "aws_cc_ksqldb" {
  value = module.aws-cc.aws_cc_ksql_cluster
}
output "gcp_cc_ksqldb" {
  value = module.gcp-cc.gcp_cc_ksql_cluster
}
output "aws_cc_api_key" {
  value = module.aws-cc.aws_cc_admin_api_key
}
output "aws_cc_api_secret" {
  value = module.aws-cc.aws_cc_admin_api_secret
}
output "gcp_cc_api_key" {
  value = module.gcp-cc.gcp_cc_admin_api_key
}
output "gcp_cc_api_secret" {
  value = module.gcp-cc.gcp_cc_admin_api_secret
}
output "confluent_sr_api_key" {
  value = confluent_api_key.env-manager-schema-registry-api-key.id
}
output "confluent_sr_api_secret" {
  value = confluent_api_key.env-manager-schema-registry-api-key.secret
}