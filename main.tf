terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
      version = ">=1.4.0"
    }
  }
}

data azurerm_client_config current {}
module "resource-naming" {
  source  = "app.terraform.io/Farrellsoft/resource-naming/azure"
  version = "0.0.9"
  
  application         = var.application
  environment         = var.environment
  instance_number     = var.instance_number
}

locals {
  resource_group_id     = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"

  subnets = [for key,value in var.subnets : {
    name        = "snet-${lower(var.application)}-${lower(value.purpose)}"
    properties  = {
      addressPrefixes       = value.address_prefixes
      delegations           = [for dkey,value in value.delegations: {
        name                = dkey
        properties          = {
          serviceName      = value.service_name
        }
      }]
      privateEndpointNetworkPolicies      = value.enable_private_endpoint_policies ? "Enabled" : "Disabled"
      privateLinkServiceNetworkPolicies   = value.enable_private_link_service_network_policies ? "Enabled" : "Disabled"
    }
  }]
}

resource azapi_resource this {
  type            = "Microsoft.Network/virtualNetworks@2022-07-01"
  name            = module.resource-naming.virtual_network_name
  parent_id       = local.resource_group_id
  location        = var.location

  body = jsonencode({
    properties = {
      addressSpace = {
        addressPrefixes = var.address_space
      }
      subnets = local.subnets
    }
  })

  response_export_values = ["properties"]
}