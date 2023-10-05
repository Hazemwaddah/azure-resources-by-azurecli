# WAF with URL routing
################## 
#In this article
#Prerequisites
#Create a resource group
#Create network resources
#Create the application gateway
#Create virtual machine scale sets
#Create a CNAME record in your domain
#Test the application gateway
#Clean up resources
#Next steps
# Cases to add a server in the backend pool of application gateway:-
# 1- add a server in the same resource group & virtual network
# 2- add a server in the same resource group but in a different virtual network.
# 3- add a server in a different resource group & virtual network. 
# All cases are applicable. The rule is: If there is IP connectivity between them, then it can be added to the backend pool, even in 
# a different resource group, location, datacenter, virtual network, ... etc.

## Important notes: -
## 1- After the file is finished and created resources, I have to manually add the ip addresses of the vmss to the backend
## pool [only in the case of different resource group & Virtual network at the same time]. This is done automatically in the other cases.
## 2- When deploying resources in different virtual networks, peering connections between two networks should be established to enable connectivity.
#######################################################################################################################################
# Create a resource group
az group create --name rg-waf --location germanywestcentral

az group delete -n rg-waf --yes

#region Create Virtual Network
az network vnet create \
  --name WAF-VNET \
  --resource-group rg-waf \
  --location germanywestcentral \
  --address-prefix 10.0.0.0/16 \
  --subnet-name myAGSubnet \
  --subnet-prefix 10.0.1.0/24

az network vnet subnet create \
  --name myBackendSubnet \
  --resource-group rg-waf \
  --vnet-name WAF-VNET \
  --address-prefix 10.0.2.0/24

az network public-ip create \
  --resource-group rg-waf \
  --name waf-pip \
  --allocation-method Static \
  --sku Standard
#endregion

#region Create the app gateway with a URL map
az network application-gateway create \
  --name WAF \
  --location germanywestcentral \
  --resource-group rg-waf \
  --vnet-name WAF-VNET \
  --subnet myAGsubnet \
  --capacity 2 \
  --sku Standard_v2 \
  --http-settings-cookie-based-affinity Disabled \
  --frontend-port 80 \
  --http-settings-port 80 \
  --http-settings-protocol Http \
  --public-ip-address waf-pip
#endregion

#region Add image and video backend pools and a port
az network application-gateway address-pool create \
  --gateway-name WAF \
  --resource-group rg-waf \
  --name imagesBackendPool

az network application-gateway address-pool create \
  --gateway-name WAF \
  --resource-group rg-waf \
  --name videoBackendPool

az network application-gateway frontend-port create \
  --port 8080 \
  --gateway-name WAF \
  --resource-group rg-waf \
  --name port8080
#endregion

#region Add a backend listener
az network application-gateway http-listener create \
  --name backendListener \
  --frontend-ip appGatewayFrontendIP \
  --frontend-port port8080 \
  --resource-group rg-waf \
  --gateway-name WAF
#endregion

#region Add a URL path map
az network application-gateway url-path-map create \
  --gateway-name WAF \
  --name myPathMap \
  --paths /images/* \
  --resource-group rg-waf \
  --address-pool imagesBackendPool \
  --default-address-pool appGatewayBackendPool \
  --default-http-settings appGatewayBackendHttpSettings \
  --http-settings appGatewayBackendHttpSettings \
  --rule-name imagePathRule

az network application-gateway url-path-map rule create \
  --gateway-name WAF \
  --name videoPathRule \
  --resource-group rg-waf \
  --path-map-name myPathMap \
  --paths /video/* \
  --address-pool videoBackendPool
#endregion

#region Add a routing rule
az network application-gateway rule create \
  --gateway-name WAF \
  --name rule1 \
  --resource-group rg-waf \
  --http-listener backendListener \
  --rule-type PathBasedRouting \
  --url-path-map myPathMap \
  --address-pool appGatewayBackendPool
#endregion

#region Create virtual machine scale sets
az group create --name rg-waf-vmss --location germanywestcentral

az network vnet create \
  --name WAF-VMSS \
  --resource-group rg-waf-vmss \
  --location germanywestcentral \
  --address-prefix 172.20.0.0/16 \
  --subnet-name myBackendSubnet \
  --subnet-prefix 172.20.1.0/24
#

for i in `seq 1 3`; do

  if [ $i -eq 1 ]
  then
    poolName="appGatewayBackendPool" 
  fi

  if [ $i -eq 2 ]
  then
    poolName="imagesBackendPool"
  fi

  if [ $i -eq 3 ]
  then
    poolName="videoBackendPool"
  fi

  az vmss create \
    --name myvmss$i \
    --resource-group rg-waf-vmss \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password Azure123456! \
    --instance-count 2 \
    --vnet-name WAF-VMSS \
    --subnet myBackendSubnet \
    --vm-sku Standard_B1ms \
    --upgrade-policy-mode Automatic \
    --public-ip-per-vm \
    --backend-pool-name $poolName
done
#endregion

#region Install NGINX
for i in `seq 1 3`; do
  az vmss extension set \
    --publisher Microsoft.Azure.Extensions \
    --version 2.0 \
    --name CustomScript \
    --resource-group rg-waf-vmss \
    --vmss-name myvmss$i \
    --settings '{ "fileUris": ["https://raw.githubusercontent.com/Azure/azure-docs-powershell-samples/master/application-gateway/iis/install_nginx.sh"], "commandToExecute": "./install_nginx.sh" }'
done
#endregion



az network public-ip show \
  --resource-group myResourceGroupAG \
  --name myAGPublicIPAddress \
  --query [dnsSettings.fqdn] \
  --output tsv



