resource "google_compute_subnetwork" "subnet-private" {
  name                      = "${var.environment}-${var.organization}-${var.project}-subnet-private"
  ip_cidr_range             = var.private_subnet_cidr
  network                   = var.network_self_link
  region                    = var.region
}


resource "google_compute_router" "gcr-router" {
  name    = "${var.environment}-${var.organization}-${var.project}-gcr-router"
  region  = google_compute_subnetwork.subnet-private.region
  network = var.network_self_link

  bgp {
    asn = 64514
  }
}


resource "google_compute_router_nat" "gcrn-nat" {
  name                               = "${var.environment}-${var.organization}-${var.project}-gcrn-nat"
  router                             = google_compute_router.gcr-router.name
  region                             = google_compute_subnetwork.subnet-private.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = google_compute_subnetwork.subnet-private.self_link
    source_ip_ranges_to_nat = [
      "ALL_IP_RANGES"
    ]
  }
}