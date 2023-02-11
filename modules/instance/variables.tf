variable "namespace" {
  type = string
}

variable "project-name" {
  type = string
}

variable "ssh_key" {
  description = "public key for ec2 ssh login"
  type        = string
}

variable "scout-sg" {
  description = "security group for scout common"
  type        = string
}
variable "consul-sg" {
  description = "security group for consul"
  type        = string
}

variable "primary-vpc" {
  type = any
}
variable "primary-public-subnet" {
  type = any

}
variable "ssh-key-name" {
  description = "ssh key name for ec2 ssh login"
  type        = string
}
variable "consul-configs" {
  type = map(any)
}

variable "consul-server-ip-pools" {
  type = list(string)
}
