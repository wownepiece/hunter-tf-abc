output "vpc" {
  value = aws_default_vpc.default
}
output "scout-sg" {
  value = aws_security_group.scout.id
}
