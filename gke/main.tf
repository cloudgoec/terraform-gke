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
  private_subnet_cidr       = var.private_subnet_cidr
  region                    = var.region
}

module "gke" {
  source                        = "../modules/gke"
  environment                   = terraform.workspace
  organization                  = var.organization
  project                       = var.project
  network_self_link             = module.vpc.network_self_link
  private_subnet_self_link      = module.subnet.out_private_subnet_self_link
  zone                          = var.zone
  gke_pod_ipv4_cidr_block       = var.gke_pod_ipv4_cidr_block
  gke_service_ipv4_cidr_block   = var.gke_service_ipv4_cidr_block
  gke_cluster_name              = "gke"
  gke_master_cidr_block         = "172.16.0.16/28"
  gke_k8s_version               = "1.13.7-gke.24"
  /*
    Default node pools
  */
  default_preemptible           = "true"
  default_machine_type          = "custom-4-8192"
  default_disk_size_gb          = "20"
  default_disk_type             = "pd-standard"
  /*
    Node pool config
  */
  gke_node_pools = [
    {
      machine_type       = "custom-4-8192"
      min_node_count     = 1
      max_node_count     = 4
      node_count         = 3
      disk_size_gb       = 20
      disk_type          = "pd-standard"
      preemptible        = true
    },
    #{
    #  machine_type       = "n1-standard-1"
    #  min_node_count     = 3
    #  max_node_count     = 6
    #  node_count         = 6
    #  disk_size_gb       = 10
    #  preemptible        = true
    #},
  ]
}