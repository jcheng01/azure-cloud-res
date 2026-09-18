resource "azurerm_resource_group" "tfstate" {
  name     = "rg-tfstate"
  location = "eastus2"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfstatec391f9d1"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

resource "azurerm_storage_container" "tfstate" {
  name               = "tfstate"
  storage_account_id = azurerm_storage_account.tfstate.id
}
