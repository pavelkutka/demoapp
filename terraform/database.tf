resource "azurerm_mysql_flexible_server" "mysql" {
  name                   = "pk-demoapp-ne-mysql01"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  administrator_login    = "demoadm"
  administrator_password = "MySQL4dm!n"
  sku_name               = "B_Standard_B1ms"
  version                = "8.0.21"

  delegated_subnet_id = azurerm_subnet.dbsubnet.id
  private_dns_zone_id = azurerm_private_dns_zone.mysqlpdns.id

  backup_retention_days = 7
}

resource "azurerm_mysql_flexible_database" "db" {
  name                = "demoapp"
  resource_group_name = azurerm_mysql_flexible_server.mysql.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql.name
  charset             = "utf8mb3"
  collation           = "utf8mb3_unicode_ci"

  depends_on = [azurerm_private_dns_zone_virtual_network_link.mysqlpdnslink]
}
