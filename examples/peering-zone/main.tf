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
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
  auto_create_subnetworks                   = true
}

#####==============================================================================
##### dns-peering-zone module call.
#####==============================================================================
module "dns_peering_zone" {
  source                             = "../.."
  type                               = "peering"
  name                               = "test"
  environment                        = "dns-peering-zone"
  domain                             = "foo.local."
  private_visibility_config_networks = [module.vpc.self_link]
  target_network                     = ""
  labels = {
    owner   = "foo"
    version = "bar"
  }
}