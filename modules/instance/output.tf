
output "ssh-key-name" {
  value = var.ssh-key-name
}

output "private-ip" {
  value = aws_instance.scouts[*].private_ip
}

output "public-ip" {
  value = aws_instance.scouts[*].public_ip
}

output "instance" {
  value = {
    state      = aws_instance.scouts[*].instance_state
    id         = aws_instance.scouts[*].id
    private_ip = aws_instance.scouts[*].private_ip
    public_ip  = aws_instance.scouts[*].public_ip
  }
}
