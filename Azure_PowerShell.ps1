########################### PowerShell Task execution ###################
## 
#region  Connect to Azure
Connect-AzAccount
Connect-AzAccount -AuthScope MicrosoftGraphEndpointResourceId 
Connect-AzureAD
Connect-ExchangeOnline            # Connect to Office 365 admin center
Disconnect-AzAccount
## Set Subscription in con
Set-AzContext -TenantId xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx -SubscriptionId xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
## Authenticate using:     xxxxxxxxx@live.com

Disconnect-AzAccount
#endregion

#region    find id (user, group, service principal,...)

## List user object id
Get-AzADUser -StartsWith hazem
(Get-AzADUser -DisplayName <userName>).id
## List gourp object id
Get-AzADGroup -SearchString cluster
(Get-AzADGroup -DisplayName <groupName>).id
## List service principal id
Get-AzADServicePrincipal -SearchString a
(Get-AzADServicePrincipal -DisplayName <principalName>).id
## List Managed identity
Get-AzADServicePrincipal -SearchString a
(Get-AzADServicePrincipal -DisplayName <principalName>).id

## List all built-in roles alongside their role ids
Get-AzRoleDefinition | Format-Table -Property Name, IsCustom, Id, Description
#Get-AzRoleAssignment -Scope "/subscriptions/<subscription_id>/resourcegroups/<resource_group_name>/providers/<provider_name>/<resource_type>/<resource>

## Get Tenant ID
Get-AzTenant

#endregion

#region    Create a user 

## create a variable (for Password object creation) in PowerShell with that type:
$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "xxxxxxxxxx"   # Set value of Password
$PasswordProfile.EnforceChangePasswordPolicy

## Finally pass this variable to the cmdlet:
New-AzureADUser -AccountEnabled $true -DisplayName "Hazem.Waddah" -PasswordProfile $passwordprofile -City Cairo -Country Egypt -GivenName Hazem -JobTitle "Security Expert" -MailNickName Hazem.Waddah -PasswordPolicies "DisablePasswordExpiration" -Surname Khedr -UserPrincipalName xxxxxxxxxx@live.onmicrosoft.com -UserType Member
import-Module AzureAD
Connect-AzureAD
# Lookup for a specific user in Azure AD
Get-AzureADUser -SearchString hwaddah
#_xxxxxx@live.onmicrosoft.com|Out-GridView

# Remove user from Azure AD (ObjectId only)
Remove-AzureADUser -ObjectId 7083282d-427c-4985-b78e-13ab96b97be6

## Verify User is created by displaying users in Azure AD
Get-AzureADUser |Out-GridView

#endregion

#region    Assign roles to a user

# Assign roles to an AzureAD user
$user = Get-AzureADUser -Filter "userPrincipalName eq 'xxxxxx@live.onmicrosoft.com'"
$roleDefinition = Get-AzureADMSRoleDefinition -Filter "displayName eq 'Global Reader'"
$roleAssignment = New-AzureADMSRoleAssignment -DirectoryScopeId '/' -RoleDefinitionId $roleDefinition.Id -PrincipalId $user.objectId
## Important Notes: both words in role should be starting with CAPs 
## Ex."Security Administrator
## NOT "security administrator,Security administrator".

## List all role assignments for a specific user IAM-RBAC
Get-AzRoleAssignment -SignInName xxxxxx@live.onmicrosoft.com |Out-GridView
Get-AzRoleAssignment -SignInName xxxxxx@live.com

## List all role assignments for a specific user Azure AD
## First, you need to run this command: Connect-AzureAD
## direct/transitive (from group)

#Get the user
$userId = (Get-AzureADUser -Filter "userPrincipalName eq 'xxxxxx@live.onmicrosoft.com'").ObjectId

