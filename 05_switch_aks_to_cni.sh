
RESOURCE_GROUP_NAME=$(terraform output -raw RESOURCE_GROUP_NAME)
CLUSTERNAME=$(terraform output -raw kubernetes_cluster_name)

az aks update --name $CLUSTERNAME --resource-group $RESOURCE_GROUP_NAME --network-plugin azure --network-plugin-mode overlay