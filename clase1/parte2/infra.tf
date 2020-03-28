provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  features {}
}
resource "azurerm_resource_group" "test" {
  name     = "RG${local.alias}"
  location = "${local.region}"
  tags = {
    Ambiente = "Desarrollo"
  }
}

resource "azurerm_app_service_plan" "main" {
  name                = "az${local.alias}-asp"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "main" {
  name                = "az${local.alias}-web"
  location            = "${azurerm_resource_group.test.location}"
  resource_group_name = "${azurerm_resource_group.test.name}"
  app_service_plan_id = "${azurerm_app_service_plan.main.id}"

}