#Get direct role assignments to the user
$directRoles = (Get-AzureADMSRoleAssignment -Filter "principalId eq '$userId'").RoleDefinitionId
$roleAssignableGroups = (Get-AzureADMsGroup -All $true | Where-Object IsAssignableToRole -EQ 'True').Id
Connect-MgGraph -Scopes "User.Read.All”
$uri = "https://graph.microsoft.com/v1.0/directoryObjects/$userId/microsoft.graph.checkMemberObjects"
$userRoleAssignableGroups = (Invoke-MgGraphRequest -Method POST -Uri $uri -Body @{"ids"= $roleAssignableGroups}).value
$transitiveRoles=@()
foreach($item in $userRoleAssignableGroups){
    $transitiveRoles += (Get-AzureADMSRoleAssignment -Filter "principalId eq '$item'").RoleDefinitionId
}
$allRoles = $directRoles + $transitiveRoles

AzureAD\Get-AzureADUserAppRoleAssignment -ObjectId 89d6d230-8753-4476-a0f6-20a5d7b05440

# Remove roles from an AzureAD user
Remove-AzureADUserAppRoleAssignment -AppRoleAssignmentId "billing administrator" -ObjectId 7083282d-427c-4985-b78e-13ab96b97be6

# Remove ALL roles from an AzureAD user
Remove-AzureADUserAppRoleAssignment -AppRoleAssignmentId "*" -ObjectId 7083282d-427c-4985-b78e-13ab96b97be6

#endregion

#region    Add a user to a group

AzureAD\Add-AzureADGroupMember -ObjectId c29577ef-1989-42d8-b856-8bc0174d0a7c -RefObjectId 771f365b-8cd6-47a0-b31a-c75e267431d9
AzureADPreview\Add-AzureADGroupMember -ObjectId c29577ef-1989-42d8-b856-8bc0174d0a7c -RefObjectId 771f365b-8cd6-47a0-b31a-c75e267431d9
## ObjectId Group ID, and RefObjectId is user ID

#Get the user
$userId = (Get-AzureADUser -Filter "userPrincipalName eq 'xxxxxx@live.com'").ObjectId

#Get direct role assignments to the user
$directRoles = (Get-AzureADMSRoleAssignment -Filter "principalId eq '$userId'").RoleDefinitionId

#endregion

#region   Display encryption policy 

Connect-ExchangeOnline # -UserPrincipalName xxxxxx@live.com
Get-ManagementRole -Cmdlet Get-OMEMessageStatus
Get-DataEncryptionPolicy
Disconnect-ExchangeOnline
Get-DataEncryptionPolicy -Identity "Europe Mailboxes"
Get-OMEMessageStatus
   -MessageId <String>
   [<CommonParameters>]
Get-Command *OME*
#endregion

#region    List permissions of an Azure resource

Get-AzRoleAssignment | Where-Object {$_.Scope -eq "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/storage-test-rg/providers/Microsoft.Storage/storageAccounts/storagetest0122"}

#endregion

#region    use a .json template to deploy a Windows VM src: github
           # using Azure resource group deployment

#use this command when you need to create a new resource group for your deployment
New-AzResourceGroup -Name <resource-group-name> -Location <resource-group-location> 
# use this command for deployment
New-AzResourceGroupDeployment -ResourceGroupName General -TemplateUri https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/quickstarts/microsoft.compute/vm-simple-windows/azuredeploy.json
# Try to deploy from a local file
New-AzResourceGroupDeployment -ResourceGroupName rg-sql -TemplateUri http://127.0.0.1/c$/Users/Hazem/Downloadsvm-quick-template.json # C:\Users\Hazem\Downloads\vm-quick-template.json
                                                                      #http://localhost/c$/Users/Hazem/Downloadsvm-quick-template.json
#endregion

#region    Handling Azure KeyVault

# Set variables
$resourceGroupName = "rg-sql"
$storageAccountName = "storageaccountuseast"
$keyVaultName = "main-testing-vault" 
$keyVaultSpappId = "[REDACTED]"
$storageAccountKey = "key1"

# Get user Id
$userId = (Get-AzContext).Account.Id

# Get a reference to your Azure Storage Account
$storageAccount = Get-AzStorageAccount `
-ResourceGroupName $resourceGroupName `
-StorageAccountName $storageAccountName

# Give key vault access to your storage account
# Assign RBAC role "Storage Account Operator Service Role" to key vault
New-AzRoleAssignment -ApplicationId $keyVaultSpappId `
-RoleDefinitionName 'Storage Account Key Operator Service Role' `
-Scope $storageAccount.Id


