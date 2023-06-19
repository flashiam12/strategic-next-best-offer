# resource "null_resource" "push" {
  
# }
resource "null_resource" "build" {
  count = var.aws_trigger_ci == true ? 1: 0
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name ${module.codebuild-ci.name}"
  }
}