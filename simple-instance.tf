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
        name = "terraform"
        machine_type = "e2-medium"
        zone = "us-central1-c"
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
