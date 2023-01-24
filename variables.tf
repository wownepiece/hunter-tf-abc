
variable "region" {
  description = "AWS Region"
  default     = "us-west-1" # N.CA
  type        = string
}


variable "namespace" {
  description = "Project namespace"
  type        = string
}


variable "project_name" {
  description = "the name of project"
  type        = string
}


variable "ssh_key" {
  description = "public key for ec2 ssh login"
  type        = string

}
