
RESOURCE_GROUP_NAME=$(terraform output -raw RESOURCE_GROUP_NAME)
CLUSTERNAME=$(terraform output -raw kubernetes_cluster_name)
export RANDOM_ID="$(openssl rand -hex 3)"
export USER_ASSIGNED_IDENTITY_NAME=$CLUSTERNAME


CLIENT_ID=$(az identity show --name $CLUSTERNAME --resource-group $RESOURCE_GROUP_NAME --query clientId --output tsv)
RESOURCE_ID=$(az identity show --name $CLUSTERNAME --resource-group $RESOURCE_GROUP_NAME --query id --output tsv)
aks_cluster_name=$(az aks list --resource-group $RESOURCE_GROUP_NAME --query "[0].name" -o tsv)



# Enable OIDC Issuer
az aks update --name $CLUSTERNAME --resource-group $RESOURCE_GROUP_NAME --enable-oidc-issuer

# Get OIDC URL
AKS_OIDC_ISSUER="$(az aks show --name "${CLUSTERNAME}" --resource-group "${RESOURCE_GROUP_NAME}" --query "oidcIssuerProfile.issuerUrl" --output tsv)"


export SERVICE_ACCOUNT_NAMESPACE="default"
export SERVICE_ACCOUNT_NAME="workload-identity-sa$RANDOM_ID"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: "${CLIENT_ID}"
  name: "${SERVICE_ACCOUNT_NAME}"
  namespace: "${SERVICE_ACCOUNT_NAMESPACE}"
EOF


export FEDERATED_IDENTITY_CREDENTIAL_NAME="myFedIdentity$RANDOM_ID"
az identity federated-credential create --name ${FEDERATED_IDENTITY_CREDENTIAL_NAME} --identity-name "${USER_ASSIGNED_IDENTITY_NAME}" --resource-group "${RESOURCE_GROUP_NAME}" --issuer "${AKS_OIDC_ISSUER}" --subject system:serviceaccount:"${SERVICE_ACCOUNT_NAMESPACE}":"${SERVICE_ACCOUNT_NAME}" --audience api://AzureADTokenExchange

echo "--------------------------------"
echo "AKS OIDC Issuer URL: ${AKS_OIDC_ISSUER}"
echo "Name space: default"
echo "Service Account Name: ${SERVICE_ACCOUNT_NAME}"
echo "Federated Identity Credential Name: ${FEDERATED_IDENTITY_CREDENTIAL_NAME}"
echo "Client ID: ${CLIENT_ID}"
echo "--------------------------------"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: sample-workload-identity
  namespace: ${SERVICE_ACCOUNT_NAMESPACE}  # Replace with your namespace
  labels:
    azure.workload.identity/use: "true"  # Required. Only pods with this label can use workload identity.
spec:
  serviceAccountName: ${SERVICE_ACCOUNT_NAME}  # Replace with your service account name
  containers:
    - name: node-app
      image: node:20
      command: ["sh", "-c", "while true; do sleep 3600; done"]
      env:
        - name: AZURE_CLIENT_ID
          value: ${CLIENT_ID}  # Replace with your UMI's client ID
      resources:
        requests:
          cpu: 10m
          memory: 128Mi
        limits:
          cpu: 250m
          memory: 256Mi
EOF

# kubectl exec -it sample-workload-identity -n ${SERVICE_ACCOUNT_NAMESPACE} -- sh

az identity federated-credential list \
  --identity-name $USER_ASSIGNED_IDENTITY_NAME \
  --resource-group $RESOURCE_GROUP_NAME 

