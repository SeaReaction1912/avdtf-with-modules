variable "workspace_id" {
    description = "Azure Workspace ID in the form: /subscriptions/[Subscription ID]/resourceGroups/[Resource Group]/providers/Microsoft.OperationalInsights/workspaces/[Log Analytics Workspace ID]"
}

variable "storageacct_id" {
    description = "Azure Workspace ID in the form: /subscriptions/[Subscription ID]/resourceGroups/[Resource Group]/providers/Microsoft.Storage/storageAccounts/[Storage Account Name]/ID]"
}

variable "storageacct_threshold_bytes" {
    description = "Azure Storage Account capacity threshold for alerting in bytes"
}

variable "client_name" {
    description = "Name of the client"
}

variable rg_name {
  description = "RG0 Name"
}

variable rg_id {
  description = "RG0 ID"
}

variable rg_location {
  description = "RG0 Location"
}