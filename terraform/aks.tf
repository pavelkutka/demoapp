resource "azurerm_kubernetes_cluster" "aks" {
  name                = "pk-demoapp-ne-aks01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "pk-akscommunity-ne-aks01-dns"

  kubernetes_version = "1.31.8"

  default_node_pool {
    name                   = "defaultnp"
    node_count             = 1
    vm_size                = "Standard_DS2_v2"
    auto_scaling_enabled   = false
    os_disk_size_gb        = 128
    os_disk_type           = "Managed"
    max_pods               = 30
    vnet_subnet_id         = azurerm_subnet.besubnet.id
    type                   = "VirtualMachineScaleSets"
    orchestrator_version   = "1.31.8"
    node_public_ip_enabled = false
    os_sku                 = "AzureLinux"

    upgrade_settings {
      drain_timeout_in_minutes      = 0
      max_surge                     = "10%"
      node_soak_duration_in_minutes = 0
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_data_plane  = "azure"
    load_balancer_sku   = "standard"
    pod_cidr            = "10.244.0.0/16"
    service_cidr        = "10.1.0.0/16"
    dns_service_ip      = "10.1.0.10"
    outbound_type       = "loadBalancer"
    ip_versions         = ["IPv4"]
  }

  node_resource_group               = "PK-DEMOAPPDYN-NE-RG01"
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
  role_based_access_control_enabled = true
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}
