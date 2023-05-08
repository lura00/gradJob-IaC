# Declare the provider and its settings
provider "google" {
  project     = "<PROJECT_ID>"
  region      = "<REGION>"
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_FILE>")
}

# Create a new VPC network
resource "google_compute_network" "vpc_network" {
  name                    = "my-vpc-network"
  auto_create_subnetworks = false
}

# Create a new subnet in the VPC network
resource "google_compute_subnetwork" "subnet" {
  name          = "my-subnet"
  ip_cidr_range = "10.0.1.0/24"
  network       = google_compute_network.vpc_network.self_link
  region        = "<REGION>"
}

# Create a new firewall rule to allow incoming traffic to the VM instances
resource "google_compute_firewall" "firewall_rule" {
  name    = "allow-http-https-ssh"
  network = google_compute_network.vpc_network.self_link

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

# Create a new compute instance
resource "google_compute_instance" "vm_instance" {
  name         = "my-vm-instance"
  machine_type = "e2-medium"
  zone         = "<ZONE>"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.subnet.self_link
    access_config {
      # Allocate a public IP address to the instance
    }
  }

  metadata_startup_script = "apt-get update && apt-get install -y apache2"
}

