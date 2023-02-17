data "aws_region" "current" {}
data "cloudinit_config" "scout" {
  gzip          = false
  base64_encode = true
  # check cloudinit_config
  part {
    content_type = "text/cloud-config"
    content = templatefile(
      "${path.module}/cloud-config.yaml.tftpl",
      {
        "node-name"            = var.consul-configs.node-name,
        "datacenter"           = data.aws_region.current.name,
        "data-dir"             = var.consul-configs.data-dir,
        "log-level"            = var.consul-configs.log-level,
        "log-file"             = var.consul-configs.log-file,
        "log-rotate-bytes"     = var.consul-configs.log-rotate-bytes,
        "log-rotate-duration"  = var.consul-configs.log-rotate-duration,
        "log-rotate-max-files" = var.consul-configs.log-rotate-max-files,
        "config-dir"           = var.consul-configs.config-dir,
        "config-file"          = var.consul-configs.config-file
      }
    )
    filename = "hunter.yaml"
  }
  # check script
  part {
    content_type = "text/x-shellscript"
    filename     = "hunter.sh"
    content      = "echo \"Hello World.  The time is now $(date -R)!\" | tee /output.txt"
  }
  # check multi script files
  part {
    content_type = "text/x-shellscript"
    filename     = "hunter-another.sh"
    content      = "echo \"Hello World.  The time is now $(date -R)!\" | tee /output.another.txt"
  }
  # install telegraf
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
  # install hashicorp
  part {
    content_type = "text/x-shellscript"
    filename     = "install-consul.sh"
    content      = <<-HEREDOC
yum install -y yum-utils shadow-utils
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
yum -y install consul nomad
consul -autocomplete-install
nomad -autocomplete-install
HEREDOC
  }

  # install tools
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
