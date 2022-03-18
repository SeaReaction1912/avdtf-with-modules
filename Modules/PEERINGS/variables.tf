variable "peering_name" {
  description = "VNET Peering Name"
  default     = "avd-net-to-client-net"
}

variable "client_net_id" {
  description = "/subscriptions/[Subscription ID]/resourceGroups/[Resource Group Name]/providers/Microsoft.Network/virtualNetworks/[Virtual Network Name]' format"
}

variable "rg_name" {
  description = "Resource Group Name"
}

variable "vnet_name" {
  description = "VNET Name"
}

variable "peering_name1" {
  description = "VNET Peering Name"
  default     = "local-net-to-avd-net"
}

variable "client_net_id1" {
  description = "/subscriptions/[Subscription ID]/resourceGroups/[Resource Group Name]/providers/Microsoft.Network/virtualNetworks/[Virtual Network Name]' format"
}

variable "vnet_name1" {
  description = "VNET Name"
}

variable "vnets" {
  description = "All VNETs"
}