# Give your user principal access to all storage account permissions, on your key vault instance
Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -UserPrincipalName $userId `
-PermissionsToStorage get, list, delete, set, update, regeneratekey, getsas, listsas, deletesas, recover, backup, restore, purge

# Enable Key regeneration
$regenPeriod = [system.Timespan]::FromDays(3)
Add-AzKeyVaultManagedStorageAccount -VaultName $keyVaultName -AccountName $storageAccountName `
-AccountResourceId $storageAccount.Id -ActiveKeyName $storageAccountKey -RegenerationPeriod $regenPeriod

Remove-AzRoleAssignment -ApplicationId $keyVaultSpappId ` 
-RoleDefinitionName 'Storage Account Contributor' `
-Scope $storageAccount.Id

## Remove ALL access policies from AKV
Remove-AzKeyVaultAccessPolicy -VaultName main-testing-vault

#endregion

#region    Give user access to Storage account

# Set variables
$resourceGroupName = "rg-sql"
$storageAccountName = "storageaccountuseast"
$keyVaultName = "main-testing-vault" 
$keyVaultSpappId = "[REDACTED]"
$storageAccountKey = "key1"

# Get user Id
$userId = (Get-AzContext).Account.Id

# Get a reference to your Azure Storage Account
$storageAccount = Get-AzStorageAccount `
-ResourceGroupName $resourceGroupName `
-StorageAccountName $storageAccountName

# Give key vault access to your storage account
# Assign RBAC role "Storage Account Contributor Role" to key vault
New-AzRoleAssignment -ApplicationId $keyVaultSpappId `
-RoleDefinitionName 'Storage Account Contributor' `
-Scope $storageAccount.Id

# Give your user principal access to all storage account permissions, on your key vault instance
Set-AzKeyVaultAccessPolicy -VaultName $keyVaultName -UserPrincipalName $userId `
-PermissionsToStorage get, list, delete, set, update, regeneratekey, getsas, listsas, deletesas, recover, backup, restore, purge

# Enable Key regeneration
$regenPeriod = [system.Timespan]::FromDays(3)
Add-AzKeyVaultManagedStorageAccount -VaultName $keyVaultName -AccountName $storageAccountName `
-AccountResourceId $storageAccount.Id -ActiveKeyName $storageAccountKey -RegenerationPeriod $regenPeriod

#endregion

#region    List [users, services, cmdlts, modules,..]

# List users in Azure Portal (Azure AD)
Get-AzureADUser
Get-AzureADUser |Out-GridView

# List all services
Get-Service | Out-File C:\Services.txt

# List all services [CSV] excel
Get-Service | Export-csv C:\Services.csv

# List all services that are stopped
Get-Service | Where-Object {$_.Status -eq "stopped"}| Out-GridView

# List all services that are running
Get-Service | Where-Object {$_.Status -eq "running"}

# List all porperties, methods, aliases related to an object
Get-Service |Get-Member

# List all commands
Get-Command

# List all available modules
Get-Module
Get-Module -ListAvailable
Get-Module -ListAvailable |Out-GridView

# List all commands of a module Applocker
Get-Command -Module AppLocker
Get-Command -Module "az.*"     # lists all commands that starts with az
Get-Command -Module "az.websites"   

## Pipe formatting
Get-Service |Format-List *    # shows all of properties
Get-Service |Format-list displayname,  Status, RequiredServices
Get-Service |Format-table displayname,  Status, RequiredServices
Get-Service |sort-object -property status |Format-table displayname,  Status, RequiredServices

## Pipe output
Get-Service | Out-File C:\Services.txt
Get-Service | Export-csv C:\Services.csv

## Grid view
Get-Service |Out-GridView
Get-Service |Select-Object displayname, status, RequiredServices |Out-GridView
Get-Service |Select-Object * |Out-GridView

#endregion

#region    Create aliases

# Create a new aliase (gh) instead of get-help 
New-Alias -name "gh" Get-Help

