module "network-infrastructure" {
  source       = "./modules/network-infrastructure"
  namespace    = var.namespace
  project_name = var.project_name
}
module "instance" {
  source       = "./modules/instance"
  namespace    = var.namespace
  project_name = var.project_name
  ssh_key      = var.ssh_key
  scout-sg     = module.network-infrastructure.scout-sg
  vpc          = module.network-infrastructure.vpc
}
