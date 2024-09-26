variable "custom_location_id" {
  type        = string
  description = "The id of the Custom location that used to create hybrid aks"
}

variable "location" {
  type        = string
  description = "Azure region where the resource should be deployed."
  nullable    = false
}

variable "name" {
  type        = string
  description = "The name of the logical network"
}

variable "resource_group_id" {
  type        = string
  description = "The resource group ID for the Azure Stack HCI logical network."
}

# This is required for most resource modules
variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "vm_switch_name" {
  type        = string
  description = "The name of the virtual switch that is used by the network."
}

variable "address_prefix" {
  type        = string
  default     = null
  description = "The CIDR prefix of the subnet that used by kubernetes cluster nodes, it will create VM with the ip address in this range"
}

variable "default_gateway" {
  type        = string
  default     = null
  description = "The default gateway for the network."
}

variable "dns_servers" {
  type        = list(string)
  default     = []
  description = "A list of DNS server IP addresses."
  nullable    = false
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
  nullable    = false
}

variable "ending_address" {
  type        = string
  default     = null
  description = "The ending IP address of the IP address range."
}

variable "ip_allocation_method" {
  type        = string
  default     = "Static"
  description = "The IP address allocation method, must be either 'Static' or 'Dynamic'."

  validation {
    condition     = contains(["Static", "Dynamic"], var.ip_allocation_method)
    error_message = "The ip_allocation_method must be either 'Static' or 'Dynamic'."
  }
}

variable "lock" {
  type = object({
    kind = string
    name = optional(string, null)
  })
  default     = null
  description = <<DESCRIPTION
Controls the Resource Lock configuration for this resource. The following properties can be specified:

- `kind` - (Required) The type of lock. Possible values are `\"CanNotDelete\"` and `\"ReadOnly\"`.
- `name` - (Optional) The name of the lock. If not specified, a name will be generated based on the `kind` value. Changing this forces the creation of a new resource.
DESCRIPTION

  validation {
    condition     = var.lock != null ? contains(["CanNotDelete", "ReadOnly"], var.lock.kind) : true
    error_message = "The lock level must be one of: 'None', 'CanNotDelete', or 'ReadOnly'."
  }
}

variable "logical_network_tags" {
  type        = map(string)
  default     = null
  description = "(Optional) Tags of the logical network."
}

variable "role_assignments" {
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
    principal_type                         = optional(string, null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
DESCRIPTION
  nullable    = false
}

variable "route_name" {
  type        = string
  default     = "default"
  description = "The name of the route"
}

variable "starting_address" {
  type        = string
  default     = null
  description = "The starting IP address of the IP address range."
}

variable "subnet_0_name" {
  type        = string
  default     = "default"
  description = "The name of the subnet"
}

variable "vlan_id" {
  type        = string
  default     = null
  description = "The vlan id of the logical network, default means no vlan id is specified"
}
