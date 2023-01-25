output "private-ip" {
  value = module.instance.private-ip
}

output "public-ip" {
  value = module.instance.public-ip
}

output "instance-key-name" {
  value = module.instance.key-name
}

output "instance" {
  value = module.instance.instance
}
