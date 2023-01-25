locals {
  subnet_ips = {
    public  = "172.31.186.0/24"
    private = "172.31.187.0/24"
  }
}

resource "aws_default_vpc" "default" {}

data "aws_region" "current" {}

resource "aws_subnet" "public" {
  vpc_id                  = aws_default_vpc.default.id
  cidr_block              = local.subnet_ips.public
  availability_zone       = "${data.aws_region.current.name}a"
  map_public_ip_on_launch = true
  tags = {
    Name : "subnet-hello-world",
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_default_vpc.default.id
}
resource "aws_route_table_association" "public2private" {
  route_table_id = aws_default_vpc.default.default_route_table_id
  subnet_id      = aws_subnet.public.id
}

resource "aws_security_group" "scout" {
  name        = "${var.namespace}-${var.project_name}"
  description = "allow 22 & 443 public access"
  vpc_id      = aws_default_vpc.default.id
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
  cidr_blocks = [ "0.0.0.0/0" ]
  from_port = 22
  to_port           = 22
  security_group_id = aws_security_group.scout.id
}


resource "aws_security_group_rule" "allow_443" {
  description       = "allow https access"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  from_port = 443
  to_port           = 443
  security_group_id = aws_security_group.scout.id
}
