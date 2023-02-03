namespace                         = "personal"
region                            = "us-west-1"
project-name                      = "scout"
ssh_key                           = ""
ssh-key-name                      = "aws.personal.N.CA"
consul-data-dir                   = "/mnt/consul/data/"
primary-cidr-block                = "172.18.0.0/16"
primary-subnet-public-cidr-block  = "172.18.16.0/24"
primary-subnet-private-cidr-block = "172.18.17.0/24"
consul-configs = {
  config-dir  = "/mnt/consul/config",
  config-file = "/mnt/consul/config/server.hcl",
  data-dir    = "/mnt/consul/data/",
  datacenter  = "default",          # default value, change on launch
  node-name   = "consul-node-name", # default value, change on launch
  log-level   = "info",
}
