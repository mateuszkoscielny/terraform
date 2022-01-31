# Configure the Azure provider
terraform {
  required_version = ">= 1.1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  backend "azurerm" {
    resource_group_name  = "TerraformTestRG"
    storage_account_name = "mkterraformstate"
    container_name       = "terraform-state"
    key                  = "terraformstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.env_type}-rg"
  location = var.region
  tags = {
      Environment = var.env_type
      Team = "DevOps"
  }
}
