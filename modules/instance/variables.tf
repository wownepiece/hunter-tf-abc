variable "namespace" {
  type = string
}

variable "project_name" {
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

variable "vpc" {
    type = any

}


