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
  name                = "entra-sign-in-events-eventhub"
  namespace_name      = azurerm_eventhub_namespace.sign-in.name
  resource_group_name = azurerm_resource_group.entra-events.name
  partition_count     = 2
  message_retention   = 1
}

# Shared Access Policy (Authorization Rule)
resource "azurerm_eventhub_namespace_authorization_rule" "send_policy" {
  namespace_name = azurerm_eventhub_namespace.sign-in.name
  //eventhub_name       = azurerm_eventhub.sign-in.name
  resource_group_name = azurerm_resource_group.entra-events.name
  name                = "SendPolicy"
  send                = true
}
