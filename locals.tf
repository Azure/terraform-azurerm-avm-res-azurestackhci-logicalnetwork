# TODO: insert locals here.
locals {
  managed_identities = {
    system_assigned_user_assigned = (var.managed_identities.system_assigned || length(var.managed_identities.user_assigned_resource_ids) > 0) ? {
      this = {
        type                       = var.managed_identities.system_assigned && length(var.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : length(var.managed_identities.user_assigned_resource_ids) > 0 ? "UserAssigned" : "SystemAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
    system_assigned = var.managed_identities.system_assigned ? {
      this = {
        type = "SystemAssigned"
      }
    } : {}
    user_assigned = length(var.managed_identities.user_assigned_resource_ids) > 0 ? {
      this = {
        type                       = "UserAssigned"
        user_assigned_resource_ids = var.managed_identities.user_assigned_resource_ids
      }
    } : {}
  }
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  subnet0Properties                  = { for k, v in local.subnet0PropertiesFull : k => v if v != null }
  subnet0PropertiesFull = {
    addressPrefix      = var.addressPrefix, //compute from starting address and ending address
    ipAllocationMethod = "Static",
    ipPools = [{
      info  = {}
      start = var.startingAddress
      end   = var.endingAddress
    }]
    vlan = var.vlanId == null ? null : tonumber(var.vlanId)
    routeTable = {
      properties = {
        routes = [
          {
            name = "default"
            properties = {
              addressPrefix    = "0.0.0.0/0",
              nextHopIpAddress = var.defaultGateway
            }
          }
        ]
      }
    }
  }
}
