# Create a resource group
# Create a new service
# Check the status of the deployment
# Clean up resources

# Examples of the help
az find "az apim"

# Create a resource group
az group create -n rg-api --location northeurope

# Create a new service
az apim create -n THAPI \
  -g rg-api \
  --publisher-name Live \
  --publisher-email hxxxxxxxxxx@live.com \
  --sku-name Consumption \
  --no-wait
#

# Check the status of the deployment
az apim show -n THAPI \
 -g rg-api \
 --output table
#

# Delete an API management intance
az apim delete -n THAPI \
 -g rg-api \
 --no-wait \
 --yes
#

# Purge API management service
az apim deletedservice purge -l northeurope \
 --service-name THAPI
#

# List all API deleted services
az apim deletedservice list

# Show an API deleted service
az apim deletedservice show -l northeurope  \
 --service-name THAPI
#

# Check to see if the name is in use
az apim check-name -n THAPI

# Clean up resources
az group delete -n rg-api --yes

# Show a given soft-deleted instance by name
GET https://management.azure.com/subscriptions/>[REDACTED-SUBSCRIPTION-ID]/providers/Microsoft.ApiManagement/locations/NorthEurope/deletedservices/THAPI?api-version=2021-08-01

# List all API management soft-deleted instances for a given subscription:
GET https://management.azure.com/subscriptions/>[REDACTED-SUBSCRIPTION-ID]/providers/Microsoft.ApiManagement/deletedservices?api-version=2021-08-01



curl https://thapi.azure-api.net/api/Products
curl --header "Ocp-Apim-Subscription-Key: xxxxxxxxxxxxxxxxxxxxxxxxx" https://thapi.azure-api.net/api/Products
curl --header "Ocp-Apim-Subscription-Key: xxxxxxxxxxxxxxxxxxxxxxxxx" https://thapi.azure-api.net/api/Products

