module "network-infrastructure" {
  source                            = "./modules/network-infrastructure"
  namespace                         = var.namespace
  project-name                      = var.project-name
  primary-cidr-block                = var.primary-cidr-block
  primary-subnet-private-cidr-block = var.primary-subnet-private-cidr-block
  primary-subnet-public-cidr-block  = var.primary-subnet-public-cidr-block
}
module "instance" {
  source                = "./modules/instance"
  namespace             = var.namespace
  project-name          = var.project-name
  ssh_key               = var.ssh_key
  scout-sg              = module.network-infrastructure.scout-sg
  primary-vpc           = module.network-infrastructure.primary-vpc
  primary-public-subnet = module.network-infrastructure.primary-public-subnet
  cloud-config-msg      = { msg : "HunterHunter" }
  telegraf-tag          = {tag:"scout-metrics"}

}
