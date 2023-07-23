provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

# Create a VPC
resource "google_compute_network" "vpc" {
  name                    = "lab-vpc"
  auto_create_subnetworks = "false"
}


# Create a Subnet
resource "google_compute_subnetwork" "my-custom-subnet" {
  name          = "my-custom-subnet-2"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.vpc.name
  region        = var.region
}


## Create a VM in the above subnet

resource "google_compute_instance" "my_vm" {
  project      = var.project
  zone         = "us-east4-c"
  name         = "nat-demo-vm"
  machine_type = "e2-medium"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = "my-custom-network-2"
    subnetwork = google_compute_subnetwork.my-custom-subnet.name # Replace with a reference or self link to your subnet, in quotes
  }
}

# Create a firewall to allow SSH connection from the specified source range
resource "google_compute_firewall" "rules" {
  project = var.project
  name    = "allow-ssh"
  network = "my-custom-network-2"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

## Create IAP SSH permissions for your test instance

resource "google_project_iam_member" "project1" {
  project = var.project
  role    = "roles/iap.tunnelResourceAccessor"
  member  = "serviceAccount:terraform-demo-aft@tcb-project-371706.iam.gserviceaccount.com"
}

## Create Cloud Router

resource "google_compute_router" "router" {
  project = var.project
  name    = "nat-router"
  network = "my-custom-network-2"
  region  = var.region
}

## Create Nat Gateway

resource "google_compute_router_nat" "nat" {
  name                               = "my-router-nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
