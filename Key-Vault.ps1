# Create a resource group
# Create a key vault


# Install Azure cli on Linux
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

ssh -i /.ssh/privatekey thadmin@20.216.36.231

az keyvault secret list [--id]
                        [--include-managed {false, true}]
                        [--maxresults]
                        [--vault-name]
#


# Create a resource group
az group create --name "rg-compliance" --location germanywestcentral

# Create a key vault
az keyvault create --name th-Test-kv \
 --resource-group "rg-kv-test" \
 --location germanywestcentral
#

# Clean up resources
az group delete --name "rg-kv"

az login
az keyvault secret list --vault-name kv-tst
az keyvault secret list --vault-name th-kv-testing
az keyvault secret list --vault-name MainVaults

# Show command shows the value of the secret, whereas List doesn't.
az keyvault secret show --id https://kv-tst.vault.azure.net/secrets/MySecretName \
 --name MySecretName 
#

az keyvault secret show --name MySecretName \
  --vault-name kv-tst \
  --query "value"
#

# Resolve DNS name 
kv-tst.vault.azure.net

# Update a secret
az keyvault secret set-attributes [--content-type]
                                  [--enabled {false, true}]
                                  [--expires]
                                  [--id]
                                  [--name]
                                  [--not-before]
                                  [--tags]
                                  [--vault-name]
                                  [--version]
#                                   
az keyvault secret set-attributes \
 --id


# Show deleted secrets 
az keyvault secret show-deleted [--id]
[--name]
[--vault-name]


# List all soft-delted key vaults:
az keyvault list-deleted --subscription [REDACTED-SUBSCRIPTION-ID] \
 --resource-type vault
#

# Recover a soft-deleted key vault:
az keyvault recover --subscription [REDACTED-SUBSCRIPTION-ID] \
 -n kv-tst
#

# Purge a soft-deleted key vault:
az keyvault purge --subscription [REDACTED-SUBSCRIPTION-ID] \
 -n th-kv-testing
#