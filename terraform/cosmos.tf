resource "azurerm_cosmosdb_account" "main" {
  name                = var.cosmos_account_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB" # Core (SQL) API

  # Only one Cosmos DB account per subscription can have this discount
  # (1000 RU/s + 25GB storage, permanently free). Verified none exists yet.
  free_tier_enabled = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = azurerm_resource_group.main.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "main" {
  name                = "cloud-resume"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name

  # Shared across all containers in this database. 400 RU/s is the
  # minimum and comfortably inside the 1000 RU/s free-tier allowance.
  throughput = 400
}

resource "azurerm_cosmosdb_sql_container" "counter" {
  name                = "Counter"
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  database_name       = azurerm_cosmosdb_sql_database.main.name
  partition_key_paths = ["/id"]
}

# Grants the Function App's managed identity data-plane access to read/write
# documents in this Cosmos account, instead of using a connection string/key.
resource "azurerm_cosmosdb_sql_role_assignment" "function" {
  resource_group_name = azurerm_resource_group.main.name
  account_name        = azurerm_cosmosdb_account.main.name
  role_definition_id  = "${azurerm_cosmosdb_account.main.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = azurerm_linux_function_app.main.identity[0].principal_id
  scope               = azurerm_cosmosdb_account.main.id
}
