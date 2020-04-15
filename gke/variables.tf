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

variable "gke_pod_ipv4_cidr_block" {
  default     = "10.28.0.0/14"
}

variable "gke_service_ipv4_cidr_block" {
  default     = "10.92.0.0/20"
}

variable "region" {
  default      = "us-east4"
}

variable "zone" {
  default     = "us-east4-a"
}