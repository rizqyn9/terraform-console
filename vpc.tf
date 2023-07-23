# Create a VPC
resource "google_compute_network" "vpc" {
  name                    = "vpc"
  auto_create_subnetworks = "false"
}

# Create a Subnet
resource "google_compute_subnetwork" "private" {
  name          = "${var.env}-subnet-private"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.vpc.name
  region        = var.region
}

resource "google_compute_subnetwork" "public" {
  name          = "${var.env}-subnet-public"
  ip_cidr_range = "10.20.0.0/24"
  network       = google_compute_network.vpc.name
  region        = var.region
}

# Create a firewall to allow SSH connection from the specified source range
resource "google_compute_firewall" "rules" {
  project = var.project
  name    = "allow-ssh"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

## Create Cloud Router
resource "google_compute_router" "router" {
  project = var.project
  name    = "nat-router"
  network = google_compute_network.vpc.name
  region  = var.region
}
