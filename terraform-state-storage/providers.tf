terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # This config's own state stays local, permanently. It has to — this is
  # the config that CREATES the remote backend the main terraform/ config
  # uses, so it can't depend on that backend existing yet. Never migrate
  # this one.
  backend "local" {}
}

provider "azurerm" {
  features {}
}
