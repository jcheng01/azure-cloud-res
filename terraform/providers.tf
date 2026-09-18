terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Remote state, provisioned once by terraform-state-storage/ (a separate
  # config with its own permanent local state — see that folder's comments
  # for why it isn't managed by this config). Auth uses the current Azure
  # AD session (az login) rather than a storage account access key.
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatec391f9d1"
    container_name       = "tfstate"
    key                  = "cloud-resume.tfstate"
    use_azuread_auth     = true
    tenant_id            = "bb46bcf7-a4ef-4d3b-930b-a9079819b960"
    subscription_id      = "62e0da42-37c5-4727-a0dd-34c0e5d1c92d"
  }
}

provider "azurerm" {
  features {}
}
