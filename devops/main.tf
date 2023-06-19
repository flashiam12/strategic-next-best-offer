data "aws_caller_identity" "current" {}

data "aws_eks_cluster_auth" "cluster" {
    name = var.aws_eks_cluster_name
}
data "aws_eks_cluster" "cluster" {
    name = var.aws_eks_cluster_name
}