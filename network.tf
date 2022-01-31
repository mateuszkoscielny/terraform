resource "azurerm_virtual_network" "demo" {
  name                = "${var.prefix}-${var.env_type}-network"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "demo-internal-1" {
  name                 = "${var.prefix}-${var.env_type}-internal-1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = ["10.0.0.0/24"]
  service_endpoints    = ["Microsoft.Sql"]
}

resource "azurerm_network_security_group" "vm-nsg" {
  name                = "${var.prefix}-${var.env_type}-vm-nsg"
  location            = var.region
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh-source-address
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "HTTP"
    priority                   = 1011
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.ssh-source-address
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "demo" {
    subnet_id = azurerm_subnet.demo-internal-1.id
    network_security_group_id = azurerm_network_security_group.vm-nsg.id
}