resource "google_container_cluster" "gke-kubernetes" {
  provider   = "google-beta"
  name       = "${var.environment}-${var.organization}-${var.project}-${var.gke_cluster_name}"
  location   = var.zone
  network    = var.network_self_link
  subnetwork = var.private_subnet_self_link

  remove_default_node_pool = true
  initial_node_count = 1

  logging_service = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  cluster_autoscaling {
    enabled = true

    resource_limits {
      resource_type = "cpu"
      maximum       = var.gke_limit_cpu_max
      minimum       = var.gke_limit_cpu_min
    }

    resource_limits {
      resource_type = "memory"
      maximum       = var.gke_limit_memory_max
      minimum       = var.gke_limit_memory_min
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_master_cidr_block
    enable_private_endpoint = false
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block    = "0.0.0.0/0"
      display_name  = "All"
    }
  }

  addons_config {
    kubernetes_dashboard {
      disabled = true
    }

    http_load_balancing {
      disabled = false
    }
  }

  ip_allocation_policy {
    use_ip_aliases = true
  }

  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

resource "google_container_node_pool" "gke_node_pool" {
  count      = length(var.gke_node_pools)

  name       = "${var.environment}-${var.organization}-${var.project}-pool-${count.index}"
  location   = var.zone
  cluster    = google_container_cluster.gke-kubernetes.name
  node_count = lookup(var.gke_node_pools[count.index], "node_count")


  node_config {
    preemptible  = lookup(var.gke_node_pools[count.index], "preemptible")
    machine_type = lookup(var.gke_node_pools[count.index], "machine_type")
    disk_size_gb = lookup(var.gke_node_pools[count.index], "disk_size_gb")

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  }

  autoscaling {
    max_node_count = lookup(var.gke_node_pools[count.index], "max_node_count")
    min_node_count = lookup(var.gke_node_pools[count.index], "min_node_count")
  }

  depends_on = [
    "google_container_cluster.gke-kubernetes"
  ]
}