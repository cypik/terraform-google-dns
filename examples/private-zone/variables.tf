variable "project_id" {
  description = "Project id where the zone will be created."
  type        = string
  default     = "opz0-397319"
}



variable "name" {
  description = "DNS zone name."
  type        = string
  default     = "foo-local"
}

variable "domain" {
  description = "Zone domain."
  type        = string
  default     = "foo.local."
}

variable "labels" {
  type        = map(any)
  description = "A set of key/value label pairs to assign to this ManagedZone"
  default = {
    owner   = "foo"
    version = "bar"
  }
}
