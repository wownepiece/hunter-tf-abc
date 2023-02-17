output "key-name" {
	description = "generated local key file name"
  value = aws_key_pair.key-file.key_name
}
