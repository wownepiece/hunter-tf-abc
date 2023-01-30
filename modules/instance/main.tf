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
  key_name   = "${var.project-name}-key"
  public_key = tls_private_key.private_key.public_key_openssh
}

resource "local_file" "instance_keys" {
  filename        = "../${aws_key_pair.ssh-file.key_name}.pem"
  file_permission = "0400"
  content         = tls_private_key.private_key.private_key_pem
}

data "aws_region" "current" {}

data "cloudinit_config" "scout" {
  gzip          = false
  base64_encode = false
  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloud-config.yaml.tftpl",
      {
        "consul-node-name"       = "consul-server-name",
        "consul-datacenter-name" = "dc-${data.aws_region.current.name}",
        "consul-data-dir"        = var.consul-data-dir
      }
    )
    filename = "hunter.yaml"
  }
  part {
    content_type = "text/x-shellscript"
    filename     = "hunter.sh"
    content      = "echo \"Hello World.  The time is now $(date -R)!\" | tee /output.txt"
  }
  part {
    content_type = "text/x-shellscript"
    filename     = "hunter-another.sh"
    content      = "echo \"Hello World.  The time is now $(date -R)!\" | tee /output.another.txt"
  }
  part {
    content_type = "text/x-shellscript"
    filename     = "start-telegraf.sh"
    content      = <<EOT
cat <<EOF | sudo tee /etc/yum.repos.d/influxdb.repo
[influxdb]
name = InfluxData Repository - Stable
baseurl = https://repos.influxdata.com/stable/\$basearch/main
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key
EOF
yum install -y telegraf
# modify telegraf configs
# mv /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.doc
# mv /etc/telegraf/telegraf.conf.custom /etc/telegraf/telegraf.conf
# TOKEN=`curl -X PUT -s "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
# sed -ire "s/\(hostname = \).*/\1\"$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/tags/instance/Name)\"/" /etc/telegraf/telegraf.conf
# systemctl reload-or-restart telegraf.service
# service telegraf start
EOT
  }
  part {
    content_type = "text/x-shellscript"
    filename     = "install-consul.sh"
    content      = <<-HEREDOC
yum install -y yum-utils shadow-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install consul nomad
HEREDOC
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "install-tools.sh"
    content      = <<-HEREDOC
amazon-linux-extras install epel
yum install epel-release -y
yum install iftop iotop -y
HEREDOC
  }

}

resource "aws_eip" "zealot" {
  instance = aws_instance.zealot.id
  vpc      = true
  tags = {
    "Name" = "scout-eip"
  }
}

resource "aws_instance" "zealot" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.ssh-file.key_name
  subnet_id     = var.primary-public-subnet.id

  user_data                   = data.cloudinit_config.scout.rendered
  user_data_replace_on_change = true # TODO: remove this line
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
    Name = "CheckInstance"
  }
}

