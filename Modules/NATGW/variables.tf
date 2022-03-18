variable "natgw_pip_name" {
  description = "NAT Gateway Public IP Name"
  default     = "avd-net-natgw-pip"
}

variable "natgw_name" {
  description = "NAT Gateway Name"
  default     = "avd-net-natgw"
}

variable "rg_name" {
  description = "Resource Group Name"
}

variable "rg_location" {
  description = "Resource Group Location"
}

variable "vnet_subnet_id" {
  description = "All Subnet ID 0"
}

variable vnets {
  description = "All VNETs"
}
