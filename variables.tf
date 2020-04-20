variable "rgName" {
    description    = "(Required) Name for resource group"
    type           = "string"
}
variable "vmName" {
    description     = "(Required) Name for vm and its components"
    type            = "string"
}
variable "Location" {
    description     = "(Required) Location for resource"
    type            = "string"
}
variable "resource_prefix" {
    description     = "(Optional) Prefix"
    type            = "string"
    default         = "my"
}
variable "vmSize" {
  description       = "(Required) Vm size -B1s free"
  type              = "string"
}
variable "var.admin_username" {
    description     = "(Required) VM admin username"
    type            = "string"
}
variable "var.admin_password" {
    description     = "(Required) VM admin user password"
    type            = "string"
}
variable "Sku" {
    description     = "(Optional) Os sku"
    type            = "string"
    default         = "18.04-LTS" 
}

