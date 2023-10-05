

Install-Module az.resources -AllowClobber
Import-Module Az.Resources
Get-Module -ListAvailable
Get-InstalledModule
Update-Module az.accounts

# you could use the command to export the policies to a json file.
$source = Get-AzPolicySetDefinition -Id "/providers/Microsoft.Authorization/policySetDefinitions/cf25b9c1-bd23-4eb6-bd2c-f4f3ac644a5f"
$source.Properties.policyDefinitions | ConvertTo-Json -Depth 3 | Out-File C:\Users\Hazem\Desktop\definitions.json




New-AzPolicySetDefinition -Name "joytest123" -PolicyDefinition C:\Users\joyw\Desktop\definitions.json -Parameter '{ "logAnalyticsWorkspaceIdforVMReporting": { "type": "String" }, "listOfResourceTypesWithDiagnosticLogsEnabled": { "type": "Array" }, "listOfMembersToExcludeFromWindowsVMAdministratorsGroup": { "type": "String" }, "listOfMembersToIncludeInWindowsVMAdministratorsGroup": { "type": "String" }}'




