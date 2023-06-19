# resource "null_resource" "push" {
  
# }
resource "null_resource" "build" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name ${module.codebuild-ci.name}"
  }
}