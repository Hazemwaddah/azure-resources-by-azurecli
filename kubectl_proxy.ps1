## connect to cluster using kubectl proxy

az login
az login --use-device-code
## Set the subscription as the current one
az account set --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx

# Kube Dashboard UI is not deployed by default, To deploy it:
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.5.0/aio/deploy/recommended.yaml

## Set Env-Production as the current context
az aks get-credentials --resource-group Production --name Env-Production --admin
az aks get-credentials --resource-group Testing --name Env-Testing --admin
az aks get-credentials --resource-group rg-aks --name myAKSCluster --admin
az aks get-credentials --resource-group rg-privateendpoint-uae --name aks-privateendpoint-tst-uae

## Start connection
kubectl proxy

## Open a browser and paste this link
http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/#/workloads?namespace=default


# Put the config file in that directory:
C:\Users\Fast_\.kube
cd C:/Users/Hazem/.kube

## Display All pods IP address
kubectl get pod -o wide




kubectl get pod

