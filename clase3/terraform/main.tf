provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  features {}
}
data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "azurelive" {
  name     = "rg${local.alias}"
  location = local.region
}
resource "azurerm_servicebus_namespace" "azurelive" {
  name                = "asb${local.alias}01"
  location            = azurerm_resource_group.azurelive.location
  resource_group_name = azurerm_resource_group.azurelive.name
  sku                 = "Standard"
}
resource "azurerm_servicebus_queue" "azurelive" {
  name                = "clientes"
  resource_group_name = azurerm_resource_group.azurelive.name
  namespace_name      = azurerm_servicebus_namespace.azurelive.name

  enable_partitioning = true
}
resource "azurerm_logic_app_workflow" "azurelive" {
  name                = "alp${local.alias}01"
  location            = azurerm_resource_group.azurelive.location
  resource_group_name = azurerm_resource_group.azurelive.name
}
resource "azurerm_storage_account" "azurelive" {
  name                     = "stg${local.alias}01"
  resource_group_name      = azurerm_resource_group.azurelive.name
  location                 = azurerm_resource_group.azurelive.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "azurelive" {
  name                = "asp${local.alias}01"
  location            = azurerm_resource_group.azurelive.location
  resource_group_name = azurerm_resource_group.azurelive.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "azurelive" {
  name                      = "fpp${local.alias}01"
  location                  = azurerm_resource_group.azurelive.location
  resource_group_name       = azurerm_resource_group.azurelive.name
  app_service_plan_id       = azurerm_app_service_plan.azurelive.id
  storage_connection_string = azurerm_storage_account.azurelive.primary_connection_string
}