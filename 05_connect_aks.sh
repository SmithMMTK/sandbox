### Connect to AKS cluster
RESOURCE_GROUP_NAME=$(terraform output -raw RESOURCE_GROUP_NAME)

az aks list --resource-group $RESOURCE_GROUP_NAME --query "[].{\"K8s cluster name\":name}" --output table

#echo "$(terraform output kube_config)" > ./tmp/azurek8s

aks_cluster_name=$(az aks list --resource-group $RESOURCE_GROUP_NAME --query "[0].name" -o tsv)

az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $aks_cluster_name

#export KUBECONFIG=./tmp/azurek8s

kubectl get nodes


### Connect ACR
#ACR_NAME=$(terraform output -raw azurerm_container_registry_name)
#az acr login --name $ACR_NAME

## Test Push Image
#docker pull mcr.microsoft.com/hello-world
#docker tag mcr.microsoft.com/hello-world $ACR_NAME.azurecr.io/hello-world
#docker push $ACR_NAME.azurecr.io/hello-world


### Test AKS application deployment
#kubectl apply -f aks-quickstart.yaml
kubectl get pods