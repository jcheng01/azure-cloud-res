variable "location" {
  description = "Azure region for all resources. Static Web Apps are only available in a subset of regions (e.g. eastus2, centralus, westus2, westeurope, eastasia)."
  type        = string
  default     = "eastus2"
}

variable "resource_group_name" {
  description = "Name of the resource group that contains the resume site resources."
  type        = string
  default     = "rg-cloud-resume"
}

variable "static_web_app_name" {
  description = "Name of the Static Web App. Must be globally unique within Azure."
  type        = string
  default     = "swa-cloud-resume"
}

variable "cosmos_account_name" {
  description = "Name of the Cosmos DB account. Must be globally unique within Azure."
  type        = string
  default     = "cosmos-cloud-resume-910aba"
}

variable "function_app_name" {
  description = "Name of the Function App. Must be globally unique within Azure (becomes part of its *.azurewebsites.net URL)."
  type        = string
  default     = "func-cloud-resume-910aba"
}

variable "function_storage_account_name" {
  description = "Name of the storage account used internally by the Function App's runtime. Must be globally unique within Azure."
  type        = string
  default     = "stfunccr910aba"
}

variable "function_location" {
  description = "Azure region for the Function App, its Service Plan, and its runtime storage account. Separate from var.location because this subscription has 0 Y1 (Consumption plan) quota in eastus2 but available quota in centralus."
  type        = string
  default     = "centralus"
}
