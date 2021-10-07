variable "workspace_id" {
    description = "Azure Workspace ID in the form: /subscriptions/[Subscription ID]/resourceGroups/[Resource Group]/providers/Microsoft.OperationalInsights/workspaces/[Log Analytics Workspace ID]"
}

variable "storageacct_id" {
    description = "Azure Workspace ID in the form: /subscriptions/[Subscription ID]/resourceGroups/[Resource Group]/providers/Microsoft.Storage/storageAccounts/[Storage Account Name/ID]"
}

variable "storageacct_threshold_bytes" {
    description = "Azure Storage Account capacity threshold for alerting in bytes"
}

variable "storageacct_region" {
    default = "eastus"
    description = "Azure Storage Account region"
}

variable "client_name" {
    description = "Name of the client"
}