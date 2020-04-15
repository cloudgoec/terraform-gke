resource "google_container_cluster" "gke-kubernetes" {
  provider            = "google"
  name                = "${var.environment}-${var.organization}-${var.project}-${var.gke_cluster_name}"
  location            = var.zone
  network             = var.network_self_link
  subnetwork          = var.private_subnet_self_link
  min_master_version  = var.gke_k8s_version

  remove_default_node_pool = true
  initial_node_count       = 1

  logging_service          = "logging.googleapis.com/kubernetes"
  monitoring_service       = "monitoring.googleapis.com/kubernetes"

  /*
    Configuracion de nodepools por defecto
  */
  node_config {
    preemptible  = var.default_preemptible
    machine_type = var.default_machine_type
    disk_size_gb = var.default_disk_size_gb
    disk_type    = var.default_disk_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/devstorage.read_only", // activar esta api para que el cluster pueda acceder sin auth a GCR private images
    ]
  }

  /*
    Ventana de mantenimiento
  */
  maintenance_policy {
    daily_maintenance_window {
      start_time = "04:30"
    }
  }

  /*
    Enable private nodes
  */
  private_cluster_config {
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_master_cidr_block //"172.16.0.16/28"
    enable_private_endpoint = false
  }

  /*
    Acceso a los masters por IP
  */
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block    = "0.0.0.0/0"
      display_name  = "All"
    }
  }

  addons_config {

    http_load_balancing {
      disabled = false
    }
  }

  ip_allocation_policy {
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
    /*
      Esto indica que GCE puede terminar esta instancia en cualquier momento, similar a las spot instances en AWS
  */
    preemptible  = lookup(var.gke_node_pools[count.index], "preemptible")
    machine_type = lookup(var.gke_node_pools[count.index], "machine_type")
    disk_size_gb = lookup(var.gke_node_pools[count.index], "disk_size_gb")
    disk_type    = lookup(var.gke_node_pools[count.index], "disk_type")

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/monitoring.write",
      "https://www.googleapis.com/auth/devstorage.read_only", // activar esta api para que el cluster pueda acceder sin auth a GCR private images
    ]
  }

  /*
    LIMITE DE INSTANCIAS EN AUTOSCALING QUE PUEDE TENER EL NODE POOL
    El node pool va a auescalar en instancias menores al maximo y mayores o iguales al minimo
    intances < max_node_count && instances >= min_node_count
  */
  autoscaling {
    max_node_count = lookup(var.gke_node_pools[count.index], "max_node_count")
    min_node_count = lookup(var.gke_node_pools[count.index], "min_node_count")
  }

  depends_on = [
    "google_container_cluster.gke-kubernetes"
  ]

  management {
    auto_upgrade = true
  }
}