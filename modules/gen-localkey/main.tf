resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key-file" {
  key_name   = "${var.project-name}-key"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "instance_keys" {
  filename        = "${var.local-path}/${aws_key_pair.key-file.key_name}.pem"
  file_permission = "0400"
  content         = tls_private_key.private_key.private_key_pem
}
