# projects
namespace    = "personal"
region       = "us-west-2"
project-name = "scout"

# key file
ssh_key             = ""
ssh-key-name        = "aws.personal.N.CA"
local-key-file-path = ".."

# network infrastuctures
primary-cidr-block                = "172.18.0.0/16"
primary-subnet-public-cidr-block  = "172.18.16.0/24"
primary-subnet-private-cidr-block = "172.18.17.0/24"

# consul
consul-data-dir = "/mnt/consul/data/"
consul-configs = {
  config-dir           = "/mnt/consul/config",
  config-file          = "/mnt/consul/config/server.hcl",
  data-dir             = "/mnt/consul/data/",
  datacenter           = "default-dc",       # default value, change on launch
  node-name            = "consul-node-name", # default value, change on launch
  log-level            = "info",
  log-file             = "/mnt/consul/log",
  log-rotate-bytes     = 200000000,
  log-rotate-max-files = 10,
  log-rotate-duration  = "24h"
}
consul-server-ip-pools = [
  "172.18.16.118",
  "172.18.16.119",
  "172.18.16.117"
]
