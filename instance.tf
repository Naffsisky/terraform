terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  credentials = file("service.json")
  project     = "unified-freedom-399620"
}

variable "zones" {
  default = ["us-central1-c", "europe-west4-a", "asia-southeast2-a"]
}

resource "google_compute_instance" "server" {
  for_each = toset(var.zones)
  name         = "server-terraform-${each.key}"
  machine_type = "e2-medium"
  zone         = each.key

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  tags                    = ["http-server", "https-server", "lb-health-check"]
  metadata_startup_script = "sudo apt-get update; sudo apt-get install nginx -y"
}

resource "google_compute_instance" "client" {
  count = 1
  name         = "client-terraform-${count.index + 1}"
  machine_type = "e2-micro"
  // zone         = var.zones[count.index % length(var.zones)]
  zone         = "asia-southeast2-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
