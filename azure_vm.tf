provider "azurerm" {
  # Whilst version is optional, we /strongly recommend/ using it to pin the version of the Provider being used
  version = "=1.32.0"

  subscription_id = "9d2581cc-57f1-42b3-9a08-b22dfcd2da69"
}

variable "prefix" {
  default = "jvion-machine"
}

variable "suffix" {
  default = "vm"
}

variable "resource_group_name" {
  type = string
}

variable "virtual_net" {
  type = string
}

variable "subnet" {
  type = string
}

variable "location" {
  type = string
  default = "eastus2"
}

data "azurerm_subnet" "test" {
  name                 = "${var.subnet}"
  virtual_network_name = "${var.virtual_net}"
  resource_group_name  = "${var.resource_group_name}"
}

resource "azurerm_public_ip" "pub-ip" {
    name                         = "${var.prefix}-${var.suffix}"
    location                     = "${var.location}"
    resource_group_name          = "${var.resource_group_name}"
    public_ip_address_allocation = "dynamic"

}

resource "azurerm_network_interface" "test" {
  name                = "${var.prefix}-${var.suffix}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${data.azurerm_subnet.test.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.pub-ip.id}"
  }
}

resource "azurerm_virtual_machine" "vm2" {
  name                  = "${var.prefix}-${var.suffix}"
  location              = "${var.location}"
  resource_group_name   = "${var.resource_group_name}"
  network_interface_ids = ["${azurerm_network_interface.test.id}"]
  vm_size               = "Standard_DS1_v2"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
#  delete_os_disk_on_termination = true


  # Uncomment this line to delete the data disks automatically when deleting the VM
 # delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-${var.suffix}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    Owner = "Partha Chatterjee"
  }
}
