variable "project_id" {
  type        = string
  description = "The ID of the project in which the DNS response policy needs to be created."
}

variable "description" {
  type        = string
  description = "The description of the response policy."
}

variable "network_self_links" {
  type        = list(string)
  description = "The self links of the network to which the dns response policy needs to be applied. Note that only one response policy can be applied on a network."
  default     = []
}

variable "rules" {
  type = map(object({
    dns_name      = string
    rule_behavior = optional(string)
    rule_local_datas = optional(map(object({
      ttl     = string
      rrdatas = list(string)
    })))
  }))
  description = <<EOF

  EOF
}

variable "policy_name" {
  type        = string
  description = "Name of the DNS response policy."
}
