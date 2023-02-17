# default
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

# consul
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


# nomad
resource "aws_security_group" "nomad" {
  name        = "${var.namespace}-${var.project-name}-nomad"
  description = "nomad security group"
  vpc_id      = var.vpc-id
  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    "Name" = "nomad-sg"
  }
}

resource "aws_security_group_rule" "httpapi-ui" {
  description       = "allow nomad http api and ui"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 4646
  to_port           = 4646
  security_group_id = aws_security_group.nomad.id
}

resource "aws_security_group_rule" "rpc" {
  description       = "allow nomad rpc"
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 4647
  to_port           = 4647
  security_group_id = aws_security_group.nomad.id
}
resource "aws_security_group_rule" "gossip-tcp" {
  description       = "allow nomad sef Wan gossip, need tcp & udp "
  type              = "ingress"
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 4648
  to_port           = 4648
  security_group_id = aws_security_group.nomad.id
}

resource "aws_security_group_rule" "gossip-udp" {
  description       = "allow nomad sef Wan gossip, need tcp & udp "
  type              = "ingress"
  protocol          = "udp"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 4648
  to_port           = 4648
  security_group_id = aws_security_group.nomad.id
}

# resource "aws_security_group_rule" "dynamic-ports" {
#   description       = "for tasks ask for dynamic ports"
#   type              = "ingress"
#   protocol          = "-1"
#   from_port         = 20000
#   to_port           = 32000
#   self              = true
#   security_group_id = aws_security_group.nomad.id
# }
