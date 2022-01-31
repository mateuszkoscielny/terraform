resource "azurerm_resource_group" "DNS" {
    name = "TerraformDNS"
    location = "North Europe"
}

resource "azurerm_dns_zone" "terraform_DNS" {
    name = "terraform.devopstraining.pl"
    resource_group_name = azurerm_resource_group.DNS.name
}

resource "azurerm_dns_a_record" "DNS" {
    name = var.env_type
    zone_name = azurerm_dns_zone.terraform_DNS.name
    resource_group_name = azurerm_resource_group.DNS.name
    ttl = 300
    records = [azurerm_public_ip.demo-instance.ip_address]
}