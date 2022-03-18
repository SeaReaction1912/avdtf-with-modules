variable "rg_tag" {
  type        = any
  description = "The environment tag"
  default     = {environment = "RR AVD"}
}

variable "rg_name" {
  description = "Resource Group Name"
  default     = "avd-rg-eastus"
}

variable "rg_location" {
  description = "Resource Group Location"
  default     = "East US"
}