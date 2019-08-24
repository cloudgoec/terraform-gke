variable "environment" {
  default = "development"
}

variable "organization" {
  default = "pichincha"
}

variable "project" {
  default = "credit"
}

variable "private_subnet_cidr" {
  default = "10.10.1.0/24"
}

variable "public_subnet_cidr" {
  default = "10.10.2.0/24"
}

variable "network_self_link" {
  default = ""
}

variable "region" {
  default = "us-east4"
}