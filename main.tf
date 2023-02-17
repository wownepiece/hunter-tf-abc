module "gen-localkey" {
  source       = "./modules/gen-localkey"
  namespace    = var.namespace
  project-name = var.project-name
  local-path   = var.local-key-file-path
}
module "network-infrastructure" {
  source                            = "./modules/network-infrastructure"
  namespace                         = var.namespace
  project-name                      = var.project-name
  primary-cidr-block                = var.primary-cidr-block
  primary-subnet-private-cidr-block = var.primary-subnet-private-cidr-block
  primary-subnet-public-cidr-block  = var.primary-subnet-public-cidr-block
}

module "security-groups" {
  source       = "./modules/security-groups"
  namespace    = var.namespace
  project-name = var.project-name
  vpc-id       = module.network-infrastructure.primary-vpc.id
}

module "user-data" {
  source         = "./modules/user-data-abc"
  namespace      = var.namespace
  project-name   = var.project-name
  consul-configs = var.consul-configs

}
module "instance" {
  source                 = "./modules/instance"
  namespace              = var.namespace
  project-name           = var.project-name
  ssh_key                = var.ssh_key # ssh-key-name           = var.ssh-key-name
  ssh-key-name           = module.gen-localkey.key-name
  scout-sg               = module.security-groups.scout-sg
  consul-sg              = module.security-groups.consul-sg
  primary-vpc            = module.network-infrastructure.primary-vpc
  primary-public-subnet  = module.network-infrastructure.primary-public-subnet
  consul-configs         = var.consul-configs
  consul-server-ip-pools = var.consul-server-ip-pools
  cloud-init-data        = module.user-data.rendered-cloud-init-data
}
