# Entra ID Diagnostic Setting
resource "azurerm_monitor_diagnostic_setting" "entra_events" {
  name = "entra-events-diag"
  //target_resource_id = "/providers/microsoft.aadiam/providers/microsoft.insights/diagnosticSettings/test-console-diag-settings"
  target_resource_id             = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/providers/Microsoft.AAD/diagnosticSettings/entra_events-diag"
  eventhub_authorization_rule_id = azurerm_eventhub_namespace_authorization_rule.send_policy.id
  eventhub_name                  = azurerm_eventhub.sign-in.name
  enabled_log {
    category = "SignInLogs"
  }
}


# Reference the Azure Active Directory (Entra) tenant 
data "azurerm_client_config" "current" {}
