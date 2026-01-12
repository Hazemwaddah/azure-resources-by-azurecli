# Private DNS zone

# Create the resource group
#az group create --name MyAzureResourceGroup --location uaenorth

# Create a private DNS zone
#az network vnet create \
#  --name myAzureVNet \
#  --resource-group MyAzureResourceGroup \
#  --location uaenorth \
#  --address-prefix 10.2.0.0/16 \
#  --subnet-name backendSubnet \
#  --subnet-prefixes 10.2.0.0/24

az network private-dns zone create -g MyAzureResourceGroup \
   -n api-eptest.mycompany.com

az network private-dns link vnet create -g MyAzureResourceGroup -n MyDNSLink  \
   -z api-eptest.mycompany.com -v rg-privateendpoint-uae-vnet \
   -e true
#

# List DNS private zones
#az network private-dns zone list \
#  -g MyAzureResourceGroup
#

# List DNS private zones in the subscription
#az network private-dns zone list

# Create an additional DNS record
az network private-dns record-set a add-record \
  -g MyAzureResourceGroup \
  -z api-eptest.mycompany.com \
  -n api-eptest \
  -a 20.216.51.180
#





