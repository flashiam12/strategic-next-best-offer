resource "aws_s3_bucket" "artifacts" {
  bucket_prefix = "hsbc-ops-artifacts"
  tags = {
    Terraform   = "true"
    Environment = "ops"
    Purpose     = "hsbc-ops-devops"
    Kind        = "strategic"
  }
}

resource "aws_s3_bucket_ownership_controls" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "artifacts" {
  depends_on = [ aws_s3_bucket_ownership_controls.artifacts ]
  bucket = aws_s3_bucket.artifacts.id
  acl    = "private"
}

# CodeBuild
module "codebuild-ci" {

  source = "lgallard/codebuild/aws"
  version = "0.5.3"
  name        = "hsbc-ops-apps-ci"
  description = "Codebuild for deploying hsbc ops apps"

  # CodeBuild Source
  codebuild_source_version = "main"

  codebuild_source_type                                   = "GITHUB"
  codebuild_source_location                               = "https://github.com/flashiam12/strategic-next-best-offer.git"
  codebuild_source_git_clone_depth                        = 1
  codebuild_source_git_submodules_config_fetch_submodules = true

  # Environment
  environment_compute_type    = "BUILD_GENERAL1_SMALL"
  environment_image           = "aws/codebuild/standard:2.0"
  environment_type            = "LINUX_CONTAINER"
  environment_privileged_mode = true

  # Environment
  environment_variables = [
      {
        name  = "REGISTRY_URL"
        value = module.ecr.repository_url
      },
      {
        name  = "AWS_DEFAULT_REGION"
        value = var.aws_region
      },
    ]

  # Artifacts
  artifacts = {
    location  = aws_s3_bucket.artifacts.bucket
    type      = "S3"
    path      = "/"
    packaging = "ZIP"
  }

  # Cache
  cache = {
    type     = "S3"
    location = aws_s3_bucket.artifacts.bucket
  }

  # Logs
  s3_logs = {
    status   = "ENABLED"
    location = "${aws_s3_bucket.artifacts.id}/build-log"
  }

  # Tags
  tags = {
    Terraform   = "true"
    Environment = "ops"
    Purpose     = "hsbc-ops-devops"
    Kind        = "strategic"
  }

}

