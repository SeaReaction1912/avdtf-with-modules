resource "azurerm_virtual_network" "vnet" {
  name                = "gw_vnet"
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = ["10.0.254.0/24"]
}

resource "azurerm_subnet" "GatewaySubnet" {
  name                = "GatewaySubnet"
  resource_group_name = var.rg_name
  virtual_network_name= azurerm_virtual_network.vnet.name
  address_prefixes    = ["10.0.254.0/24"]
}

resource "azurerm_public_ip" "vpnpip" {
    name                = var.vpn_pip_name
    location            = var.rg_location
    resource_group_name = var.rg_name
    allocation_method   = "Dynamic"
  
    tags = var.tag_env
  }

resource "azurerm_virtual_network_gateway" "vpngw" {
  name                = var.vpn_gw_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "Standard"
 
  ip_configuration {
    name                          = "vpn_gw_config"
    public_ip_address_id          = azurerm_public_ip.vpnpip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.GatewaySubnet.id
  }
  
  vpn_client_configuration {
    address_space = ["${var.vpn_net_addr_spc}"]
  }

  depends_on = [var.vnets]
  
  tags = var.tag_env
}

resource "azurerm_local_network_gateway" "clientlocalgw" {
  name                = var.client_local_gw_name
  resource_group_name = var.rg_name
  location            = var.rg_location
  gateway_address     = var.client_local_gw_pip
  address_space       = ["${var.client_internal_subnet}"]

  tags = var.tag_env
}

resource "azurerm_virtual_network_gateway_connection" "vpntoclient" {
  name                = var.vpn_connection_name
  location            = var.rg_location
  resource_group_name = var.rg_name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vpngw.id
  local_network_gateway_id   = azurerm_local_network_gateway.clientlocalgw.id
  enable_bgp				 = false

  shared_key = var.vpn_to_client_gw1_psk

  tags = var.tag_env
}

resource "azurerm_route_table" "rtable" {
  name                          = var.rtable_name
  location                      = var.rg_location
  resource_group_name           = var.rg_name
  disable_bgp_route_propagation = false

  route {
    name           = "client-net"
    address_prefix = var.client_internal_subnet
    next_hop_type  = "VirtualNetworkGateway"
  }
}

resource "azurerm_subnet_route_table_association" "avd-net-rt-assoc" {
  subnet_id      = "${var.vnet_subnet_id}"
  route_table_id = azurerm_route_table.rtable.id
}
#end