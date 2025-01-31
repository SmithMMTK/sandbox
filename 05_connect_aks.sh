### Connect to AKS cluster
RESOURCE_GROUP_NAME=$(terraform output -raw RESOURCE_GROUP_NAME)

az aks list --resource-group $RESOURCE_GROUP_NAME --query "[].{\"K8s cluster name\":name}" --output table

echo "$(terraform output kube_config)" > ./tmp/azurek8s

aks_cluster_name=$(az aks list --resource-group $RESOURCE_GROUP_NAME --query "[0].name" -o tsv)

az aks get-credentials --resource-group $RESOURCE_GROUP_NAME --name $aks_cluster_name

export KUBECONFIG=./tmp/azurek8s

kubectl get nodes