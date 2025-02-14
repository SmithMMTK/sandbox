
### Run command
```bash
terraform init
terraform plan -out main.tfplan
terraform apply main.tfplan

```

### AKS cheat sheet
```bash
resource_group_name=$(terraform output -raw resource_group_name)
az aks list --resource-group $resource_group_name --query "[].{\"K8s cluster name\":name}" --output table

echo "$(terraform output kube_config)" > ./azurek8s
cat ./azurek8s

aks_cluster_name=$(az aks list --resource-group $resource_group_name --query "[0].name" -o tsv)

az aks get-credentials --resource-group $resource_group_name --name $aks_cluster_name

kubectl get nodes
kubectl run nodejs-shell --image=node:23 -it --rm --restart=Never -- bash
## install required tools via apt
```



### PostgreSQL cheat sheet
```bash
terraform output -raw psql_admin_password

### Clearn up resources
terraform plan -destroy -out main.destroy.tfplan
terraform apply main.destroy.tfplan

sp=$(terraform output -raw sp)
az ad sp delete --id $sp

```

### Azure VM cheat sheet
```bash

export SSH_PRIVATE_KEY="$(terraform output -raw private_key)"
export SSH_PUBLIC_IP="$(terraform output -raw public_ip_address)"
echo "$SSH_PRIVATE_KEY" > /tmp/private_key.pem
chmod 600 /tmp/private_key.pem
ssh -i /tmp/private_key.pem azureuser@"$SSH_PUBLIC_IP"

rm -f /tmp/private_key.pem

```

### Azure Monitor cheat sheet
```bash

az monitor diagnostic-settings categories list --resource "/subscriptions/d120e7d7-41e4-4ea7-b07d-ea9c11db2118/resourceGroups/rg-master-penguin/providers/Microsoft.ContainerService/managedClusters/cluster-content-ewe"

az monitor diagnostic-settings categories list  --resource "/subscriptions/d120e7d7-41e4-4ea7-b07d-ea9c11db2118/resourceGroups/rg-sought-pheasant/providers/Microsoft.Network/azureFirewalls/azfw"


az monitor diagnostic-settings categories list  --resource "/subscriptions/d120e7d7-41e4-4ea7-b07d-ea9c11db2118/resourceGroups/rg-gorgeous-colt/providers/Microsoft.Web/sites/linuxwebapp-63246"

```