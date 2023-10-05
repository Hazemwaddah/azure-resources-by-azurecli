########################### Azure CLI Task execution ###################
#region  Connect to Azure
az 
az login
az login --use-device-code  
Get-Service "alg" # | Remove-Service
az --version
## Display active accounts ################################
az account show --output table
az account list
az account list --all --output table
az find "az account"
az dms list
az account set --subscription xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
az logout
#endregion

#region ############################################## Resource Group ######################################################################
az group create --name elk-stack --location francecentral       # Create a resource group
az group list --query "[].{name:name}" -o table                 # List All resource groups
az group exists -g MyResourceGroup                              # Check for a specific resource group
az group export --resource-group myresourcegroup                # Capture resource group as a template export
Scopes
/subscriptions
    /{subscriptionId}
        /resourcegroups
            /{resourceGroupName}
                /providers
                    /{providerName}
                        /{resourceType}
                            /{resourceSubType1}
                                /{resourceSubType2}
                                    /{resourceName}
#endregion 


##############################################################################################################################################
#region ##################################################### Users ###########################################################
########################################################### List ALL AD users ###########################################################
az ad user list --query "[].{displayName: displayName, userPrincipalName: userPrincipalName, objectId: objectId, userType: userType}" --output table   # List ALL users
az ad signed-in-user show                       # Shows all details about signed-in user
az role definition list  -o table               # List ALL role defninitions
az role assignment list --all --assignee "emergency_myapp.com#EXT#@myappfzllc.onmicrosoft.com" -o table  # List All roles for a specific user
az role assignment list --all -o tsv  # List All roles for All users
##############################################################################################################################################
########################################################### Creat a new user ###########################################################
az ad user create --display-name Power_BI \
  --password W@K94He2d54vD \
  --user-principal-name "xxxxxx@live.com" \
  --mail-nickname Power_bi 
  --force-change-password-next-login $false
#
az ad user show --id "xxxxxx@live.com" --query "objectId" --output table       # Display objectId using name/mail
az ad user show --id 80e6f41a-921b-4bf0-b841-de00c1aec695                    # Display user details
az ad user list --query "[].{displayName: displayName, userPrincipalName: userPrincipalName, objectId: objectId, userType: userType}" --output table   # List ALL users
##############################################################################################################################################
######################################################## Assign an Azure AD role ######################################################
az role definition list  -o table               # List ALL role defninitions
######################################################## Assign an Azure AD role ######################################################
# Resource scope
az role assignment create --assignee "{assignee}" --role "{roleNameOrId}" --scope "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceSubType}/{resourceName}"
# Resource group scope
az role assignment create --assignee "{assignee}" --role "{roleNameOrId}" --resource-group "{resourceGroupName}"
# Subscription scope
az role assignment create --assignee "{assignee}" --role "{roleNameOrId}" --subscription "{subscriptionNameOrId}"
# Management groups scope
az role assignment create --assignee "{assignee}" --role "{roleNameOrId}" --scope "/providers/Microsoft.Management/managementGroups/{managementGroupName}"
# Examples Assign a user at resource group scope
az role assignment create --assignee "patlong@contoso.com" --role "Virtual Machine Contributor" --resource-group "pharma-sales"
az role assignment create --assignee 80e6f41a-921b-4bf0-b841-de00c1aec695 --scope "/subscriptions/>[REDACTED-SUBSCRIPTION-ID]/resourceGroups/rg-azure-b2c-gwc/providers/Microsoft.AzureActiveDirectory/b2cDirectories/myappinc.onmicrosoft.com" --role "Contributor"
##############################################################################################################################################
######################################################## List members of a group #################################################
az ad group member list --group "cluster_users" --query "[].{displayName: displayName, userPrincipalName: userPrincipalName, objectId: objectId}" --output table
az ad group list                                # List groups
az ad group show --group "cluster_users"       # Get info. about a group using name
## Get service priniciples ojbectId
az ad sp list --all --query "[].{displayName:displayName, objectId:objectId}" --output table      # List All service prinicipals
##############################################################################################################################################
################################ Display examples in the of a speific command in AI Knowldge base  #########################################
az find "az ad user"        # To search AI knowledge base for examples, use: az find "az ad user"
az ad user --help          # To get help about the command
#endregion

