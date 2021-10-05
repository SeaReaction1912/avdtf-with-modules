variable "tag_env" {
  description = "The environment tag"
  default     = "RR AVD"
}

variable "avd_domain_name" {
  description = "The AADDS Domain Name"
  default     = "avdcorp.net"
}

variable "vnet_name" {
  description = "The AVD Virtual Network Name"
  default     = "avd-net-eastus"
}

variable "subnet_name" {
  description = "The AVD Virtual Network Subnet Name"
  default     = "avd-net-subnet"
}

variable "avd_net_dns1" {
  description = "The AADDS DC1 DNS IP"
  default     = "10.125.0.4"
}

variable "avd_net_dns2" {
  description = "The AADDS DC2 DNS IP"
  default     = "10.125.0.5"
}