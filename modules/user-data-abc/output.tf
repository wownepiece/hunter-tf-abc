output "rendered-cloud-init-data" {
  description = "cloudinit data"
  value       = data.cloudinit_config.scout.rendered
}
