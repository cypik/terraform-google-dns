provider "google" {
  project = "opz0-397319"
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
##### dns-peering-zone module call.
#####==============================================================================
module "dns_peering_zone" {
  source                             = "../.."
  project_id                         = "opz0-397319"
  type                               = "peering"
  name                               = "foo-local"
  domain                             = "foo.local."
  private_visibility_config_networks = [module.vpc.self_link]
  target_network                     = ""
  labels = {
    owner   = "foo"
    version = "bar"
  }
}