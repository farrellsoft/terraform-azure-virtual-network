
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

module "subnets" {
  source    = "app.terraform.io/Farrellsoft/subnet/azure"
  version   = "0.0.3"
  for_each  = var.subnets

  application           = var.application
  purpose               = each.value.purpose
  resource_group_name   = var.resource_group_name
  virtual_network_name  = azurerm_virtual_network.this.name
  address_prefixes      = each.value.address_prefixes
}