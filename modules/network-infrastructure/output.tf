output "primary-vpc" {
  value = aws_vpc.primary
}
output "scout-sg" {
  value = aws_security_group.scout.id
}

output "primary-public-subnet" {
  value = aws_subnet.public
}
