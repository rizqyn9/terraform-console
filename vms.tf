# Create a VM in the above subnet
resource "google_compute_instance" "private" {
  count        = 2
  project      = var.project
  zone         = var.zone
  name         = "${var.env}-private-${count.index}"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.private.name
  }
}

# Create a VM in the above subnet
resource "google_compute_instance" "public" {
  count        = 1
  project      = var.project
  zone         = var.zone
  name         = "${var.env}-public-${count.index}"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network    = google_compute_network.vpc.name
    subnetwork = google_compute_subnetwork.public.name

    access_config {

    }
  }
}
