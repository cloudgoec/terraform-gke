terraform {
  backend "gcs" {
    bucket      = "cloudgoec-terraform-state"
    prefix      = "terraform/state"
    credentials = "../../credentials/cloudgoec.json"
  }
}