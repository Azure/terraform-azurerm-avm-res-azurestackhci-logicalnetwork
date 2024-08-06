variable "custom_location_name" {
  type        = string
  description = "The name of the custom location."
}

variable "logicalNetworkName" {
  type        = string
  description = "The name of the logical network"
}

variable "resource_group_name" {
  type        = string
  description = "The resource group where the resources will be deployed."
}

variable "siteId" {
  type        = string
  description = "A unique identifier for the site."
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
