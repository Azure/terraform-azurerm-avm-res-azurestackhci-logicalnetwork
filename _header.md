# terraform-azurerm-avm-res-azurestackhci-logical_network

Module to provision azure stack hci logical networks.

## Example prerequisites

The examples require an existing Azure resource group and a registered Azure
Stack HCI cluster with an Arc custom location and the configured virtual switch.
Set `ARM_SUBSCRIPTION_ID` to that resource group's subscription and supply
`resource_group_name`, `custom_location_name`, and `logical_network_name` through
Terraform variables. These are real environment inputs, not sample defaults;
the examples do not provision the HCI cluster or custom location.

Policy plans also read these existing resources and require the same inputs and
authorized Azure access. They cannot run against an empty subscription.
