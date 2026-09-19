output "static_web_app_api_key" {
  description = "Deployment token for the Static Web App. Used by the SWA CLI (or later, a CI pipeline) to push builds. Treat as a secret."
  value       = azurerm_static_web_app.main.api_key
  sensitive   = true
}

output "function_app_default_hostname" {
  description = "The *.azurewebsites.net hostname of the Function App. Used to build the counter API URL for the front end."
  value       = azurerm_linux_function_app.main.default_hostname
}
