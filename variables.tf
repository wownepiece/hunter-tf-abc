
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

variable "ssh-key-name" {
  default = "ssh key name for ec2 ssh login"
  type    = string
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

variable "consul-configs" {
  type = map(any)
  default = {
    config-dir  = "/maverick/consul/config",
    config-file = "/maverick/consul/config/server-config.json",
    data-dir    = "/mnt/consul/data/",
    datacenter  = "default",          # default value, change on launch
    node-name   = "consul-node-name", # default value, change on launch
    log-level   = "info",
  }
  nullable = false
}


