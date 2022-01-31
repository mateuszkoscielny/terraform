variable "region" {
  type    = string
  default = "northeurope"
}
variable "prefix" {
  type    = string
  default = "demo"
}
variable "env_type" {
  type    = string
}

variable "ssh-source-address" {
  type    = string
  default = "*"
}

variable "private-cidr" {
  type    = string
  default = "10.0.0.0/24"
}