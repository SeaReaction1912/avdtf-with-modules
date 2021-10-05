variable "peering_name" {
  description = "VNET Peering Name"
  default     = "avd-net-to-client-net"
}

variable "client_net_id" {
  description = "/subscriptions/[Subscription ID]/resourceGroups/[Resource Group Name]/providers/Microsoft.Network/virtualNetworks/[Virtual Network Name]' format"
}