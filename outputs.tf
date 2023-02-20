
output name {
  value             = azurerm_virtual_network.this.name
}

output id {
  value             = azurerm_virtual_network.this.id
}

output subnets {
  value             = { for k,v in module.subnets : k => {
    id    = v.id
    name  = v.name
  } }
}