output "primary-vpc" {
  value = aws_vpc.primary
}


output "primary-public-subnet" {
  value = aws_subnet.public
}
