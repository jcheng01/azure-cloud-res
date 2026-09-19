# Required by Azure Functions for its own internal bookkeeping (triggers,
# deployment packages, lease management) — unrelated to site content or
# Terraform state. Uses its access key, since identity-based auth for a
# Function App's *own* runtime storage needs extra app settings beyond
# what's worth adding for this project.
resource "azurerm_storage_account" "function" {
  name                     = var.function_storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = var.function_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
}

# Consumption plan: pay per execution, scales to zero, no baseline cost.
resource "azurerm_service_plan" "function" {
  name                = "asp-cloud-resume"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.function_location
  os_type             = "Linux"
  sku_name            = "Y1"
}

resource "azurerm_linux_function_app" "main" {
  name                        = var.function_app_name
  resource_group_name         = azurerm_resource_group.main.name
  location                    = var.function_location
  service_plan_id             = azurerm_service_plan.function.id
  storage_account_name        = azurerm_storage_account.function.name
  storage_account_access_key  = azurerm_storage_account.function.primary_access_key
  functions_extension_version = "~4"
  https_only                  = true

  # Used to authenticate to Cosmos DB with no stored key/connection string —
  # see the role assignment in cosmos.tf.
  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    COSMOS_ENDPOINT  = azurerm_cosmosdb_account.main.endpoint
    COSMOS_DATABASE  = azurerm_cosmosdb_sql_database.main.name
    COSMOS_CONTAINER = azurerm_cosmosdb_sql_container.counter.name
  }

  site_config {
    application_stack {
      # Node 24 returned persistent 503s on this Consumption plan despite
      # being listed as supported — reverted to 22 (still current LTS,
      # not EOL like 20) after a restart didn't resolve it.
      node_version = "22"
    }

    # Allows the browser (running on the Static Web App's origin) to call
    # this Function App directly. Without this, the browser blocks the
    # response due to same-origin policy.
    cors {
      allowed_origins = ["https://${azurerm_static_web_app.main.default_host_name}"]
    }
  }

  # WEBSITE_RUN_FROM_PACKAGE and WEBSITE_MOUNT_ENABLED are added by the
  # `func azure functionapp publish` deploy step itself (it points the app
  # at the zip package it just uploaded). Terraform doesn't know about
  # those and would otherwise delete them on every apply, undeploying the
  # function code.
  lifecycle {
    ignore_changes = [
      app_settings["WEBSITE_RUN_FROM_PACKAGE"],
      app_settings["WEBSITE_MOUNT_ENABLED"],
    ]
  }
}
