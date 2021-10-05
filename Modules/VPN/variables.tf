variable "tag_env" {
  description = "The environment tag"
  default     = "RR AVD"
}

variable "vpn_net_name" {
  description = "The VPN VNET Name"
  default = "avd-net-vpn"
}

variable "avd_vpn_cidr" {
  description = "The AVD VPN Network Address Space in CIDR format"
  default     = "10.254.254.0/24"
}

variable "avd_vpn_gw_net" {
  description = "The AVD VPN Gateway Subnet in CIDR format"
  default     = "10.254.254.0/24"
}

variable "vpn_pip_name" {
  description = "The VPN VNET Public IP Name"
  default = "avd-net-vpn-pip"
}

variable "vpn_gw_name" {
  description = "The VPN Gateway Name"
  default = "avd-net-vpngw"
}

variable "client_local_gw_pip" {
  description = "The Client's Local Gateway Public IP address"
}

variable "client_local_gw_name" {
  description = "The Client's Local Gateway Name"
  default = "client_local_gw"
}

variable "client_internal_subnet" {
  description = "The Client's internal subnet to be connected with VPN"
}

variable "vpn_to_client_gw1_psk" {
  description = "The Client's internal subnet to be connected with VPN"
}

variable "vpn_connection_name" {
  description = "The VPN Connection to Client Name"
  default = "avd-vpn-to-client"
}

variable "rtable_name" {
  description = "The Route Table Name"
  default = "avd-net-rtable"
}