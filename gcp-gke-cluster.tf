# Declare the provider and its settings
provider "google" {
  project     = "<PROJECT_ID>"
  region      = "<REGION>"
  credentials = file("<PATH_TO_SERVICE_ACCOUNT_FILE>")
}

# Create a new GKE cluster
resource "google_container_cluster" "gke_cluster" {
  name     = "my-gke-cluster"
  location = "<ZONE>"
  remove_default_node_pool = true

  node_pool {
    name       = "my-node-pool"
    machine_type = "e2-medium"
    disk_size_gb = 50
    node_count   = 3
    preemptible  = true
    auto_repair  = true
    auto_upgrade = true

    # Add labels and taints to the node pool if desired
    # labels = {
    #   env = "prod"
    # }
    # taint {
    #   key    = "special"
    #   value  = "true"
    #   effect = "NO_SCHEDULE"
    # }
  }

  master_auth {
    username = ""
    password = ""
  }

  # Use the latest version of Kubernetes
  # See https://cloud.google.com/kubernetes-engine/docs/release-notes for latest version
  min_master_version = "latest"
  node_version       = "latest"
}

# Configure kubectl to connect to the GKE cluster
resource "local_file" "kubeconfig" {
  filename = "./kubeconfig"
  content  = google_container_cluster.gke_cluster.master_auth.0.client_certificate.0.private_key.0
  sensitive_content = true
}

resource "null_resource" "kubectl_config" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.gke_cluster.name} --zone ${google_container_cluster.gke_cluster.location} --project ${var.project_id}"
  }
  depends_on = [local_file.kubeconfig]
}

