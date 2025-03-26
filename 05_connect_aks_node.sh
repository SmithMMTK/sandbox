kubectl run -it --rm aks-nodejs --image=node:20 -- /bin/bash


kubectl run aks-nodejs \
  --rm -it \
  --restart=Never \
  --image=node:20 \
  --namespace=default \
  --serviceaccount=workload-identity-sa540412 \
  -- bash

  kubectl run aks-nodejs \
  --rm -it \
  --restart=Never \
  --image=node:20 \
  --namespace=default \
  --overrides='{
    "apiVersion": "v1",
    "spec": {
      "serviceAccountName": "workload-identity-sa540412"
    }
  }' \
  -- bash