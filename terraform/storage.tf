resource "azurerm_storage_account" "frontend" {
  name                     = "pkdemoappfesa01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account_static_website" "frontend" {
  storage_account_id = azurerm_storage_account.frontend.id
  index_document     = "index.html"
  error_404_document = "index.html"
}

resource "azurerm_storage_blob" "frontend_files" {
  for_each               = fileset("frontend", "**/*")
  name                   = each.value
  storage_account_name   = azurerm_storage_account.frontend.name
  storage_container_name = "$web"
  type                   = "Block"
  source                 = "frontend/${each.value}"
  content_type = lookup(
    {
      html = "text/html"
      js   = "application/javascript"
      css  = "text/css"
      png  = "image/png"
      jpg  = "image/jpeg"
      svg  = "image/svg+xml"
    },
    split(".", each.value)[length(split(".", each.value)) - 1],
    "application/octet-stream"
  )
  depends_on = [azurerm_storage_account_static_website.frontend]
}