##############################################################################################################################################
#region ####################################################  key vault ######################################################################

az keyvault create --location germanywestcentral --name th-kv-testing --resource-group General
## reject a private endpoint connection request for a key vault using vault name and connection name #######################3
name = (az keyvault show -n mykv --query "privateEndpointConnections.name")
az keyvault private-endpoint-connection reject -g myrg --vault-name mystorageaccount --name $name
az find "az keyvault role assignment"
#az keyvault role assignment list --hsm-name myhsm -o table           # List role assignements for a vault
az find "az keyvault set-policy" 
az keyvault show -n th-kv-testing 
az keyvault role assignment list --id 89d6d230-8753-4476-a0f6-20a5d7b05440 # -o table           # List role assignements for a vault
az keyvault role assignment list --id https://th-kv-testing.vault.azure.net/ # -o table           # List role assignements for a vault
az keyvault role assignment create --assignee "xxxxxx@live.com" --hsm-name myhsm --role {key vault administratr} --scope "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/General/providers/Microsoft.KeyVault/vaults/th-kv-testing"
az keyvault role assignment delete --assignee-object-id "xxxxxx@live.com" --hsm-name myhsm      # Delete user role assignment Vault
az KeyVault set-policy -n th-kv-testing --upn "xxxxxx@live.com" --key-permissions get list encrypt backup  --secret-permissions list backup --certificate-permissions  list get # Add access policy for a user to a vault
az keyvault set-policy -n th-kv-testing --spn 8f8c4bbd-485b-45fd-98f7-ec6300b7b4ed --key-permissions decrypt sign --secret-permissions get --certificate-permissions  list get  # Authorizing an application to access a key, secret, or certificate
###################################################### key vault scope ##################################################################
--scope "/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/providers/{providerName}/{resourceType}/{resourceSubType}/{resourceName}"
--scope /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/General/providers/Microsoft.KeyVault/vaults/th-kv-testing
az keyvault list #--output table           # List all key vaults in the subscription
az keyvault key create --vault-name "ContosoKeyVault" --name "ContosoFirstKey" --protection software   # Add a key to the vault
az keyvault secret set --vault-name "ContosoKeyVault" --name "SQLPassword" --value "hVFkk965BuUv "     # Add a secret to the vault
az keyvault update -n "th-kv-testing" -g "General"  --enabled-for-disk-encryption "true"   # Enable key vault for Azure disk encryption 
az keyvault update -n "th-kv-testing" -g "General"  --public-network-access disabled # Deny public access for a key vault 
az keyvault update --name th-kv-testing
                   [--add]
                   [--bypass {AzureServices, None}]
                   [--default-action {Allow, Deny}]
                   [--enable-purge-protection {false, true}]
                   [--enable-rbac-authorization {false, true}]
                   [--enable-soft-delete {false, true}]
                   [--enabled-for-deployment {false, true}]
                   [--enabled-for-disk-encryption {false, true}]
                   [--enabled-for-template-deployment {false, true}]
                   [--force-string]
                   [--no-wait]
                   [--public-network-access {Disabled, Enabled}]
                   [--remove]
                   [--resource-group]
                   [--retention-days]
                   [--set]
                   [--subscription]
################################################## Roles for Key Vault ###############################################################
key vault administrator               00482a5a-887f-4fb3-b363-3b7fe8e74483
key vault Reader                      21090545-7ca7-4776-b22c-e363652d74d2
key vault secret user                 4633458b-17de-408a-b874-0445c86b69e6
#endregion


############################################################### Random ##########################################################
az network nsg list| Out-GridView
az interactive
az vm --help







