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
  description = "security group for scout"
  type        = string
}

variable "primary-vpc" {
  type = any
}
variable "primary-public-subnet" {
  type = any

}
variable "cloud-config-msg" {
  type = map
}
variable "telegraf-tag" {
  type = map

}