# Get help on creating new aliases
Get-Help about_aliase

#endregion

#region    Connect to Office365

# Install AzureAD for Office365 module
Install-Module -Name azuread

## Load Exchange online module EXO V2
Import-Module ExchangeOnlineManagement

#endregion


#region######################################### Disable Microsoft Bit Defender service ####################################################
Set-MpPreference -DisableRealtimeMonitoring $true
#endregion

#region ############### How to Create a PowerShell Session on a Remote Computer ##################################################
# Enabling PowerShell Remoting on target machine
Enable-PSRemoting -Force
# Configure TrustedHosts [both machines]
winrm set winrm/config/client  '@{TrustedHosts="HMW-22"}'
winrm set winrm/config/client  '@{TrustedHosts="Windows-10-LAN"}'
# Restart WinRM Service
Restart-Service WinRM
# Test the Connection
Test-WsMan Windows-10-LAN
# Create a PowerShell Session and Execute Commands
$cred=Get-Credential
$sess = New-PSSession -Credential $cred -ComputerName Windows-10-LAN
Enter-PSSession $sess
<Run commands in remote session>
Exit-PSSession
Remove-PSSession $sess
#endregion
Get-Credential


powershell.exe -NoLogo -NoProfile -Command '[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Install-Module -Name PackageManagement -Force -MinimumVersion 1.4.6 -Scope CurrentUser -AllowClobber -Repository PSGallery'

################################################## List all updates on a certain windows vm #############################################
dism /image:C:\ /get-packages > c:\temp\Patch_level.txt

#region###############################################  Get a VM endpoint ###########################################################
$VMName = "win19-rpa-proxy-tst-eus"                                               #### requires module named Azure
(Get-AzureVM | where { $_.Name -eq $VMName } | Get-AzureEndpoint).Name 
#endregion



#region########################################################  Find a module of a given cmdlet ##########################################
Get-Command -type cmdlet Get-WUServiceManager | fl *
Get-Command -type cmdlet start-transcript | fl *                  ### Find a module of a given cmdlet
(Get-Command -Name get-psrepository).ModuleName                    ### Find a module of a given cmdlet
Get-Command -Name Start-Transcript | Select-Object -Property ModuleName               ### Find a module of a given cmdlet
Get-Command -Name Test-NetConnection | Select-Object -Property ModuleName               ### Find a module of a given cmdlet
Get-Command -Name Get-AzStorageAccount | Format-List -Property ModuleName                ### Find a module of a given cmdlet
#endregion


#region################################################ Enable automatic downloading of updates without installation ##########################
$WUSettings = (New-Object -com "Microsoft.Update.AutoUpdate").Settings
$WUSettings.NotificationLevel = <3 or 7>                  ##     7   [Windows server 2016 & later] 3 [Windows server 2012]
$WUSettings.Save()
#endregion

Install-Module PowershellGet -Force
Select-AzureSubscription -Default xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
get-help    Select-AzureSubscription -examples "UAE - Subscription"
Select-AzureSubscription -Default 'UAE - Subscription'
get-help Unregister-PackageSource -Examples
Unregister-PackageSource -Source "PSGallery"
Get-Command get-packages
Get-PackageProvider
install-module updateservices
get-help Get-AzureVM -examples 
Get-AzureVM -Name "win19-rpa-proxy-tst-eus"
get-help Get-AzureEndpoint
Get-AzureEndpoint -VM win19-rpa-proxy-tst-eus
Install-Module -Name Azure
find-module AzureVM
get-psrepository
set-psrep

Import-Module UpdateServices
install-Module UpdateService
find-module Update
get-help Get-WUServiceManager
update-help 
Get-Module -ListAvailable

Install-Module –Name MSOnline
Install-Module –Name MicrosoftTeams

##enable MFA FOR ALL users at once


#region################################### Modules needed to update VM through runbook automation account ###############################
install-module AzureRM.OperationalInsights
install-Module AzureRM.Profile            # This is a dependency of the upper & hence should be installed first
#endregion

Install-Module PowerShellGet
Install-Module -Name AzureRM -AllowClobber
Import-Module AzureRM
Install-Module az.account
Install-Module az.automation
Install-Module az.compute
Import-Module az.automation

