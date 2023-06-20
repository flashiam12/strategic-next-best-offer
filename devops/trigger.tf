# resource "null_resource" "push" {
#   count = var.aws_trigger_ci == true ? 1: 0
#   triggers = {
#     always_run = "${timestamp()}"
#   }
#   provisioner "local-exec" {
#     command = "git add apps/ && git commit -m  'commit from terraform workflow' && git push"
#   }
# }

resource "null_resource" "build" {
  count = var.aws_trigger_ci == true ? 1: 0
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "git add apps/ && git commit -m  'commit from terraform workflow' && git push & aws codebuild start-build --project-name ${module.codebuild-ci.name}"
  }
}