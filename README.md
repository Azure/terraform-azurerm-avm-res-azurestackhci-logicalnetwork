<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-res-azurestackhci-logical\_network

Module to provision azure stack hci logical networks.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.9, < 2.0)

- <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) (~> 1.13)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 4.0)

- <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) (~> 0.3)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azapi_resource.logical_network](https://registry.terraform.io/providers/azure/azapi/latest/docs/resources/resource) (resource)
- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [modtm_telemetry.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/resources/telemetry) (resource)
- [random_uuid.telemetry](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/uuid) (resource)
- [azurerm_client_config.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [modtm_module_source.telemetry](https://registry.terraform.io/providers/azure/modtm/latest/docs/data-sources/module_source) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_custom_location_id"></a> [custom\_location\_id](#input\_custom\_location\_id)

Description: The id of the Custom location that used to create hybrid aks

Type: `string`

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.

Type: `string`

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the logical network

Type: `string`

### <a name="input_resource_group_id"></a> [resource\_group\_id](#input\_resource\_group\_id)

Description: The resource group ID for the Azure Stack HCI logical network.

Type: `string`

### <a name="input_vm_switch_name"></a> [vm\_switch\_name](#input\_vm\_switch\_name)

Description: The name of the virtual switch that is used by the network.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_address_prefix"></a> [address\_prefix](#input\_address\_prefix)

Description: The CIDR prefix of the subnet that used by kubernetes cluster nodes, it will create VM with the ip address in this range

Type: `string`

Default: `null`

### <a name="input_default_gateway"></a> [default\_gateway](#input\_default\_gateway)

Description: The default gateway for the network.

Type: `string`

Default: `null`

### <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers)

Description: A list of DNS server IP addresses.

Type: `list(string)`

Default: `[]`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see <https://aka.ms/avm/telemetryinfo>.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_ending_address"></a> [ending\_address](#input\_ending\_address)

Description: The ending IP address of the IP address range.

Type: `string`

Default: `null`

### <a name="input_ip_allocation_method"></a> [ip\_allocation\_method](#input\_ip\_allocation\_method)

Description: The IP address allocation method, must be either 'Static' or 'Dynamic'. Default is dynamic

Type: `string`

Default: `"Dynamic"`

### <a name="input_ip_configuration_references"></a> [ip\_configuration\_references](#input\_ip\_configuration\_references)

Description: A list of IP configuration references.

Type:

```hcl
list(object({
    ID = string
  }))
```

Default: `null`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.

Type:

```hcl
object({
    kind = string
    name = optional(string, null)
  })
```

Default: `null`

### <a name="input_logical_network_tags"></a> [logical\_network\_tags](#input\_logical\_network\_tags)

Description: (Optional) Tags of the logical network.

Type: `map(string)`

Default: `null`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_route_name"></a> [route\_name](#input\_route\_name)

Description: The name of the route

Type: `string`

Default: `null`

### <a name="input_starting_address"></a> [starting\_address](#input\_starting\_address)

Description: The starting IP address of the IP address range.

Type: `string`

Default: `null`

### <a name="input_subnet_0_name"></a> [subnet\_0\_name](#input\_subnet\_0\_name)

Description: The name of the subnet

Type: `string`

Default: `"default"`

### <a name="input_vlan_id"></a> [vlan\_id](#input\_vlan\_id)

Description: The vlan id of the logical network, default means no vlan id is specified

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id)

Description: This is the full output for the resource.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->