data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ssh-file" {
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "instance_keys" {
  filename        = "../${aws_key_pair.ssh-file.key_name}.pem"
  file_permission = "0400"
  content         = tls_private_key.private_key.private_key_pem
}

resource "aws_instance" "zealot" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.ssh-file.key_name
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
  }
  private_dns_name_options {
    hostname_type = "resource-name"
  }
  tags = {
    Name = "CheckInstance"
  }
}

