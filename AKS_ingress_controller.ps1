## Create a AKS cluster
#Create a resource group
#Create AKS cluster
#Connect to the cluster
#Attach AKS to ACR
#Use Helm to deploy ingress controller
#Delete the cluster
# ./AKS_ingress_controller.ps1
# cd C:/Users/Hazem/Desktop/Powershell
## Create a resource group
az group create --name rg-aks --location uaenorth

## Create AKS cluster
az aks create --resource-group rg-aks \
 --name myAKSCluster \
 --node-count 1 \
 --enable-addons monitoring \
 --generate-ssh-keys
#

## Connect to the cluster
az aks get-credentials \
 --resource-group rg-aks \
 --name myAKSCluster
#

## Verify the connection to your cluster
kubectl get nodes

# Output
# NAME                       STATUS   ROLES   AGE     VERSION
# aks-nodepool1-31718369-0   Ready    agent   6m44s   v1.12.8

## Integrate ACR & an existin AKS
az aks update -n myAKSCluster -g rg-aks --attach-acr myacr
## Remove integration between ACR & AKS
#az aks update -n myAKSCluster -g rg-aks --detach-acr myacr

## Import the images used by the Helm chart into your ACR [to be done once]
REGISTRY_NAME=myacr
SOURCE_REGISTRY=k8s.gcr.io
CONTROLLER_IMAGE=ingress-nginx/controller
CONTROLLER_TAG=v1.2.0
PATCH_IMAGE=ingress-nginx/kube-webhook-certgen
PATCH_TAG=v1.5.2
DEFAULTBACKEND_IMAGE=defaultbackend-amd64
DEFAULTBACKEND_TAG=1.5

#az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$CONTROLLER_IMAGE:$CONTROLLER_TAG --image $CONTROLLER_IMAGE:$CONTROLLER_TAG
#az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$PATCH_IMAGE:$PATCH_TAG --image $PATCH_IMAGE:$PATCH_TAG
#az acr import --name $REGISTRY_NAME --source $SOURCE_REGISTRY/$DEFAULTBACKEND_IMAGE:$DEFAULTBACKEND_TAG --image $DEFAULTBACKEND_IMAGE:$DEFAULTBACKEND_TAG
#######################################################################################
## Create a file named azure-vote.yaml [C:/Users/Hazem/.kube]
cd C:/Users/Hazem/.kube

# Add the ingress-nginx repository [to be done once]
#helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

# Set variable for ACR location to use for pulling images
ACR_URL=myacr.azurecr.io

# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress ingress-nginx/ingress-nginx \
    --version 4.1.3 \
    --namespace ingress-basic --create-namespace \
    --set controller.replicaCount=1 \
    --set controller.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.image.registry=$ACR_URL \
    --set controller.image.image=$CONTROLLER_IMAGE \
    --set controller.image.tag=$CONTROLLER_TAG \
    --set controller.image.digest="" \
    --set controller.admissionWebhooks.patch.nodeSelector."kubernetes\.io/os"=linux \
    --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
    --set controller.admissionWebhooks.patch.image.registry=$ACR_URL \
    --set controller.admissionWebhooks.patch.image.image=$PATCH_IMAGE \
    --set controller.admissionWebhooks.patch.image.tag=$PATCH_TAG \
    --set controller.admissionWebhooks.patch.image.digest="" \
    --set defaultBackend.nodeSelector."kubernetes\.io/os"=linux \
    --set defaultBackend.image.registry=$ACR_URL \
    --set defaultBackend.image.image=$DEFAULTBACKEND_IMAGE \
    --set defaultBackend.image.tag=$DEFAULTBACKEND_TAG \
    --set defaultBackend.image.digest=""
#
#

## Get the public IP address
#kubectl --namespace ingress-basic get services -o wide -w nginx-ingress-ingress-nginx-controller

## Generate TLS certificates
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out aks-ingress-tls.crt \
    -keyout aks-ingress-tls.key \
    -subj "//CN=demo.azure.com/O=aks-ingress-tls"
#

## Create Kubernetes secret for the TLS certificate
kubectl create secret tls aks-ingress-tls \
    --namespace ingress-basic \
    --key aks-ingress-tls.key \
    --cert aks-ingress-tls.crt
#
# az group delete --name rg-aks --yes --no-wait
#######################################################################################################################################

## Connect to the cluster
az aks get-credentials \
 --resource-group rg-privateendpoint-uae \
 --name aks-privateendpoint-tst-uae
#

# Set variable for ACR location to use for pulling images
az aks update -n aks-privateendpoint-tst-uae -g rg-privateendpoint-uae --attach-acr myacr

kubectl delete -n ingress-basic
helm uninstall 
helm list
kubectl delete ClusterRoleBinding ingress-basic-itom-kubernetes-vault-binding
kubectl show ClusterRoleBinding
#For my case the issue was with ingressclass existed already. I have simply deleted the ingresclass and it worked like a charm.
kubectl get ingressclass --all-namespaces
#This will return the name of already existing ingressclass. For my case, it was nginx. Delete that ingressclass.
kubectl delete ingressclass nginx --all-namespaces

# Run the following command get a list of all events that occurred in the namespace:
kubectl get events --sort-by='{.lastTimestamp}' -n ingress-basic

## Create Kubernetes secret for the TLS certificate
kubectl create secret tls star-myacr-com \
    --namespace default \
    --key STAR_myacr_com.key \
    --cert star-myacr-com.crt
