provider "google" {
  project = "local-concord-408802"
  region  = "asia-northeast1"
  zone    = "asia-northeast1-a"
}

#####==============================================================================
##### vpc module call.
#####==============================================================================
module "vpc" {
  source                                    = "cypik/vpc/google"
  version                                   = "1.0.1"
  name                                      = "app"
  environment                               = "test"
  routing_mode                              = "REGIONAL"
  network_firewall_policy_enforcement_order = "AFTER_CLASSIC_FIREWALL"
}


#####==============================================================================
##### dns-peering-zone module call.
#####==============================================================================
module "dns_peering_zone" {
  source                             = "../../"
  type                               = "peering"
  name                               = "app-test"
  environment                        = "peering"
  domain                             = "foo.local."
  visibility                         = "private"
  private_visibility_config_networks = [module.vpc.self_link]
  target_network                     = ""
  labels = {
    owner   = "foo"
    version = "bar"
  }
}
