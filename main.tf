terraform {
  required_providers {
    azapi = {
      source = "Azure/azapi"
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
    }
  })
}

module "subnets" {
  source      = "../terraform-azure-subnet"
  for_each    = var.subnets

  application                                   = var.application
  purpose                                       = each.value.purpose
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azapi_resource.this.name
  address_prefixes                              = each.value.address_prefixes
  delegations                                   = each.value.delegations
  enable_private_endpoint_policies              = each.value.enable_private_endpoint_policies
  enable_private_link_service_network_policies  = each.value.enable_private_link_service_network_policies
}