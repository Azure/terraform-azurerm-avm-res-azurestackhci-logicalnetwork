terraform {
  required_version = "~> 1.5"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "0000000-0000-00000-000000"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# This is required for resource modules
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azapi_resource" "customlocation" {
  type      = "Microsoft.ExtendedLocation/customLocations@2021-08-15"
  name      = var.custom_location_name
  parent_id = data.azurerm_resource_group.rg.id
}

# This is the module call
# Do not specify location here due to the randomization above.
# Leaving location as `null` will cause the module to use the resource group location
# with a data source.
module "test" {
  source = "../../"
  # source             = "Azure/avm-res-azurestackhci-logicalnetwork/azurerm"
  # version = "~> 0.1.0"

  location = data.azurerm_resource_group.rg.location
  name     = var.logical_network_name

  enable_telemetry   = var.enable_telemetry # see variables.tf
  resource_group_id  = data.azurerm_resource_group.rg.id
  custom_location_id = data.azapi_resource.customlocation.id
  vm_switch_name     = "ConvergedSwitch(managementcomputestorage)"

  ip_allocation_method = "Static"
  starting_address     = "192.168.200.0"
  ending_address       = "192.168.200.255"
  default_gateway      = "192.168.200.1"

  dns_servers    = ["192.168.200.222"]
  address_prefix = "192.168.200.0/24"

  logical_network_tags = {
    environment = "development"
  }
}
