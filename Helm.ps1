## Helm

## Verify your version of Helm
helm version

## Add Helm repositories
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

## Find Helm charts
helm search repo ingress-nginx

## Update the list of charts
helm repo update

helm uninstall nginx-ingress --namespace ingress-basic
helm delete ingress-basic --namespace default
helm delete ingress-basic --purge
#########################################################################
#########################################################################
#########################################################################
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

choco install kubernetes-helm 3.9.0
choco install kubernetes-helm --force 3.9.0
choco upgrade kubernetes-helm

choco upgrade chocolatey

# Upgrade all software on your computer using chocolatey
choco upgrade all -y

curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

#########################################################################
#########################################################################
#########################################################################
##          Helm commands
helm pull

helm show values ingress-nginx/ingress-nginx


kubectl get namespaces
kubectl delete ingress-basic

wget https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx

https://github.com/repo/charts/releases/download/app-1.0.0/chart-1.0.0.tgz

helm upgrade ingress-nginx https://artifacthub.io/packages/helm/ingress-nginx/ingress-nginx \
 --version 4.1.3 \
 --reuse-values \
 --set replicaCount=1 \
 --wait \
 --namespace ingress-basic
#

helm list --all-namespaces

helm upgrade nginx-ingress-4.1.3 --install --namespace ingress-basic

alias k=kubectl

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

az acr list
az aks list

helm repo add bitnami https://charts.bitnami.com/bitnami

helm search repo bitnami


REGISTRY_NAME=<REGISTRY_NAME>
SOURCE_REGISTRY=k8s.gcr.io
CONTROLLER_IMAGE=ingress-nginx/controller
CONTROLLER_TAG=v1.0.4
PATCH_IMAGE=ingress-nginx/kube-webhook-certgen
PATCH_TAG=v1.1.1
DEFAULTBACKEND_IMAGE=defaultbackend-amd64
DEFAULTBACKEND_TAG=1.5

az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$CONTROLLER_IMAGE:$CONTROLLER_TAG --image $CONTROLLER_IMAGE:$CONTROLLER_TAG
az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$PATCH_IMAGE:$PATCH_TAG --image $PATCH_IMAGE:$PATCH_TAG
az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$DEFAULTBACKEND_IMAGE:$DEFAULTBACKEND_TAG --image $DEFAULTBACKEND_IMAGE:$DEFAULTBACKEND_TAG
docker pull jettech/kube-webhook-certgen:v1.5.2

# Import an image into Azure container registry
az acr import \
  --name mycompany \
  --source docker.io/library/kube-webhook-certgen:v1.5.2 \
  --image jettech/kube-webhook-certgen:v1.5.2
#

SOURCE_REGISTRY=k8s.gcr.io

helm show values ingress-nginx/ingress-nginx