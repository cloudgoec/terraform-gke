provider "google" {
  credentials = file("../../credentials/cloudgoec.json")
  project     = "cloudgoec"
  region      = "us-east4"
}

provider "google-beta" {
  credentials = file("../../credentials/cloudgoec.json")
  project     = "cloudgoec"
  region      = "us-east4"
}

module "vpc" {
  source                    = "../modules/vpc"
  environment               = terraform.workspace
  organization              = var.organization
  project                   = var.project
  public_subnet_cidr        = var.public_subnet_cidr
  private_subnet_cidr       = var.private_subnet_cidr
}


module "subnet" {
  source                    = "../modules/subnet"
  network_self_link         = module.vpc.network_self_link
  environment               = terraform.workspace
  organization              = var.organization
  project                   = var.project
  public_subnet_cidr        = var.public_subnet_cidr
  private_subnet_cidr       = var.private_subnet_cidr
  region                    = var.region
}


module "gke" {
  source                    = "../modules/gke"
  environment               = terraform.workspace
  organization              = var.organization
  project                   = var.project
  network_self_link         = module.vpc.network_self_link
  private_subnet_self_link  = module.subnet.out_private_subnet_self_link
  zone                      = var.zone
  gke_cluster_name          = "gke"
  gke_limit_cpu_max         = "8"
  gke_limit_cpu_min         = "5"
  gke_limit_memory_max      = "20"
  gke_limit_memory_min      = "15"
  gke_master_cidr_block     = "172.16.0.16/28"
  gke_node_pools = [
    {
      machine_type       = "n1-highcpu-2"
      min_node_count     = 1
      max_node_count     = 3
      node_count         = 1
      disk_size_gb       = 10
      preemptible        = true
    },{
      machine_type       = "n1-standard-1"
      min_node_count     = 2
      max_node_count     = 4
      node_count         = 3
      disk_size_gb       = 10
      preemptible        = true
    },
  ]
}