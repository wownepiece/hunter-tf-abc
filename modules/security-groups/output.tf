output "scout-sg" {
  value = aws_security_group.scout.id
}
output "consul-sg" {
  value = aws_security_group.consul-sg.id
}
