data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "scouts" {
  count         = 3
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = var.ssh-key-name
  subnet_id     = var.primary-public-subnet.id

  # temporary comment out for testing purposes
  # private_ip                  = var.consul-server-ip-pools[count.index]
  user_data                   = var.cloud-init-data
  user_data_replace_on_change = true
  vpc_security_group_ids = [
    var.scout-sg,
    var.consul-sg
  ]

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 1
    http_tokens                 = "optional"
    instance_metadata_tags      = "enabled"
  }
  private_dns_name_options {
    hostname_type = "ip-name"
  }

  tags = {
    Name = "scout-${count.index + 1}"
  }
}

