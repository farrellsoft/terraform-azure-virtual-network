
provider azurerm {
  features {}
}

module "resource-naming" {
  source  = "app.terraform.io/Farrellsoft/resource-naming/azure"
  version = "0.0.9"
  
  application         = var.application
  environment         = var.environment
  instance_number     = var.instance_number
}

resource azurerm_virtual_network this {
  name                = module.resource-naming.virtual_network_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan_id == null ? [] : [1]
    content {
      id     = var.ddos_protection_plan_id
      enable = true
    }
  }
}