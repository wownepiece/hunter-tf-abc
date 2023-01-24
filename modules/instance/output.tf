
output "key-name" {
	value = aws_key_pair.ssh-file.key_name
}

output "private-ip" {
	value = aws_instance.zealot.private_ip
}

output "public-ip" {
	value = aws_instance.zealot.public_ip
}
