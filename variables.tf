variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable "project_id" {
  description = "breakingbad-w-kbit"
}

variable "region" {
  description = "europe-west1"
}

variable "location" {
  description = "europe-west1-c"
}