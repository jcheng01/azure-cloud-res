resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_static_web_app" "main" {
  name                = var.static_web_app_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  sku_tier            = "Free"
  sku_size            = "Free"

  # Deliberately no repository_url / repository_branch / repository_token.
  # Deployment will be done manually (Phase 1 style) or via the SWA CLI
  # using the api_key output, until CI/CD is wired up in Phase 4.
}
