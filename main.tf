terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  project     = "vaulted-tower-328114"
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_compute_network" "vpc-network" {
  name = "terraform-network"
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = "f1-micro"
  tags         = ["demo"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.vpc-network.name
    access_config {}
  }
}

resource "google_compute_firewall" "firewall" {
  name    = "terraform-firewall"
  network = google_compute_network.vpc-network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }


  source_ranges = ["0.0.0.0/0"]
  target_tags = ["demo"]
}
