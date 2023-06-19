output "aws_ops_vpc_id" {
  value = module.ops-vpc.vpc_id
}
output "aws_ops_eks_cluster_name" {
  value = module.eks.cluster_name
}
output "aws_ops_eks_node_group_role_arn" {
  value = aws_iam_role.node.arn
}