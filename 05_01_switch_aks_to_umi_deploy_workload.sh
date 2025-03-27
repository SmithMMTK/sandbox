
export RANDOM_ID="$(openssl rand -hex 3)"
export RESOURCE_GROUP=$(terraform output -raw RESOURCE_GROUP_NAME)
export LOCATION="southeastasia"
export CLUSTER_NAME=$(terraform output -raw kubernetes_cluster_name)
export STORAGE_ACCOUNT_NAME=$(terraform output -raw STORAGE_ACCOUNT_NAME)
export STORAGE_ACCOUNT_ID=$(az storage account show --name "${STORAGE_ACCOUNT_NAME}" --query id --output tsv)




# Update an existing AKS cluster to use OIDC and Workload Identity
az aks update --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --enable-oidc-issuer
az aks update --name $CLUSTER_NAME --resource-group $RESOURCE_GROUP --enable-workload-identity

# Retrieve the OIDC issuer URL
export AKS_OIDC_ISSUER="$(az aks show --name "${CLUSTER_NAME}" --resource-group "${RESOURCE_GROUP}" --query "oidcIssuerProfile.issuerUrl" --output tsv)"


# Create a user-assigned managed identity
export SUBSCRIPTION="$(az account show --query id --output tsv)"
export USER_ASSIGNED_IDENTITY_NAME="myIdentity$RANDOM_ID"
az identity create --name "${USER_ASSIGNED_IDENTITY_NAME}" --resource-group "${RESOURCE_GROUP}" --location "${LOCATION}" --subscription "${SUBSCRIPTION}"

# Retrieve the client ID and resource ID of the managed identity
export USER_ASSIGNED_CLIENT_ID="$(az identity show --resource-group "${RESOURCE_GROUP}" --name "${USER_ASSIGNED_IDENTITY_NAME}" --query 'clientId' --output tsv)"


# Create Kubernetes service account with the required annotation
az aks get-credentials --name "${CLUSTER_NAME}" --resource-group "${RESOURCE_GROUP}"

export SERVICE_ACCOUNT_NAMESPACE="default"
export SERVICE_ACCOUNT_NAME="workload-identity-sa$RANDOM_ID"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  annotations:
    azure.workload.identity/client-id: "${USER_ASSIGNED_CLIENT_ID}"
  name: "${SERVICE_ACCOUNT_NAME}"
  namespace: "${SERVICE_ACCOUNT_NAMESPACE}"
EOF

# Create a federated identity credential
export FEDERATED_IDENTITY_CREDENTIAL_NAME="myFedIdentity$RANDOM_ID"
az identity federated-credential create --name ${FEDERATED_IDENTITY_CREDENTIAL_NAME} --identity-name "${USER_ASSIGNED_IDENTITY_NAME}" --resource-group "${RESOURCE_GROUP}" --issuer "${AKS_OIDC_ISSUER}" --subject system:serviceaccount:"${SERVICE_ACCOUNT_NAMESPACE}":"${SERVICE_ACCOUNT_NAME}" --audience api://AzureADTokenExchange


export IDENTITY_PRINCIPAL_ID=$(az identity show \
    --name "${USER_ASSIGNED_IDENTITY_NAME}" \
    --resource-group "${RESOURCE_GROUP}" \
    --query principalId \
    --output tsv)

# Display all variables
echo "--------------------------------"
echo "AKS OIDC Issuer URL: ${AKS_OIDC_ISSUER}"
echo "User Assigned Identity Name: ${USER_ASSIGNED_IDENTITY_NAME}"
echo "User Assigned Identity Client ID: ${USER_ASSIGNED_CLIENT_ID}"
echo "Service Account Name: ${SERVICE_ACCOUNT_NAME}"
echo "Service Account Namespace: ${SERVICE_ACCOUNT_NAMESPACE}"
echo "Federated Identity Credential Name: ${FEDERATED_IDENTITY_CREDENTIAL_NAME}"
echo "Identity Principal ID: ${IDENTITY_PRINCIPAL_ID}"
echo "Storage Account ID: ${STORAGE_ACCOUNT_ID}"
echo "Storage Account Name: ${STORAGE_ACCOUNT_NAME}"
echo "--------------------------------"


# Deploy a sample workload using the service account
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
      resources:
        requests:
          cpu: 10m
          memory: 128Mi
        limits:
          cpu: 250m
          memory: 256Mi
EOF

# Assign role to storage account
az role assignment create \
  --assignee-object-id "${IDENTITY_PRINCIPAL_ID}" \
  --role "Storage Blob Data Contributor" \
  --scope "${STORAGE_ACCOUNT_ID}" \
  --assignee-principal-type "ServicePrincipal"

# Remote into the pod
# kubectl exec -it sample-workload-identity -- sh

# Source code to run the sample workload
# https://github.com/SmithMMTK/managed_identity_access
# 



