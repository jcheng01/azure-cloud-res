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
