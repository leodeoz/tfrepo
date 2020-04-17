# Configure the Azure provider
provider "azurerm" {
    version = "~>1.32.0"
}

# Create a new resource group
resource "azurerm_resource_group" "rg" {
    name     = var.rgName
    location = var.Location
    tags = {
        Environment = "terraform getting started"
        Team = "Devops"
    }
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
    name                = "${var.vmName}-Vnet"
    address_space       = ["10.0.0.0/16"]
    location            = var.Location
    resource_group_name = azurerm_resource_group.rg.name
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.vmName}-Subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefix       = "10.0.1.0/24"
}

# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "${var.resource_prefix}-PublicIP"
  location            = var.Location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}


# Create Network Security Group and rule
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.vmName}-NSG"
  location            = var.Location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                      = "${var.vmName}-NIC"
  location                  = var.Location
  resource_group_name       = azurerm_resource_group.rg.name
  network_security_group_id = azurerm_network_security_group.nsg.id

  ip_configuration {
    name                          = "${var.vmName}-NICConfg"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vmName
  location              = var.Location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vmSize

  storage_os_disk {
    name              = "myOsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "ubuntuTFVM"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
  /*
  provisioner "file" {
      connection {
      host     = azurerm_public_ip.publicip.ip_address
      type     = "ssh"
      user     = var.admin_username
      password = var.admin_password
    }

    source      = "newfile.txt"
    destination = "newfile.txt"
  }
  */
}
