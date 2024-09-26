variable "custom_location_name" {
  type        = string
  description = "The name of the custom location."
}

variable "logical_network_name" {
  type        = string
  description = "The name of the logical network"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
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
