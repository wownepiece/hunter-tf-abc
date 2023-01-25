
output "key-name" {
  value = aws_key_pair.ssh-file.key_name
}

output "private-ip" {
  value = aws_instance.zealot.private_ip
}

output "public-ip" {
  value = aws_instance.zealot.public_ip
}

output "instance" {
  value = {
    state      = aws_instance.zealot.instance_state
    id         = aws_instance.zealot.id
    private_ip = aws_instance.zealot.private_ip
    public_ip  = aws_instance.zealot.public_ip
  }
}
