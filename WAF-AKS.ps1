
#rg: rg-privateendpoint-uae
#vnet:  rg-privateendpoint-uae-vnet
#aks:  aks-privateendpoint-tst-uae
# ./WAF-AKS.ps1
# cd C:/Users/Hazem/Desktop/PowerShell

# Create Resource group
az group create -n rg-waf --location germanywestcentral
az group delete -n rg-waf --yes

# Create The Application Gateway
az network application-gateway create \
  --name WAF-AKS \
  --location germanywestcentral \
  --resource-group MC_Production_Env-Production_germanywestcentral \
  --vnet-name aks-vnet-15581559 \
  --subnet GW_subnet \
  --capacity 2 \
  --sku WAF_v2 \
  --http-settings-cookie-based-affinity Disabled \
  --frontend-port 80 \
  --http-settings-port 80 \
  --http-settings-protocol Http \
  --priority 1000 \
  --public-ip-address waf-aks-pip
#endregion

#region Add AKS backend pool
az network application-gateway address-pool create \
  --gateway-name waf-aks \
  --resource-group rg-privateendpoint-uae \
  --name aks
# 
#endregion

#region Add a backend listener
  az network application-gateway http-listener create \
  --name aksListener \
  --frontend-ip appGatewayFrontendIP \
  --frontend-port appGatewayFrontendPort \
  --resource-group rg-privateendpoint-uae \
  --gateway-name waf-aks \
  --host-name eptest.mycompany.com
#

# Enable ingress controller on the kubernetes cluster:-
appgwId=$(az network application-gateway show -n waf-aks -g MC_Production_Env-Production_germanywestcentral -o tsv --query "id") 
az aks enable-addons -n Env-Production -g MC_Production_Env-Production_germanywestcentral -a ingress-appgw --appgw-id $appgwId


# az aks disable-addons -n aks-privateendpoint-tst-uae -g rg-privateendpoint-uae  -a ingress-appgw #--appgw-id $appgwId

# kubectl get ingress


#az network application-gateway stop -n waf-aks -g rg-privateendpoint-uae
#az network application-gateway start -n waf-aks -g rg-privateendpoint-uae


#az aks stop --name aks-privateendpoint-tst-uae --resource-group rg-privateendpoint-uae
#az aks start --name aks-privateendpoint-tst-uae --resource-group rg-privateendpoint-uae

#az network application-gateway delete -n waf-aks -g rg-privateendpoint-uae



# List all TLS certificates in application gateway
az network application-gateway ssl-cert list -g rg-privateendpoint-uae --gateway-name waf-aks

# Delete a certificate from application gateway
az network application-gateway ssl-cert delete -g rg-privateendpoint-uae --gateway-name waf-aks -n cert-default-frontend-tls



## Manage Trusted root certificates in application gateway
#az network application-gateway root-cert create -g rg-privateendpoint-uae --gateway-name waf-aks --name root
#
az network application-gateway root-cert delete -g rg-privateendpoint-uae --gateway-name waf-aks --name chain
az network application-gateway root-cert list -g rg-privateendpoint-uae --gateway-name waf-aks
#az network application-gateway root-cert show -g rg-privateendpoint-uae --gateway-name waf-aks --name root


#az network application-gateway root-cert create \
# --cert-file C:/Users/Hazem/Desktop/Cert/Newfolder \
# --gateway-name waf-aks \
# --name root.cer \
# --resource-group rg-privateendpoint-uae
#

# WAF_Certificate

# Certificate configuration in Application Gateway v2
#az network application-gateway root-cert create \
#      --cert-file C:/Users/Hazem/Desktop/Cert/Newfolder/star.mycompany.com.ca-bundle \
#      --resource-group MC_Production_Env-Production_germanywestcentral \
#      --gateway-name WAF-website \
#      --name star-mycompany-com
#


#az network application-gateway root-cert create \
#      --cert-file C:/Users/Hazem/AppData/Roaming/Microsoft/SystemCertificates/My/Certificates \
#      --resource-group MC_Production_Env-Production_germanywestcentral \
#      --gateway-name WAF-website \
#      --name star-mycompany-com
#


#az network application-gateway auth-cert list -g  rg-privateendpoint-uae     --gateway-name waf-aks


az network application-gateway stop -g rg-privateendpoint-uae -n waf-aks
az network application-gateway start -g rg-privateendpoint-uae -n waf-aks

