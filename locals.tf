locals {
  role_definition_resource_substring = "/providers/Microsoft.Authorization/roleDefinitions"
  route_0 = {
    name = var.route_name
    properties = {
      addressPrefix    = "0.0.0.0/0",
      nextHopIpAddress = var.default_gateway
    }
  }
  route_0_omit_null   = { for k, v in local.route_0 : k => v if v != null }
  subnet_0_properties = { for k, v in local.subnet_0_properties_full : k => v if v != null }
  subnet_0_properties_full = {
    addressPrefix      = var.ip_allocation_method == "Dynamic" ? null : var.address_prefix # compute from starting address and ending address
    ipAllocationMethod = var.ip_allocation_method
    ipPools = var.ip_allocation_method == "Dynamic" ? null : [{
      info  = {}
      start = var.starting_address
      end   = var.ending_address
    }]
    vlan = var.vlan_id == null ? null : tonumber(var.vlan_id)
    routeTable = var.ip_allocation_method == "Dynamic" ? null : {
      properties = {
        routes = [
          local.route_0_omit_null
        ]
      }
    }
  }
}
