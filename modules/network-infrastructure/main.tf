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
  subnet_id = aws_subnet.public.id
}


# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.primary.id
# }
# resource "aws_route_table_association" "public2private" {
#   route_table_id = aws_vpc.primary.default_route_table_id
#   subnet_id      = aws_subnet.public.id
# }
#


######################### Security Groups ###########################

resource "aws_security_group" "scout" {
  name        = "${var.namespace}-${var.project-name}"
  description = "allow 22 & 443 public access"
  vpc_id      = aws_vpc.primary.id
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }
}
resource "aws_security_group_rule" "allow_ssh" {
  description       = "allow ssh access"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  security_group_id = aws_security_group.scout.id
}


resource "aws_security_group_rule" "allow_443" {
  description       = "allow https access"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.scout.id
}
