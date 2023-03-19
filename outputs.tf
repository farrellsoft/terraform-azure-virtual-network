
output name {
  value             = azapi_resource.this.name
}
#
output id {
  value             = azapi_resource.this.id
  description       = "The Resource Id for the Virtual Network"
}
#
output subnets {
  value             = { for k,v in module.subnets : k => {
    id    = v.id
    name  = v.name
  } }
}