terraform {
        required_providers {
                google = {
                        source = "hashicorp/google"
                        version = "4.51.0"
                }
        }
}

provider "google" {
        credentials = file("service.json")
        project = "unified-freedom-399620"
}

resource "google_compute_instance" "terraform" {
        project = "unified-freedom-399620"
        count = 3
        name = "vm-terraform${count.index+1}"
        machine_type = "e2-medium"
        for_each = toset(["us-central-1", "europe-west4-a", "asia-southeast2-a"])
        zone = each.value
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

    tags = ["http-server", "https-server", "lb-health-check"]

    metadata_startup_script = "sudo apt-get update; sudo apt-get install nginx -y"
}
