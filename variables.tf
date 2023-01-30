
variable "region" {
  description = "AWS Region"
  default     = "us-west-1" # N.CA
  type        = string
}


variable "namespace" {
  description = "Project namespace"
  type        = string
}


variable "project-name" {
  description = "the name of project"
  type        = string
}


variable "ssh_key" {
  description = "public key for ec2 ssh login"
  type        = string

}

variable "primary-cidr-block" {
  type = string
}

variable "primary-subnet-private-cidr-block" {
  type = string

}
variable "primary-subnet-public-cidr-block" {
  type = string

}
variable "consul-data-dir" {
  type = string
}