Get-Command -Module Defender

Get-service Windefend


#region #####################################  Delete URL from Sharepoint to reuse the old site name ####################################
Install-Module -Name Microsoft.Online.SharePoint.PowerShell             # Module needed
Install-Module pnp.powershell                                           # Module needed
Update-module microsoft.online.sharepoint.powershell -Force             # Module needed
update-Module pnp.powershell                                            # Module needed

Connect-PnPOnline -Url https://coordinates.sharepoint.com -Credential (Get-Credential)  # Connect to SharePoint Admin Center using Credentials
Connect-PnPOnline -Url https://coordinates.sharepoint.com -UseWebLogin                    # Connect to SharePoint Admin Center using Web
Clear-PnPTenantRecycleBinItem -url  https://coordinates.sharepoint.com/sites/Al-Tamimi      # Delete the name of the website from RecycleBin
DisConnect-PnPOnline                     # Terminate Session
Get-Command -Module pnp.powershell
#Step 3: Register a new Azure AD Application and Grant Access to the tenant
Register-PnPManagementShellAccess
Get-PnPList                                     # Get All lists
#Read more: https://www.sharepointdiary.com/2021/02/how-to-install-pnp-powershell-module-for-sharepoint-online.html#ixzz7PIIfe0z9

##############################################  Permanetly delete a website ##############################
Remove-SPODeletedSite -Identity https://contoso.sharepoint.com/sites/sitetoremove
Get-Help Remove-SPODeletedSite
update-help
install-module Microsoft.PowerShell.security
Remove-SPODeletedSite -Identity https://coordinates.sharepoint.com/sites/CorClients
Remove-SPODeletedSite -Identity https://coordinates.sharepoint.com/sites/Engineering
Remove-SPODeletedSite -Identity https://coordinates.sharepoint.com/sites/int-Deyaar
Remove-SPODeletedSite -Identity https://coordinates.sharepoint.com/sites/ClientsInformation
Remove-SPODeletedSite -Identity https://coordinates.sharepoint.com/sites/Treasury
Get-Module -Name Microsoft.Online.SharePoint.PowerShell -ListAvailable | Select Name,Version
#endregion
Get-InstalledModule                          # List all installed modules
update-Module


Get-EXOMailbox -UserPrincipalName xxxxxx@live.com
update-Module ExchangeOnlineManagement
Get-DataEncryptionPolicy
Import-Module ExchangeOnlineManagement
install-Module ExchangeOnlineManagement
import-Module ExchangeOnlineManagement
Connect-ExchangeOnline

Set-Mailbox 
New-DataEncryptionPolicy -Name "Encryp" -AzureKeyIDs "https://mainvaults.vault.azure.net/keys/Mail-Encrypt-01","https://mainvaults.vault.azure.net/keys/Mail-Encrypt-02" -Description "Root key for mailboxes"
Import-Module exchangepowershell
update-Module exchangepowershell
Import-Module ExchangeOnlineManagement

Connect-ExchangeOnline -UserPrincipalName <UPN> [-ShowBanner:$false] [-ExchangeEnvironmentName <Value>] [-DelegatedOrganization <String>] [-PSSessionOption $ProxyOptions]
Connect-ExchangeOnline -UserPrincipalName xxxxxx@live.com
import-Module AzureAD
Get-AzureADUser
Connect-AzureAD
update-Module microsoft.identitymodel.clients.activedirectory
update-Module
Register-PackageSource -name Nuget -Location 
 
Register-PackageSource -Name MyNuGet -Location https://www.nuget.org/api/v2 -ProviderName NuGet
Get-DataEncryptionPolicy


Get-PackageProvider        # List all package sources/provider


