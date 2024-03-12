# Event Hubs Namespace
resource "azurerm_eventhub_namespace" "sign-in" {
  name                = "entra-sign-in-events-namespace"
  location            = azurerm_resource_group.entra-events.location
  resource_group_name = azurerm_resource_group.entra-events.name
  sku                 = "Standard" //qaz later we'll try to use "Basic"
  capacity            = 1
}

# Event Hub
resource "azurerm_eventhub" "sign-in" {
  name                = "entra-sign-in-events"
  namespace_name      = azurerm_eventhub_namespace.sign-in.name
  resource_group_name = azurerm_resource_group.entra-events.name
  partition_count     = 2
  message_retention   = 1
}

# Shared Access Policy (Authorization Rule)
resource "azurerm_eventhub_authorization_rule" "send_policy" {
  namespace_name      = azurerm_eventhub_namespace.sign-in.name
  eventhub_name       = azurerm_eventhub.sign-in.name
  resource_group_name = azurerm_resource_group.entra-events.name
  name                = "SendPolicy"
  send                = true
}

# Entra ID Diagnostic Setting
resource "azurerm_monitor_diagnostic_setting" "entra_events" {
  name                           = "entra-events-diag"
  target_resource_id             = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.AAD/diagnosticSettings/entra_events-diag"
  eventhub_authorization_rule_id = azurerm_eventhub_authorization_rule.send_policy.id
  eventhub_name                  = azurerm_eventhub.sign-in.name
  enabled_log {
    category = "SignInLogs"
  }
}


# Reference the Azure Active Directory (Entra) tenant 
data "azurerm_client_config" "current" {}
