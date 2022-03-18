resource "azurerm_monitor_action_group" "email" {
  name                = "Email Desk"
  resource_group_name = var.rg_name
  short_name          = "Email"

  email_receiver {
    name          = "Email"
    email_address = "etdevalerts@redriver.com"
    use_common_alert_schema = true
  }
}

resource "azurerm_monitor_activity_log_alert" "avd-service-health" {
  name                = "${var.client_name} - AVD Service Health"
  resource_group_name = var.rg_name
  scopes              = [var.rg_id]
  description         = "This alert will monitor AVD Service Health."

  criteria {
    category       = "ServiceHealth"
    service_health {
    events = [
      "Incident", 
      "ActionRequired", 
      "Security"
      ]
    locations = [
      "East US",
      "East US 2",
      "Global",
      "South Central US",
      "West US",
      "West US 2"
      ]
    services = ["Windows Virtual Desktop"]
  }
}

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "avd-no-resources" {
  name                = "${var.client_name} - AVD 'No available resources'"
  location            = var.rg_location
  resource_group_name = var.rg_name
  data_source_id      = var.workspace_id
  description         = "This alert will monitor AVD for error 'No Available Resources'."

  action {
    action_group      = [azurerm_monitor_action_group.email.id]
  }

  enabled             = true
  severity            = 1
  frequency           = 15
  time_window         = 15
  query               = <<-QUERY
WVDErrors
| where CodeSymbolic == "ConnectionFailedNoHealthyRdshAvailable" and Message contains "Could not find any SessionHost available in specified pool"
QUERY
  trigger {
    operator          = "GreaterThan"
    threshold         = 20
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "avd-host-mem-below-gb" {
  name                = "${var.client_name} - AVD Available Host Memory below 1GB"
  location            = var.rg_location
  resource_group_name = var.rg_name
  data_source_id      = var.workspace_id
  description         = "This alert will be triggered when Available Host Memory is less than 1GB."

  action {
    action_group      = [azurerm_monitor_action_group.email.id]
  }

  enabled             = true
  severity            = 2
  frequency           = 15
  time_window         = 15
  query               = <<-QUERY
Perf
| where ObjectName == "Memory"
| where CounterName == "Available Mbytes"
| where CounterValue <= 1024
QUERY
  trigger {
    operator          = "GreaterThanOrEqual"
    threshold         = 1
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "avd-failed-connections" {
  name                = "${var.client_name} - AVD Failed Connections"
  location            = var.rg_location
  resource_group_name = var.rg_name
  data_source_id      = var.workspace_id
  description         = "This alert will be triggered when there's more than 10 failed AVD connections in 15 minutes."

  action {
    action_group      = [azurerm_monitor_action_group.email.id]
  }

  enabled             = true
  severity            = 2
  frequency           = 5
  time_window         = 15
  query               = <<-QUERY
WVDConnections
| where State =~ "Started" and Type =~"WVDConnections"
| extend Multi=split(_ResourceId, "/") | extend CState=iff(SessionHostOSVersion=="<>","Failure","Success")
| where CState =~"Failure"
| order by TimeGenerated desc
| where State =~ "Started" | extend Multi=split(_ResourceId, "/")
| project ResourceAlias, ResourceGroup=Multi[4], HostPool=Multi[8], SessionHostName, UserName, CState=iff(SessionHostOSVersion=="<>","Failure","Success"), CorrelationId, TimeGenerated
| join kind= leftouter (WVDErrors) on CorrelationId
| extend DurationFromLogon=datetime_diff("Second",TimeGenerated1,TimeGenerated)
| project  TimeStamp=TimeGenerated, DurationFromLogon, UserName, ResourceAlias, SessionHost=SessionHostName, Source, CodeSymbolic, ErrorMessage=Message, ErrorCode=Code, ErrorSource=Source ,ServiceError, CorrelationId
| order by TimeStamp desc
QUERY
  trigger {
    operator          = "GreaterThanOrEqual"
    threshold         = 10
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "avd-fslogix-errors" {
  name                = "${var.client_name} - AVD FSLogix Errors"
  location            = var.rg_location
  resource_group_name = var.rg_name
  data_source_id      = var.workspace_id
  description         = "This alert will be triggered when there's more than 1 FSLogix Errors in 5 minutes."

  action {
    action_group      = [azurerm_monitor_action_group.email.id]
  }

  enabled             = true
  severity            = 2
  frequency           = 5
  time_window         = 5
  query               = <<-QUERY
Event 
| where EventID == "26" and isnotnull(Message) 
| where Message != "" 
| where UserName != "NT AUTHORITY\\SYSTEM" 
| order by TimeGenerated desc
QUERY
  trigger {
    operator          = "GreaterThanOrEqual"
    threshold         = 1
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "avd-out-of-memory" {
  name                = "${var.client_name} - AVD Host Out of Memory Errors"
  location            = var.rg_location
  resource_group_name = var.rg_name
  data_source_id      = var.workspace_id
  description         = "This alert will be triggered when there's more than 20 Out of Memory Errors in 30 minutes."

  action {
    action_group      = [azurerm_monitor_action_group.email.id]
  }

  enabled             = true
  severity            = 1
  frequency           = 5
  time_window         = 30
  query               = <<-QUERY
WVDErrors
| where CodeSymbolic == "OutOfMemory" and Message contains "The user was disconnected because the session host memory was exhausted."
QUERY
  trigger {
    operator          = "GreaterThanOrEqual"
    threshold         = 20
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "avd-high-cpu" {
  name                = "${var.client_name} - AVD Host Pct Proc Time Greater Than 99"
  location            = var.rg_location
  resource_group_name = var.rg_name
  data_source_id      = var.workspace_id
  description         = "This alert will be triggered when there's more than 50 High CPU alerts in 10 minutes."

  action {
    action_group      = [azurerm_monitor_action_group.email.id]
  }

  enabled             = true
  severity            = 1
  frequency           = 5
  time_window         = 10
  query               = <<-QUERY
Perf   
| where CounterName == "% Processor Time"
| where InstanceName == "_Total"
| where CounterValue >= 99
QUERY
  trigger {
    operator          = "GreaterThanOrEqual"
    threshold         = 50
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "avd-dwm-failures" {
  name                = "${var.client_name} - AVD DWM process access failure - User Connection Failure"
  location            = var.rg_location
  resource_group_name = var.rg_name
  data_source_id      = var.workspace_id
  description         = "This alert will be triggered when there's more than 20 Out of Memory Errors in 30 minutes."

  action {
    action_group      = [azurerm_monitor_action_group.email.id]
  }

  enabled             = true
  severity            = 1
  frequency           = 5
  time_window         = 15
  query               = <<-QUERY
WVDErrors
| where CodeSymbolic == "OutOfMemory" and Message contains "The user was disconnected because the session host memory was exhausted."
QUERY
  trigger {
    operator          = "GreaterThan"
    threshold         = 0
  }
}

resource "azurerm_monitor_metric_alert" "avd-sa-capacity" {
  name                  = "${var.client_name} - AVD Storage Account Capacity Alert"
  resource_group_name   = var.rg_name
  scopes                = [var.storageacct_id]
  description           = "Action will be triggered when Storage Account Capacity is close to full."
  enabled               = true
  frequency             = "PT5M"
  window_size           = "PT1H"
  severity              = 1
  target_resource_type  = "Microsoft.Storage/storageAccounts/fileServices"
  target_resource_location = var.rg_location

  criteria {
    metric_namespace = "microsoft.storage/storageaccounts/fileservices"
    metric_name      = "FileCapacity"
    aggregation      = "Average"
    operator         = "GreaterThanOrEqual"
    threshold        = var.storageacct_threshold_bytes

    dimension {
      name     = "FileShare"
      operator = "Include"
      values   = ["fshare"]
    }
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }
}
