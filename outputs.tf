
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
  value             = [for subnet in jsondecode(azapi_resource.this.output).properties.subnets : {
    id    = subnet.id
    name  = subnet.name
  }]
}