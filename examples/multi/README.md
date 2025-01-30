<!-- BEGIN_TF_DOCS -->
# Multiple Logical Network Provisioning example

This deploys multiple logical networks.

```hcl
terraform {
  required_version = ">= 1.9, < 2.0"
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = "~> 1.13"
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
module "call1" {
  source = "../../"
  # source             = "Azure/avm-res-azurestackhci-logicalnetwork/azurerm"
  # version = "~> 0.1.0"

  location = data.azurerm_resource_group.rg.location
  name     = "lnetstatic"

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


module "call2" {
  source = "../../"
  # source             = "Azure/avm-res-azurestackhci-logicalnetwork/azurerm"
  # version = "~> 0.1.0"

  location = data.azurerm_resource_group.rg.location
  name     = "lnetdynamic"

  enable_telemetry   = var.enable_telemetry # see variables.tf
  resource_group_id  = data.azurerm_resource_group.rg.id
  custom_location_id = data.azapi_resource.customlocation.id
  vm_switch_name     = "ConvergedSwitch(managementcomputestorage)"

}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 1.13)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

## Resources

The following resources are used by this module:

- [azapi_resource.customlocation](https://registry.terraform.io/providers/azure/azapi/latest/docs/data-sources/resource) (data source)
- [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_custom_location_name"></a> [custom\_location\_name](#input\_custom\_location\_name)

Description: The name of the custom location.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_call1"></a> [call1](#module\_call1)

Source: ../../

Version:

### <a name="module_call2"></a> [call2](#module\_call2)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->