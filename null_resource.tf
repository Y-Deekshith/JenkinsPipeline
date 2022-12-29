resource "null_resource" "docker_deploy" {
  provisioner "local-exec" {
    command = <<EOF
    echo "${aws_instance.web-1.public_ip}" > publicip.txt
    EOF
  }
}