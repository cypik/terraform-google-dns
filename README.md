# Terraform-gcp-dns
# Google Cloud Infrastructure Provisioning with Terraform

## Table of Contents

- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [Examples](#examples)
- [License](#license)


## Introduction

This project deploys a Google Cloud infrastructure using Terraform to create Dns .


## Usage

To use this module, include it in your Terraform configuration. Below is an example of how to call the DNS module and its dependencies.
### Examples

## Example: _Forwarding_
```hcl
module "dns_forwarding_zone" {
  source                             = "git::https://github.com/cypik/terraform-gcp-dns.git?ref=v1.0.0"
  type                               = "forwarding"
  name                               = "app-test"
  environment                        = "forwarding-zone"
  visibility                         = "private"
  domain                             = var.domain
  labels                             = var.labels
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
```
## Example: _Peering_

```hcl
module "dns_peering_zone" {
  source                             = "git::https://github.com/cypik/terraform-gcp-dns.git?ref=v1.0.0"
  type                               = "peering"
  name                               = "app-test"
  environment                        = "peering-zone"
  domain                             = "foo.local."
  visibility                         = "private"
  private_visibility_config_networks = [module.vpc.self_link]
  target_network                     = ""
  labels = {
    owner   = "foo"
    version = "bar"
  }
}
```

## Example: _Private_

```hcl
module "dns_private_zone" {
  source                             = "git::https://github.com/cypik/terraform-gcp-dns.git?ref=v1.0.0"
  type                               = "private"
  name                               = "app-test"
  environment                        = "private-zone"
  visibility                         = "private"
  domain                             = var.domain
  labels                             = var.labels
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
```
## Example: _Public_

```hcl
module "dns_public_zone" {
  source                             = "git::https://github.com/cypik/terraform-gcp-dns.git?ref=v1.0.0"
  type                               = "public"
  name                               = "app-test"
  environment                        = "public-zone"
  visibility                         = "public"
  domain                             = var.domain
  labels                             = var.labels
  private_visibility_config_networks = [module.vpc.self_link]
  enable_logging                     = true

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

```
## Example: _Dns-Response-Policy_
```hcl
module "dns_response_policy" {
  source             = "../../modules/dns_response_policy"
  policy_name        = "dns-test"
  name               = "app-test"
  environment        = "response-policy"
  network_self_links = [module.vpc.self_link]
  description        = "Example DNS response policy created by terraform module cypik."

  rules = {
    "override-google-com" = {
      dns_name = "*.google.com."
      rule_local_datas = {
        "A" = { # Record type.
          rrdatas = ["192.0.2.91"]
          ttl     = 300
        },
        "AAAA" = {
          rrdatas = ["2001:db8::8bd:1002"]
          ttl     = 300
        }
      }
    },
    "override-withgoogle-com" = {
      dns_name = "withgoogle.com."
      rule_local_datas = {
        "A" = {
          rrdatas = ["193.0.2.93"]
          ttl     = 300
        }
      }
    },
    "bypass-google-account-domain" = {
      dns_name      = "account.google.com."
      rule_behavior = "bypassResponsePolicy"
    }
  }
}
```

This example demonstrates how to create various GCP resources using the provided modules. Adjust the input values to suit your specific requirements.

## Module Inputs

Here are the inputs accepted by this module:

- `provider`: Configuration for the Google Cloud provider.
- `network_self_links`: The URI of the created resource.
- `rules`: An identifier for this rule.
- `domain`: The DNS name (wildcard or exact) to apply this rule to.
- `lables`:  A set of key/value label pairs to assign to this ManagedZone.
- `name`: The name of the instance template.
- `environment`: The environment (e.g., "test").
- `region`: The GCP region.
- `project_id`: The GCP project ID.
- `private_visibility_config`: For privately visible zones.
- `target_name_server_addresses`: List of target name servers to forward to.
- `target_network`: The network with which to peer.
- `type`: dns-zone type .
- `enable_logging`: If set, enable query logging for this ManagedZone.


## Module Outputs

This module provides the following outputs:

- `id`: An identifier for the resource with format.
- `response_policy_rule_ids`: List of response rules with format.
- `name_servers`: Delegate your managed_zone to these virtual name servers; defined by the server
- `creation_time`: The combination of labels configured directly on the resource and default labels configured on the provider.
- `managed_zone_id` : An identifier for the resource with format.

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/cypik/terraform-gcp-dns/tree/master/examples) directory within this repository.

## License
This Terraform module is provided under the **'[License Name]'** License. Please see the [LICENSE](https://github.com/cypik/terraform-gcp-dns/blob/master/LICENSE) file for more details.

## Author
Your Name
Replace **'[License Name]'** and **'[Your Name]'** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.
