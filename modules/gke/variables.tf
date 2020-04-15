variable "environment" {}

variable "organization" {}

variable "project" {}

variable "network_self_link" {}

variable "private_subnet_self_link" {}

variable "zone" {}

variable "gke_cluster_name" {}

variable "gke_master_cidr_block" {}

variable "gke_node_pools" {}

variable "gke_k8s_version" {}

/*
  Default node pool config
*/
variable "default_preemptible" {}
variable "default_machine_type" {}
variable "default_disk_size_gb" {}
variable "default_disk_type" {}