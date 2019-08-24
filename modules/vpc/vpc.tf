resource "google_compute_network" "gcn-vpc" {
  name                      = "${var.environment}-${var.organization}-${var.project}-gcn-vpc"
  auto_create_subnetworks   = "false"
  routing_mode              = "REGIONAL"
}
