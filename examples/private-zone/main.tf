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
##### dns-private-zone module call.
#####==============================================================================
module "dns_private_zone" {
  source     = "../.."
  project_id = var.project_id
  type       = "private"
  name       = var.name
  domain     = var.domain
  labels     = var.labels

  private_visibility_config_networks = [module.vpc.self_link]

  recordsets = [
    {
      name = "ns"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name = ""
      type = "NS"
      ttl  = 300
      records = [
        "ns.${var.domain}",
      ]
    },
    {
      name = "localhost"
      type = "A"
      ttl  = 300
      records = [
        "127.0.0.1",
      ]
    },
    {
      name = ""
      type = "MX"
      ttl  = 300
      records = [
        "1 localhost.",
      ]
    },
    {
      name = ""
      type = "TXT"
      ttl  = 300
      records = [
        "\"v=spf1 -all\"",
      ]
    },
  ]
}
