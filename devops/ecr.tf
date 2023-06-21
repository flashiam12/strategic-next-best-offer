module "ecr" {
    source = "terraform-aws-modules/ecr/aws"

    repository_name = "hsbc-ops-docker-registry"
    
    repository_image_tag_mutability = "MUTABLE"
    repository_read_write_access_arns = [var.aws_eks_node_group_arn, data.aws_caller_identity.current.arn]
    repository_lifecycle_policy = jsonencode({
    rules = [
        {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
            tagStatus     = "tagged",
            tagPrefixList = ["v"],
            countType     = "imageCountMoreThan",
            countNumber   = 30
        },
        action = {
            type = "expire"
        }
        }
    ]
    })

    tags = {
        Terraform   = "true"
        Environment = "ops"
        Purpose     = "hsbc-ops-devops"
        Kind        = "strategic"
    }
}