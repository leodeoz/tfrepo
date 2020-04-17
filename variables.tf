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
