locals {
    eks_cidr = "172.20.0.0/22"
    eks_vpc_partition = cidrsubnets(local.eks_cidr, 2, 2)
    eks_vpc_public_partition = cidrsubnets(local.eks_vpc_partition[0], 2, 2)
    eks_vpc = {
        private_subnets = cidrsubnets(local.eks_vpc_partition[1], 2, 2)
        public_subnets  = cidrsubnets(local.eks_vpc_public_partition[1], 2, 2)
        database_subnets = cidrsubnets(local.eks_vpc_public_partition[0], 2, 2)
        azs             = formatlist("${data.aws_region.current.name}%s", ["a", "b"])
    }
}

module "ops-vpc" {
  source            = "terraform-aws-modules/vpc/aws"
  name              = "eks-ops-vpc"
  azs               = local.eks_vpc.azs
  cidr              = local.eks_cidr
  private_subnets   = local.eks_vpc.private_subnets
  public_subnets    = local.eks_vpc.public_subnets
  database_subnets = local.eks_vpc.database_subnets
  enable_nat_gateway = true
  single_nat_gateway = true
  one_nat_gateway_per_az = false
  flow_log_file_format = "plain-text"
  public_subnet_tags = {
   "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
   "kubernetes.io/role/elb" = 1
   "kubernetes.io/role/internal-elb" = 1
  }
  # private_subnet_tags = {
  #   # "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
  # #  "kubernetes.io/role/elb" = 1
  #  "kubernetes.io/role/internal-elb" = "1"
  # }
  tags = {
    Terraform = "true"
    Environment = "ops"
    Purpose = "hsbc"
    Kind = "strategic"
    # "kubernetes.io/cluster/${local.eks_cluster_name}" = "owned"
  }
}