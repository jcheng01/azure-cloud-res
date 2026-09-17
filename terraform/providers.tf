terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Local state for now (the default backend). Kept explicit here as a
  # placeholder so it's obvious where this changes when we move to a
  # remote backend (Storage Account) in a later phase.
  backend "local" {}
}

provider "azurerm" {
  features {}
}
