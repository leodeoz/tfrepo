output "ip" {
    value = azurerm_public_ip.publicip.ip_address
}

output "os_sku" {
    value = var.os_sku
}
