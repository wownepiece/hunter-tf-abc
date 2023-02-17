variable "namespace" {
  description = "Project namespace"
  type        = string
}
variable "project-name" {
  description = "the name of project"
  type        = string
}
variable "consul-configs" {
  type     = map(any)
  nullable = false
}
