variable "tag_env" {
  description = "The environment tag"
  default     = "RR AVD"
}

variable "vnet_name" {
  description = "The AVD Virtual Network Name"
  default     = "avd-net-eastus"
}

variable "subnet_name" {
  type = string
  description = "The AVD Virtual Network Subnet Name"
  default     = "avd-net-subnet"
}

variable "avd_net_eastus_cidr" {
  description = "The AVD VNET address space with CIDR"
  default     = "10.125.0.0/16"
}

variable "avd_net_eastus_subnet" {
  type = string
  description = "The AVD VNET subnet with CIDR"
  default     = "10.125.0.0/24"
}