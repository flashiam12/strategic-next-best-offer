variable "aws_eks_cluster_name" {
  type = string
}
variable "aws_eks_node_group_arn" {
  type = string
}
variable "aws_region" {
  type = string
}
variable "aws_api_key" {
  type = string
}
variable "aws_api_secret" {
  type = string
}
variable "aws_trigger_ci" {
  type = bool
  default = true
}