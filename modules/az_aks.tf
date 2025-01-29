
resource "azurerm_kubernetes_cluster" "k8s" {
    location = azurerm_resource_group.rg.location
    name = "aks-${random_pet.rg_name.id}" 

    resource_group_name = azurerm_resource_group.rg.name
    dns_prefix = "aks-${random_pet.rg_name.id}"

    identity {
    type = "SystemAssigned"
    }

    default_node_pool {
        name       = "agentpool"
        vm_size    = "Standard_D2_v2"
        node_count = "3"
        vnet_subnet_id      = azurerm_subnet.AKSSubnet.id
    }
    linux_profile {
        admin_username = "azureuser"

        ssh_key {
            key_data = azapi_resource_action.ssh_public_key_gen.output.publicKey
        }
    }
    network_profile {
        network_plugin    = "kubenet"
        load_balancer_sku = "standard"
        dns_service_ip = "10.200.0.10"
        service_cidr = "10.200.0.0/16"
        pod_cidr = "10.201.0.0/16"

    }

    oms_agent {
        log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
        msi_auth_for_monitoring_enabled = true
    }
        

}

resource "azurerm_monitor_diagnostic_setting" "aks_diagnostic" {
  name               = "diagnostic_setting_name"
  target_resource_id = azurerm_kubernetes_cluster.k8s.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log.id
  log_analytics_destination_type = "Dedicated"

enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-audit"
  }

  enabled_log {
    category = "kube-audit-admin"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "kube-scheduler"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }

  enabled_log {
    category = "cloud-controller-manager"
  }

  enabled_log {
    category = "guard"
  }

  enabled_log {
    category = "csi-azuredisk-controller"
  }

  enabled_log {
    category = "csi-azurefile-controller"
  }

  enabled_log {
    category = "csi-snapshot-controller"
  }
}

output "kubernetes_cluster_name" {
  value = azurerm_kubernetes_cluster.k8s.name
}

output "client_certificate" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config[0].client_certificate
  sensitive = true
}

output "client_key" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config[0].client_key
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config[0].cluster_ca_certificate
  sensitive = true
}

output "cluster_password" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config[0].password
  sensitive = true
}

output "cluster_username" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config[0].username
  sensitive = true
}

output "host" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config[0].host
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}