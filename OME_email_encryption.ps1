Get-EXOMailbox                    


SPO_af80cbdc-7831-4ce3-ab6c-de55ae5a4303@SPO_fabdb895-9971-4d54-bfb5-5db10e2cc26a

Get-MessageTrace -RecipientAddress xxxxxxxx@mycompany.com -StartDate 05/17/2022 -EndDate 05/18/2022
connect-exopssession

Connect-AzAccount
Connect-ExchangeOnline            # Connect to Office 365 admin center
# Check the IRM configuration [Information Rights Management]
get-irmconfiguration
import-Module -name AIPService
install-module -name AIPService
update-Module -name AIPService
get-aipservice
connect-aipservice
###########################################
Get-OMEConfiguration
Set-OMEConfiguration

## Cloud-based BASH ONLY
Get-OMEMessageStatus
Get-OMEMessageStatus -MessageId "AU2P273MB035683DFC25D9E137D3F0D43B6CE9@AU2P273MB0356.AREP273.PROD.OUTLOOK.COM"

Get-Command *-ome*
Get-Command *-Get-OMEMessageStatus*



## Test Encryption for an Email address
Test-IRMConfiguration -Sender xxxxxxxx@mycompany.com -Recipient xxxxxxxx@mycompany.com
get-irmconfiguration
Set-IRMConfiguration -SimplifiedClientAccessEnabled $true
Set-IRMConfiguration -InternalLicensingEnabled $true
Set-IRMConfiguration -AzureRMSLicensingEnabled $true

# Display All the RMS Templates
Get-RMSTemplate
Set-RMSTemplate "mycompany Encrypt" -Type Distributed/Archived/All     ## Command is deprecated and will NOT work.



Set-SmimeConfig -OWAAlwaysEncrypt $false
Set-SmimeConfig -OWAForceSMIMEClientUpgrade $false
Get-smimeconfig

