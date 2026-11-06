mock_provider "azapi" {
  mock_resource "azapi_resource" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/hci-test/providers/Microsoft.AzureStackHCI/logicalNetworks/network-test"
    }
  }
}

mock_provider "azurerm" {}
mock_provider "modtm" {}
mock_provider "random" {}

variables {
  custom_location_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/hci-test/providers/Microsoft.ExtendedLocation/customLocations/hci-test"
  enable_telemetry   = false
  location           = "eastus"
  name               = "network-test"
  resource_group_id  = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/hci-test"
  vm_switch_name     = "ConvergedSwitch(managementcomputestorage)"
}

run "dynamic_network" {
  command   = apply
  state_key = "dynamic_network"

  providers = {
    azapi   = azapi
    azurerm = azurerm
    modtm   = modtm
    random  = random
  }

  assert {
    condition     = azapi_resource.logical_network.parent_id == var.resource_group_id && azapi_resource.logical_network.body.extendedLocation.name == var.custom_location_id
    error_message = "The logical network must retain its resource group and HCI custom location."
  }

  assert {
    condition     = azapi_resource.logical_network.body.properties.subnets[0].properties.ipAllocationMethod == "Dynamic" && !contains(keys(azapi_resource.logical_network.body.properties.subnets[0].properties), "ipPools")
    error_message = "Dynamic allocation must not send a static IP pool."
  }

  assert {
    condition     = output.resource_id == azapi_resource.logical_network.id && length(azurerm_management_lock.this) == 0
    error_message = "The resource ID must remain unchanged and no lock should be created by default."
  }
}

run "static_network_with_lock" {
  command   = apply
  state_key = "static_network"

  providers = {
    azapi   = azapi
    azurerm = azurerm
    modtm   = modtm
    random  = random
  }

  variables {
    address_prefix       = "192.168.200.0/24"
    default_gateway      = "192.168.200.1"
    dns_servers          = ["192.168.200.222"]
    ending_address       = "192.168.200.255"
    ip_allocation_method = "Static"
    starting_address     = "192.168.200.0"
    subnet_0_name        = "hci-subnet"
    vlan_id              = "200"
    lock = {
      kind = "CanNotDelete"
    }
  }

  assert {
    condition     = azurerm_management_lock.this[0].scope == azapi_resource.logical_network.id
    error_message = "The management lock must target the full logical network ARM ID, not its bare name."
  }

  assert {
    condition     = azurerm_management_lock.this[0].name == "lock-CanNotDelete" && azurerm_management_lock.this[0].lock_level == "CanNotDelete"
    error_message = "The lock name and level must preserve their existing semantics."
  }

  assert {
    condition     = azapi_resource.logical_network.body.properties.subnets[0].name == "hci-subnet" && azapi_resource.logical_network.body.properties.subnets[0].properties.vlan == 200
    error_message = "The subnet name and numeric VLAN must be preserved."
  }

  assert {
    condition     = azapi_resource.logical_network.body.properties.subnets[0].properties.addressPrefix == "192.168.200.0/24" && azapi_resource.logical_network.body.properties.subnets[0].properties.ipPools[0].start == "192.168.200.0" && azapi_resource.logical_network.body.properties.subnets[0].properties.ipPools[0].end == "192.168.200.255"
    error_message = "The configured static subnet and IP pool bounds must be preserved."
  }

  assert {
    condition     = length(azapi_resource.logical_network.body.properties.dhcpOptions.dnsServers) == 1 && azapi_resource.logical_network.body.properties.dhcpOptions.dnsServers[0] == "192.168.200.222" && azapi_resource.logical_network.body.properties.subnets[0].properties.routeTable.properties.routes[0].properties.nextHopIpAddress == "192.168.200.1"
    error_message = "The DNS servers and default gateway must be preserved."
  }
}
