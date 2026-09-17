output "static_web_app_api_key" {
  description = "Deployment token for the Static Web App. Used by the SWA CLI (or later, a CI pipeline) to push builds. Treat as a secret."
  value       = azurerm_static_web_app.main.api_key
  sensitive   = true
}
