output "private-ip" {
  value = module.instance.private-ip
}

output "public-ip" {
  value = module.instance.public-ip
}

output "instance-key-name" {
  value = module.instance.ssh-key-name
}

output "instance" {
  value = module.instance.instance
}
output "ssh-cmds" {
  # value = "ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -i ../${module.instance.scouts[*].key_name} ec2-user@${module.instance.scouts[*].public_ip}"
  value = {
    for k, v in module.instance.scouts : v.tags_all.Name => "ssh -oStrictHostKeyChecking=no -oUserKnownHostsFile=/dev/null -i ../${v.key_name}.pem ec2-user@${v.public_ip}"
  }
}

