# TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.lock.kind}")
  scope      = var.name # TODO: Replace with your azurerm resource name
  notes      = var.lock.kind == "CanNotDelete" ? "Cannot delete the resource or its child resources." : "Cannot delete or modify the resource or its child resources."
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = data.azurerm_resource_group.rg.id # TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azapi_resource" "logical_network" {
  type = "Microsoft.AzureStackHCI/logicalNetworks@2023-09-01-preview"
  body = {
    extendedLocation = {
      name = var.custom_location_id
      type = "CustomLocation"
    }
    properties = {
      dhcpOptions = {
        dnsServers = flatten(var.dns_servers)
      }
      subnets = [{
        name       = "default"
        properties = local.subnet_0_properties
      }]
      vmSwitchName = var.vm_switch_name
    }
  }
  location  = var.location
  name      = var.name
  parent_id = var.resource_group_id

  lifecycle {
    ignore_changes = [
      body.properties.subnets[0].properties.ipPools[0].info,
    ]

    precondition {
      condition     = length(var.starting_address) > 0 && length(var.ending_address) > 0 && length(var.default_gateway) > 0 && length(var.dns_servers) > 0 && length(var.address_prefix) > 0
      error_message = "When not using existing logical network, starting_address, ending_address, default_gateway, dns_servers, address_prefix are required"
    }
  }
}
