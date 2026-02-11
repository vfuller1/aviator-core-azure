# 1. Azure SQL Logical Server
resource "azurerm_mssql_server" "aviator_sql" {
  name                         = "sql-server-aviator-maintenance"
  resource_group_name          = azurerm_resource_group.aviator.name
  location                     = azurerm_resource_group.aviator.location
  version                      = "12.0"
  administrator_login          = "aviatoradmin"
  administrator_login_password = var.sql_admin_password
  public_network_access_enabled = false # Lead Best Practice: Disable public access
}

# 2. Azure SQL Database
resource "azurerm_mssql_database" "maintenance_db" {
  name           = "db-airplane-maintenance"
  server_id      = azurerm_mssql_server.aviator_sql.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  sku_name       = "S0" # Standard S0 (cost-effective for demo)
}

# 3. Private Endpoint for the SQL Server
resource "azurerm_private_endpoint" "sql_endpoint" {
  name                = "pe-aviator-sql"
  location            = azurerm_resource_group.aviator.location
  resource_group_name = azurerm_resource_group.aviator.name
  subnet_id           = azurerm_subnet.sql_subnet.id

  private_service_connection {
    name                           = "sql-privatelink"
    private_connection_resource_id = azurerm_mssql_server.aviator_sql.id
    subresource_names              = ["sqlServer"] # Note the change from managedInstance
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql_dns.id]
  }
}