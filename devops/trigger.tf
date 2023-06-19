# resource "null_resource" "push" {
  
# }
resource "null_resource" "build" {
  provisioner "local-exec" {
    command = "aws codebuild start-build --project-name ${module.codebuild-ci.name}"
  }
}