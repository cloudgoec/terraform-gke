variable "project" {
  default     = "course"
  description = "Nombre del Producto"
}

variable "organization" {
  default     = "cloudgoec"
}

variable "private_subnet_cidr" {
  default     = "10.10.1.0/24"
}

variable "public_subnet_cidr" {
  default     = "10.10.2.0/24"
}

variable "region" {
  default      = "us-east4"
}

variable "zone" {
  default     = "us-east4-a"
}