#region ############################ Turn on diagnostic settings to collect logs from application gateway to storage account #############
install-module az.monitor -AllowClobber
import-Module Az.Monitor
Set-AzDiagnosticSetting  -ResourceId /subscriptions/<subscriptionId>/resourceGroups/<resource group name>/providers/Microsoft.Network/applicationGateways/<application gateway name> -StorageAccountId /subscriptions/<subscriptionId>/resourceGroups/<resource group name>/providers/Microsoft.Storage/storageAccounts/<storage account name> -Enabled $true 
Set-AzDiagnosticSetting  -ResourceId /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/MC_Production_Env-Production_germanywestcentral/providers/Microsoft.Network/applicationGateways/WAF-website -StorageAccountId /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/mc_testing_env-testing_germanywestcentral/providers/Microsoft.Storage/storageAccounts/ff5288ce2469445e1802e9d -Enabled $true -RetentionInDays 30 
##################### Display Storage account ID through its given name #####################################
Import-Module Az.Storage
$s = Get-AzStorageAccount -ResourceGroupName "mc_testing_env-testing_germanywestcentral" -AccountName "ff5288ce2469445e1802e9d"
$s.Id
import-Module Az.Monitor
Get-InstalledModule

#endregion






#region ############## Create a WAF application gateway ######################################






Get-Command  -Name Get-Childitem -Args Cert: -Syntax








install-Module openssl -AllowClobber
import-Module openssl
openssl pkcs12 -inkey bob_key.pem -in bob_cert.cert -export -out bob_pfx.pfx
OpenSSL pkcs12 -inkey STAR_mydomain_com_key.txt -in star-mydomain-com.crt -export -out star-mydomain-com.pfx
Get-InstalledModule
choco install OpenSSL.Light

get-help Enter-PSSession -examples
Enter-PSSession -computername  Windows-10-LAN                   ## PowerShell session for Windows
Enter-PSSession -hostname   Muhammad@Windows-10-LAN             ## SSH session for Linux only
new-pssession   -computername Windows-10-LAN
get-help new-pssession -examples


Install-Package Microsoft.IdentityModel.Clients.ActiveDirectory -RequiredVersion 5.2.9 -ProviderName NuGet -Source "MyNuGet"
get-psrepository
import-Module PackageManagement
get-packages
Get-Item wsman:\localhost\Client\TrustedHosts
new-Item wsman:\localhost\Client\TrustedHosts

get-help Get-Item 



get-help Test-NetConnection



Test-NetConnection -ComputerName 40.118.40.109 -Port 443

install-module azurenetworkwatcher
install-module Microsoft.Azure.NetworkWatcher 
find-module -name   NetworkWatcher -Repository NuGet

Unregister-PackageSource -name MyNuGet               # Delete a package source from powershell repository

install-module  

Get-InstalledModule
import-Module -name exchangepowershell
get-omeconfiguration
Get-OMEConfiguration | Format-List
get-irmconfiguration |Format-list
Set-IRMConfiguration -SimplifiedClientAccessEncryptOnlyDisabled $true -SimplifiedClientAccessDoNotForwardDisabled $true
get-aipservice
connect-aipservice
Disconnect-AipService
Install-Module -Name AIPService
import-Module -name AIPService
Uninstall-Module -Name AIPService
update-Module -Name AIPService


set-psrepository 

Get-InstalledModule
import-Module microsoft.powershell.management
install-module microsoft.powershell.management -Repository powershellget
Register-PSRepository PSGallery
#################  List All stopped services ##################################################
Get-Service | Select StartType, Status, Name, DisplayName | Where-Object {$_.Status -eq 'Stopped'} | Format-Table -AutoSize
# Uninstall a service
Get-Service | Select StartType, Status, Name, DisplayName | Where-Object {$_.Status -eq 'Stopped'} | Remove-service






## Register NuGet in repositories
$parameters = @{
    Name = "NuGet"
    SourceLocation = "https://api.nuget.org/v3/index.json"
    PublishLocation = "https://www.myget.org/F/powershellgetdemo/api/v2/Packages"
    InstallationPolicy = 'Trusted'
  }
  Register-PSRepository @parameters
  Get-PSRepository
  Install-Package Microsoft.IdentityModel.Clients.ActiveDirectory -Version 5.2.9
  install-module -name "Microsoft.IdentityModel.Clients.ActiveDirectory" -version 5.2.9 -Repository "NuGet" 
# 


install-module azure.service










