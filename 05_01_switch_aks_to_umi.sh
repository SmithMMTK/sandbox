
RESOURCE_GROUP_NAME=$(terraform output -raw RESOURCE_GROUP_NAME)
CLUSTERNAME=$(terraform output -raw kubernetes_cluster_name)


az identity create --name $CLUSTERNAME --resource-group $RESOURCE_GROUP_NAME


RESOURCE_ID=$(az identity show --name $CLUSTERNAME --resource-group $RESOURCE_GROUP_NAME --query id --output tsv)
aks_cluster_name=$(az aks list --resource-group $RESOURCE_GROUP_NAME --query "[0].name" -o tsv)

az aks update --resource-group $RESOURCE_GROUP_NAME --name $aks_cluster_name --enable-managed-identity --assign-identity $RESOURCE_ID --yes

az aks show --name $aks_cluster_name --resource-group $RESOURCE_GROUP_NAME --query identity.type --output tsv
