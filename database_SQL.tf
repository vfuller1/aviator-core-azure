# Azure SQL Managed Instance
resource "azurerm_mssql_managed_instance" "aviator_sql" {
  name                         = "sql-aviator-maintenance"
  resource_group_name          = azurerm_resource_group.aviator.name
  location                     = azurerm_resource_group.aviator.location
  administrator_login          = "aviatoradmin"
  administrator_login_password = var.sql_admin_password
  license_type                 = "BasePrice"
  subnet_id                    = azurerm_subnet.sql_subnet.id
  sku_name                     = "GP_Gen5"
  vcores                       = 4
  storage_size_in_gb           = 32

  tags = {
    Environment = "Production"
    Project     = "Aviator Core"
  }
}

# Private Endpoint for Secure DB Access
resource "azurerm_private_endpoint" "sql_endpoint" {
  name                = "pe-aviator-sql"
  location            = azurerm_resource_group.aviator.location
  resource_group_name = azurerm_resource_group.aviator.name
  subnet_id           = azurerm_subnet.sql_subnet.id

  private_service_connection {
    name                           = "sql-privatelink"
    private_connection_resource_id = azurerm_mssql_managed_instance.aviator_sql.id
    subresource_names              = ["managedInstance"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_dns.id]
  }
}