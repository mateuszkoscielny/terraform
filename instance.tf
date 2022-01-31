# Bootstrapping Template File
data "template_file" "nginx-vm-cloud-init" {
    template = file("install-nginx.sh")
}

# demo instance
resource "azurerm_virtual_machine" "demo-instance" {
  name                  = "${var.prefix}-${var.env_type}-vm"
  location              = var.region
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = ["${azurerm_network_interface.demo-instance.id}"]
  vm_size               = "Standard_A1_v2"

  # this is a demo instance, so we can delete all data on termination
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "demo-instance"
    admin_username = "demo"
    #admin_password = "..."
    custom_data = base64encode(data.template_file.nginx-vm-cloud-init.rendered)
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = file("ssh_key/mykey.pub")
      path     = "/home/demo/.ssh/authorized_keys"
    }
  }
}

resource "azurerm_network_interface" "demo-instance" {
  name                      = "${var.prefix}-${var.env_type}-instance1"
  location                  = var.region
  resource_group_name       = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "instance1"
    subnet_id                     = azurerm_subnet.demo-internal-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.demo-instance.id
  }
}

resource "azurerm_public_ip" "demo-instance" {
  name                = "instance1-public-ip"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}