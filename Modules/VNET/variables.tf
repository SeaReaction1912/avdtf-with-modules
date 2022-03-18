variable "tag_env" {
  description = "The environment tag"
  default     = {environment = "RR AVD"}
}

variable "rg_name" {
  description = "Resource Group Name"
}

variable "rg_location" {
  description = "Resource Group Location"
}

variable "vnet_dns1" {
  description = "DNS Server 1 IP Address"
}

variable "vnet_dns2" {
  description = "DNS Server 2 IP Address"
}

variable "vnets" {
  description = "VNETS"
}