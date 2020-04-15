output "out_private_subnet_name" {
  value = google_compute_subnetwork.subnet-private.name
}


output "out_private_subnet_self_link" {
  value = google_compute_subnetwork.subnet-private.self_link
}