resource "azurerm_app_service_plan" "frontend" {
  name                = "pk-demoapp-ne-asp01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}
