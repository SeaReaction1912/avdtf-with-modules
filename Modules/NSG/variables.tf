variable "tag_env" {
  description = "The environment tag"
  default     = {environment = "RR AVD"}
}

variable "nsg_name" {
  description = "Network Security Group Name"
  default     = "avd-net-nsg"
}

variable "rg_name" {
  description = "Resource Group Name"
}

variable "rg_location" {
  description = "Resource Group Location"
}

variable "vnet_subnet_id" {
  description = "VNET0 subnet ID"
}

variable "vnets" {
  description = "All VNETs"
}