module "instance" {
  source       = "./modules/instance"
  namespace    = var.namespace
  project_name = var.project_name
  ssh_key      = var.ssh_key
}
