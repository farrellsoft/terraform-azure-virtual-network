
variable resource_group_name {
  type        = string
  description = "The name of the resource group in which to create the virtual network."
}

variable application {
  type = string
  validation {
    condition     = length(var.application) > 3
    error_message = "${var.application} must be a minimum of three (3) characters."
  }
}

variable environment {
  type = string
  validation {
    condition     = length(var.environment) == 3
    error_message = "${var.environment} must be three (3) characters."
  }
}

variable instance_number {
  type = string
  validation {
    condition     = can(regex("^[0-9]{3}$", var.instance_number))
    error_message = "${var.instance_number} must be three (3) numbers."
  }
  default   = "001"
}

variable location {
  type        = string
  description = "The location/region where the virtual_network will be created."
}

variable address_space {
  type        = list(string)
  description = "The address space that is used by the virtual network."
  validation {
    condition     = length(var.address_space) >= 1
    error_message = "At least one address space must be provided."
  }
}

variable ddos_protection_plan_id {
  type        = string
  description = "The ID of the DDoS protection plan associated with the virtual network."
  default     = null
}

variable subnets {
  type            = map(object({
    purpose           = string
    address_prefixes  = list(string)
  }))
  description     = "A map of subnets to create in the virtual network."
  default         = {}
}