data "aws_region" "current" {}

resource "aws_vpc" "primary" {

  cidr_block = var.primary-cidr-block

  instance_tenancy = "default"
  tags = {
    Name = "primary-${replace(basename(path.cwd), "_", "-")}"
  }

}

resource "aws_internet_gateway" "primary" {
  vpc_id = aws_vpc.primary.id
  tags = {
    "Name" = "hello world"
  }
}

resource "aws_route_table" "primary" {
  vpc_id = aws_vpc.primary.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.primary.id
  }
  tags = {
    Name = "Missing one piece"
  }


}
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = var.primary-subnet-public-cidr-block
  availability_zone       = "${data.aws_region.current.name}a"
  map_public_ip_on_launch = true
  tags = {
    Name : "primary-public-subnet",
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.primary.id
  cidr_block              = var.primary-subnet-private-cidr-block
  availability_zone       = "${data.aws_region.current.name}a"
  map_public_ip_on_launch = false
  tags = {
    Name : "primary-private-subnet"
  }

}

resource "aws_route_table_association" "primary" {
  route_table_id = aws_route_table.primary.id
  subnet_id      = aws_subnet.public.id
}


# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.primary.id
# }
# resource "aws_route_table_association" "public2private" {
#   route_table_id = aws_vpc.primary.default_route_table_id
#   subnet_id      = aws_subnet.public.id
# }
#

