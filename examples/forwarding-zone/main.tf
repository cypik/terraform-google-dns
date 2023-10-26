provider "google" {
  project = var.project_id
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### vpc module call.
#####==============================================================================
module "vpc" {
  source                                    = "git::git@github.com:opz0/terraform-gcp-vpc.git?ref=master"
  name                                      = "app"
  environment                               = "test"
  label_order                               = ["name", "environment"]
  project_id                                = "opz0-397319"
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  auto_create_subnetworks                   = true
}

#####==============================================================================
##### dns-forwarding-zone module call.
#####==============================================================================
module "dns_forwarding_zone" {
  source     = "../.."
  project_id = var.project_id
  type       = "forwarding"
  name       = var.name
  domain     = var.domain
  labels     = var.labels

  private_visibility_config_networks = [module.vpc.self_link]
  target_name_server_addresses = [
    {
      ipv4_address    = "8.8.8.8",
      forwarding_path = "default"
    },
    {
      ipv4_address    = "8.8.4.4",
      forwarding_path = "default"
    }
  ]
}