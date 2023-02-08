provider "google" {
  credentials = file("/Users/dh/Desktop/devops-challenge/gorkem.json")
  project = "devops-377015"
  region = "europe-west1"
}
//VPC
resource "google_compute_network" "my-vpc" {
  name = "main"
  auto_create_subnetworks = false
  mtu = 1460
}
//Public Subnet(not needed)
resource "google_compute_subnetwork" "public-subnet" {
  name = "public-subnet-1"
  ip_cidr_range = "10.59.0.0/16"
  region = "europe-west1"
  network = google_compute_network.my-vpc.id
  private_ip_google_access = true
  stack_type = "IPV4_ONLY"
}
//Private Subnet with secondary IP ranges for k8s
resource "google_compute_subnetwork" "private-subnet" {
  name = "private-subnet-1"
  ip_cidr_range = "10.58.0.0/24"
  region = "europe-west1"
  network = google_compute_network.my-vpc.id
  private_ip_google_access = true
  stack_type = "IPV4_ONLY"

  secondary_ip_range {
    ip_cidr_range = "10.60.0.0/24"
    range_name = "k8s-pods"
  }
  secondary_ip_range {
    ip_cidr_range = "10.61.0.0/24"
    range_name = "k8s-service"
  }
}
//Router
resource "google_compute_router" "router" {
  name = "router"
  network = google_compute_network.my-vpc.id
  bgp {
    asn = 65414
    advertise_mode = "CUSTOM"
  }
}
//NAT GW for private subnet
resource "google_compute_router_nat" "nat" {
  name = "natgw"
  router = google_compute_router.router.name
  region = google_compute_router.router.region
  nat_ip_allocate_option = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name = google_compute_subnetwork.private-subnet.id
    source_ip_ranges_to_nat = [ "ALL_IP_RANGES" ]
  }
}
//8080 firewall rule
resource "google_compute_firewall" "ssh" {
  name = "k8s-hello-app-port"
  network = google_compute_network.my-vpc.name
  allow {
    protocol = "tcp"
    ports = [ "8080" ]
  }
  source_ranges = [ "0.0.0.0/0" ]
}
//k8s cluster
resource "google_container_cluster" "primary" {
  name = "primary"
  location = "europe-west1-b"
  remove_default_node_pool = true
  initial_node_count = 1
  network = google_compute_network.my-vpc.self_link
  subnetwork = google_compute_subnetwork.private-subnet.self_link
  networking_mode = "VPC_NATIVE"

  release_channel {
    channel = "REGULAR"
  }
  workload_identity_config {
    workload_pool = "devops-377015.svc.id.goog"
  }
  ip_allocation_policy {
    cluster_secondary_range_name = "k8s-pods"
    services_secondary_range_name = "k8s-service"
  }
  private_cluster_config {
    enable_private_nodes = true
    enable_private_endpoint = false
    master_ipv4_cidr_block = "172.31.26.0/28"
    master_global_access_config {
      enabled = true
    }
  }
}
resource "google_service_account" "kubernetes" {
  account_id = "kubernetes"
}
//Node pool for cluster with single node
resource "google_container_node_pool" "node-pool" {
  name = "node-pool"
  cluster = google_container_cluster.primary.id
  node_count = 1
  management {
    auto_repair = true
    auto_upgrade = true
  }
  node_config {
    preemptible = false
    machine_type = "e2-medium"

    labels = {
    role = "general"
    }
    service_account = "512384420084-compute@developer.gserviceaccount.com"
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}
