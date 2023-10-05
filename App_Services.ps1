# Create a resource group
# Create an app service plan
# Create a web app

az group create -n rg-waf -l uaenorth

az appservice plan create --name rg-waf-plan \
  --resource-group rg-waf \
  --sku s1 \
  --is-linux
#

az webapp create -g rg-waf \
  -p rg-waf-plan \
  -n app-service-myapp \
  --runtime "DOTNETCORE:6.0"
#

az webapp up -g rg-waf \
  -p rg-waf-plan \
  --runtime "JAVA:11-java11"
#

# Add a deployment slot:
az webapp deployment slot create --name app-service-myapp \
  -g rg-waf \
  --slot staging
#
az webapp delete --name app-service-myapp --resource-group rg-waf

# Delete a resource group:
az group delete -n rg-waf --yes

az group list -o table
az account show --output table
az account list -o table
az account set -s >[REDACTED-SUBSCRIPTION-ID]
# List all available frameworks:
az webapp list-runtimes

# Create an app service plan:
az appservice plan create --name
 --resource-group
 [--app-service-environment]
 [--hyper-v]
 [--is-linux]
 [--location]
 [--no-wait]
 [--number-of-workers]
 [--per-site-scaling]
 [--sku {B1, B2, B3, D1, F1, FREE, I1, I1v2, I2, I2v2, I3, I3v2, P1V2, P1V3, P2V2, P2V3, P3V2, P3V3, S1, S2, S3, SHARED, WS1, WS2, WS3}]
 [--tags]
 [--zone-redundant]
#


# Show app service plan:
az appservice plan show [--ids]
                        [--name]
                        [--resource-group]
#

# List app service plans:
az appservice plan list [--resource-group]


# List all free tier App Service plans.
az appservice plan list --query "[?sku.tier=='Free']"

# List all App Service plans for an App Service environment:
az appservice plan list --query "[?hostingEnvironmentProfile.name=='<ase-name>']"



# Update an app service plan.
az appservice plan update [--add]
                          [--elastic-scale {false, true}]
                          [--force-string]
                          [--ids]
                          [--max-elastic-worker-count]
                          [--name]
                          [--no-wait]
                          [--number-of-workers]
                          [--remove]
                          [--resource-group]
                          [--set]
                          [--sku {B1, B2, B3, D1, F1, FREE, I1, I1v2, I2, I2v2, I3, I3v2, P1V2, P1V3, P2V2, P2V3, P3V2, P3V3, S1, S2, S3, SHARED, WS1, WS2, WS3}]
#