#
###################################################################################################################
###################################################################################################################
###################################################################################################################
###################################################################################################################
## Test the ingress configuration
curl -v -k --resolve eptest.myacr.com:9443:20.74.242.226 https://eptest.myacr.com
curl -k -H "Host: eptest.myacr.com" https://20.233.4.246
curl -k -H "Host: website.com" https://20.233.4.246

###################################################################################################################
# Deploy Angular by pushing YAML file
kubectl apply -f auth.yml
kubectl apply -f myapp.yml
kubectl apply -f nginx-conf.yml -f angular.yml -f angular_ingress.yml

alias k=kubectl
kubectl describe pod angular-7bcb8dc9d4-j9hvr
# Display all reousces with a label:
kubectl get deploy,po,svc,cm,ing,pvc -l env=auth-test
kubectl get deploy,po,svc,cm,ing,pvc -l env=myapp-test
kubectl get deploy,po,svc,cm,ing -l env=angular-test
kubectl get po
kubectl exec -it angular-5f5979ffd9-9vb8s sh
# Diagnosing 
kubectl describe po myapp-55585c589d-vxwvv
kubectl get po angular-8cf8c456c-wq587 -o yaml
kubectl logs myapp-5686fdbff5-xjr2f
kubectl logs angularapp-65c46c8999-8x9vl -f   # To check logs in real time
# Delete all resources with a label:
kubectl delete deploy,po,svc,cm,ing,pvc -l env=auth-test
kubectl delete deploy,po,svc,cm,ing,pvc -l env=myapp-test
kubectl delete deploy,po,svc,cm,ing -l env=angular-test

# Test application is working well AND
# Execute a command inside a pod
kubectl exec -it apigateway-6d65757dd9-75k79 -- sh
kubectl exec -it angular-789b9fbb89-jr6gd -- netstat -lntu

kubectl exec -it drugservice-598857f59d-x4hsh -- curl -k https://angular.svc.default.cluster.local
kubectl exec -it angularapp-65c46c8999-8x9vl -- curl -k -v https://angular.default.svc.cluster.local:9443
kubectl exec -it angular-789b9fbb89-jr6gd -- sh

kubectl exec -it angular-789b9fbb89-jr6gd -- curl -k https://localhost:9443
kubectl exec -it angular-789b9fbb89-jr6gd -- curl -k http://localhost
kubectl exec -it angular-65976c986c-klvjb -- ls /usr/share/nginx/html
kubectl exec -it website-deployment-766bc76dc8-6kntx -- curl -k https://localhost:8443

# Once I deleted the ValidatingWebhookConfiguration, my helm installation went flawlessly.
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission


# Create a secret in Kubernetes cluster AKS:
kubectl create secret tls backend-tls --key="backend.key" \
 --cert="backend.crt"
#

# Create a root certificate in an applicatin gateway:
applicationGatewayName=waf-aks
resourceGroup=rg-privateendpoint-uae
az network application-gateway root-cert create \
    --gateway-name waf-aks  \
    --resource-group MC_Production_Env-Production_germanywestcentral \
    --name backend-tls \
    --cert-file backend.crt
#

az network application-gateway ssl-cert create --gateway-name WAF-AKS \
 -n Frontend \
 -g MC_Production_Env-Production_germanywestcentral \
 --cert-file C:/Users/Hazem/.devops/Angular/star-myacr-com.pfx \
 --cert-password xxxxxxxxxxx
 --no-wait
#                   

# Get .pfx file from .crt & .key:
openssl pkcs12 -inkey STAR_myacr_com.key -in star-myacr-com.crt -export -out star-myacr-com.pfx
Pwd:xxxxxxxxxxx

# List root certificate in an application gateway:
az network application-gateway root-cert list --gateway-name WAF-AKS \
 -g MC_Production_Env-Production_germanywestcentral
#

# Delete a backend root certificate from application gateway:
az network application-gateway root-cert delete --gateway-name WAF-AKS \
 -n backend-tls \
 -g MC_Production_Env-Production_germanywestcentral
#     

# List all frontend certificates in an application gateway:
az network application-gateway ssl-cert list --gateway-name WAF-AKS \
 -g MC_Production_Env-Production_germanywestcentral
#                                             

# Delete a frontend certificate from application gateway:
az network application-gateway ssl-cert delete --gateway-name WAF-AKS \
 -n Frontend \
 -g MC_Production_Env-Production_germanywestcentral
#      

# Change directories  CD
C:\Users\Hazem\Desktop\Cert\Newfolder\New folder
cd C:/Users/Hazem/Desktop/Cert/Purchased\ Cert/


# Use "kubectl api-resources" 
# for a complete list of supported resources.
kubectl api-resources

NAMESPACE=ingress-basic

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --create-namespace \
  --namespace $NAMESPACE \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz
#
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace default \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
#

$ kubectl --namespace ingress-basic get services -o wide -w nginx-ingress-ingress-nginx-controller

helm install 4.1.2 ingress-nginx/ingress-nginx



helm install ingress-nginx ingress-nginx/ingress-nginx  \
--create-namespace
--namespace $NAMESPACE \
--set controller.ingressClassResource.name=nginx-two \
--set controller.ingressClassResource.controllerValue="example.com/ingress-nginx-2" \
--set controller.ingressClassResource.enabled=true \
--set controller.ingressClassByName=true


