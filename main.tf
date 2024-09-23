provider "google" {
  credentials = file("myfirstproject_gcp_GKE_SA_keys.json")
  project = "golden-system-436414-h2"
  region  = "asia-south1-a"
}

resource "google_container_cluster" "gke_cluster" {
  name     = "mytest-gke-cluster"
  location = "asia-south1-a"

  initial_node_count = 2

  node_config {
    machine_type = "e2-small"
  }
}


output "kubeconfig" {
  value = google_container_cluster.gke_cluster.endpoint
}

resource "google_compute_instance" "nginx_vm" {
  name         = "nginx-reverse-proxy"
  machine_type = "e2-small"
  zone         = "asia-south1-a"

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20240910"
    }
  }

  network_interface {
    network = "default"
    access_config {
      // Include this for an external IP
    }
  }

  metadata_startup_script = <<-EOT
    #! /bin/bash
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo 'server { listen 80; location / { proxy_pass http://34.49.134.117:80; } }' > /etc/nginx/sites-available/default
    systemctl restart nginx
  EOT
}

