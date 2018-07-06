provider "azurerm" {
    subscription_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    client_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    client_secret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
    tenant_id = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
#create azure resource group
resource "azurerm_resource_group" "DevopsRG" {
  name = "DevopsRG"
  location = "North Europe"

  tags {
     environment = "Terraform Demo"
  }
}
#create virtual network group
resource "azurerm_virtual_network" "Development" {
  name = "DEV"
  address_space = ["10.0.0.0/16"]
  location = "North Europe"
  resource_group_name = "${azurerm_resource_group.DevopsRG.name}"

  tags {
     environment = "Development"
  }
}
#create subnets
resource "azurerm_subnet" "FrontEndApplications" {
  name = "FrontEndApplications"
  resource_group_name = "${azurerm_resource_group.DevopsRG.name}"
  virtual_network_name = "${azurerm_virtual_network.Development.name}"
  address_prefix = "10.0.1.0/24"
}
#create Network Security Group and rule
resource "azurerm_network_security_group" "Dev_nsg" {
  name = "MyNet_sec_grp"
  location = "${azurerm_resource_group.DevopsRG.location}"
  resource_group_name = "${azurerm_resource_group.DevopsRG.name}"

  security_rule {
   name = "RDP"
   priority = "100"
   direction = "Inbound"
   access = "Allow"
   protocol = "tcp"
   source_port_range = "*"
   destination_port_range = "3389"
   source_address_prefix = "185.125.226.2"
   destination_address_prefix = "*"
  }
  security_rule {
   name = "HTTP"
   priority = "110"
   direction = "Inbound"
   access = "Allow"
   protocol = "tcp"
   source_port_range = "*"
   destination_port_range = "80"
   source_address_prefix = "*"
   destination_address_prefix = "*"
  }
  security_rule {
  name = "https"
  priority = "120"
  direction = "inbound"
  access = "allow"
  protocol = "tcp"
  source_port_range = "*"
  destination_port_range ="443"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  }
}
#create public IP
resource "azurerm_public_ip" "mypubIP" {
  name = "myIP"
  location = "${azurerm_resource_group.DevopsRG.location}"
  resource_group_name = "${azurerm_resource_group.DevopsRG.name}"
  public_ip_address_allocation = "static"
}
#create Network Interface Card
resource "azurerm_network_interface" "MyNIC" {
  name = "FrontEndApp_NIC"
  location = "${azurerm_resource_group.DevopsRG.location}"
  resource_group_name = "${azurerm_resource_group.DevopsRG.name}"
  network_security_group_id = "${azurerm_network_security_group.Dev_nsg.id}"

  ip_configuration {
  name = "frontendapp"
  subnet_id = "${azurerm_subnet.FrontEndApplications.id}"
  private_ip_address_allocation = "static"
  private_ip_address = "10.0.1.20"
  public_ip_address_id = "${azurerm_public_ip.mypubIP.id}"
  }
}

#create azure storage account
resource "azurerm_storage_account" "dev_storage" {
  name = "devstorage101"
  resource_group_name = "${azurerm_resource_group.DevopsRG.name}"
  location = "${azurerm_resource_group.DevopsRG.location}"
  account_tier = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
}
#create managed disk by azure
resource "azurerm_managed_disk" "DevStorage" {
  name = "diskmanagedbyazure"
  resource_group_name = "${azurerm_resource_group.DevopsRG.name}"
  location = "${azurerm_resource_group.DevopsRG.location}"
  storage_account_type = "standard_LRS"
  create_option = "empty"
  disk_size_gb = "1023"
}
#create azure virtual machine
resource "azurerm_virtual_machine" "uk-dev101" {
  name = "uk-dev101"
  location = "${azurerm_resource_group.DevopsRG.location}"
  resource_group_name = "${azurerm_resource_group.DevopsRG.name}"
  network_interface_ids = ["${azurerm_network_interface.MyNIC.id}"]
  vm_size = "Standard_B2ms"
  delete_data_disks_on_termination = true
  delete_os_disk_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2016-datacenter"
    version = "2016.127.20180613"
  }

  storage_os_disk {
    name = "osdisk1"
    caching = "ReadWrite"
    create_option = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "hostname"
    admin_username = "sysadmin"
    admin_password = "Toyota20172018"
  }

  os_profile_windows_config {
    enable_automatic_upgrades = false
  }
}













