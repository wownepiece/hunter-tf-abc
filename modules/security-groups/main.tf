resource "aws_security_group" "scout" {
  name        = "${var.namespace}-${var.project-name}"
  description = "allow 22 & 443 public access"
  vpc_id      = var.vpc-id
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }
  tags = {
    "Name" = "scout-common"
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


resource "aws_security_group" "consul-sg" {
  name        = "${var.namespace}-${var.project-name}-consul"
  description = "consul security group"
  vpc_id      = var.vpc-id
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "consul-sg"
  }
}
resource "aws_security_group_rule" "allow-8300" {
  description       = "allow access to consul services"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8300
  to_port           = 8300
  security_group_id = aws_security_group.consul-sg.id
}

resource "aws_security_group_rule" "allow-8500" {
  description       = "allow access to consul http api"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8500
  to_port           = 8500
  security_group_id = aws_security_group.consul-sg.id

}

resource "aws_security_group_rule" "self-access" {
  description       = "allow internal self access"
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  self              = true
  security_group_id = aws_security_group.consul-sg.id

}
