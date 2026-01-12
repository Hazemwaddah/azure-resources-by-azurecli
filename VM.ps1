
# Enable EncryptionAtHost Feature for VM/VMSS
Register-AzProviderFeature -FeatureName "EncryptionAtHost" -ProviderNamespace "Microsoft.Compute"
# CLI
az feature register --namespace Microsoft.Compute --name EncryptionAtHost

# Check EncryptionAtHost Feature status
Get-AzProviderFeature -FeatureName "EncryptionAtHost" -ProviderNamespace "Microsoft.Compute"
# CLI
az feature show --namespace Microsoft.Compute --name EncryptionAtHost

###########################################################################################################################################
#region################################################ Virtual Machine VM  ##############################################################
####################################################  Create a Linux VM   ###############################################################
az vm create --resource-group rg-privateendpoint-uae \
  --name vm-pep-uae \
  --image UbuntuLTS \
  --generate-ssh-keys \
  --admin-username thadmin \
  --public-ip-sku Standard \
  --size Standard_B1ms \
  --output json \
  --verbose
#
az group delete -n rg-privateendpoint-uae --yes
# az vm create  --resource-group elk-stack   --name TutorialVM1   --image UbuntuLTS   --admin-username thadmin   --generate-ssh-keys   --output json   --verbose --public-ip-sku Standard --size D2as_v4
ssh -i AAAAB3NzaC1yc2EAAAADAQABAAABAQDUe2KLbSL9SjNT8ZdeYTzqd55gf+ulkeFH4tES+RjNLeTVk1rdfAjgthtAdyRWB6rQgoBEThO72X5euekwb8MTVpjfAtePHCZ07UqFhdZf8PrlgEDRidfKjPtalcn+xwf13LQI3CyPYA2usmmaBlkq8FWCGB5/qbeJmT/jE5PZnP+6fSxOCy78bXmVX54tuRLeh2B/kDKQo9x8p3+bVQJ1kOaJwA/Ufbg4Aw7M9RA/lqsGN4/ojvFLDO+d78gybn50jQhQaraQZRND3mETww7i6gK8a/ItKx5IQfb9DdJnsqCN5Dpn8yNoLI7q7FrI2doBJXY8GWin4eGATxcOJQh1 thadmin@20.216.36.231
###########################################################################################################################################
####################################################  Create a Windows VM   ###############################################################
az vm create -n win19-rpa-proxy-tst-eus \
    --resource-group rg-rpa-tst-eus \
    --image Win2019Datacenter \
    --public-ip-sku Standard \
    --size Standard_D8sv3 \
    --vnet-name rg-rpa-tst-eus-vnet \
    --subnet default \
    --admin-username thadmin \
    --admin-password t@eygpt_2022
#

####################################################  Create a MacOS VM   ###############################################################
az vm create --resource-group RG-IMTD-PRD-001-DevOps \
  --name vm-pep-uae \
  --image macOS \
  --generate-ssh-keys \
  --admin-username admin \
  --public-ip-sku Standard \
  --size Standard_B1ms \
  --output json \
  --verbose
#

az group create -n rg-vm-test -l germanywestcentral
az group delete -n rg-vm-test --yes
Win2022AzureEditionCore
az group delete -n rg-privateendpoint-uae --yes
az vm create -n MyVm -g MyResourceGroup --public-ip-address "" --image Win2012R2Datacenter
#region######################################################   Resize a VM #################################################################
# Variables will make this easier. Replace the values with your own.
resourceGroup=TutorialResources
vm=TutorialVM1
size=Standard_B1ms
## First the VM must be stopped & deallocated in order to resize
az vm deallocate --resource-group $resourceGroup -n TutorialVM1
az vm resize --resource-group $resourceGroup -n $vm --size $size
az vm start --resource-group $resourceGroup -name $vm
az vm resize -g TutorialResources -n TutorialVM1 --size Standard_B1ms
#endregion##########################################################################################################################################

#region######################################################   delete a VM   #################################################################
az vm delete \
 --resource-group rg-privateendpoint-uae \
 --name vm-pep-uae \
 --yes \
 --force-deletion
#
###########################################################################################################################################
#######################################################   delete a Disk   #################################################################
az disk list [--resource-group]
az disk delete --name vm-pep-uae_OsDisk_1_3e8e3045433946798f9b4874750d4d8e \
 --resource-group rg-privateendpoint-uae
#
az disk list -g rg-privateendpoint-uae -o table
###########################################################################################################################################
#######################################################   Start/stop a VM #################################################################
az vm restart -n win19-rpa-proxy-tst-eus -g RG-RPA-TST-EUS  --force
az vm start -n win19-rpa-proxy-tst-eus -g RG-RPA-TST-EUS
az vm stop -n win19-rpa-proxy-tst-eus -g RG-RPA-TST-EUS 
az vm show -n win19-rpa-proxy-tst-eus -g RG-RPA-TST-EUS

Get-AzVM -ResourceGroupName "RG-RPA-TST-EUS" -Name "win19-rpa-proxy-tst-eus" -DisplayHint expand
###########################################################################################################################################
#######################################################   deallocate a VM   #############################################################
az vm deallocate -n vm-pep-uae -g rg-privateendpoint-uae
#######################################################   Re-start a VM after deallocation  #############################################################
az vm start -n vm-pep-uae -g rg-privateendpoint-uae
#######################################################   Monitor a VM   #############################################################
# Example of listing IP addresses associated with a specific VM in your resource group.
az vm list-ip-addresses --resource-group rg-rpa-tst-eus --name win19-rpa-proxy-tst-eus --subscription [REDACTED-SUBSCRIPTION-ID]
# Example of setting auto-shutdown for a specific VM in your resource group.
az vm auto-shutdown --resource-group rg-rpa-tst-eus --name win19-rpa-proxy-tst-eus --time 1730 --subscription [REDACTED-SUBSCRIPTION-ID]
#Example of listing the metric values for a specific VM in your resource group.
az vm monitor metrics tail --resource-group rg-rpa-tst-eus --name win19-rpa-proxy-tst-eus --subscription [REDACTED-SUBSCRIPTION-ID] -o table
az vm monitor metrics tail [--name] [--resource-group] [--aggregation {Average, Count, Maximum, Minimum, Total}] [--dimension] [--end-time] [--filter] [--interval] [--metadata] [--metrics] [--namespace] [--offset] [--orderby] [--start-time] [--subscription] [--top]
##############################################################################################################################################
#endregion

# Azure Disk Encryption:
# Display Azure Disk Encryption [ADE] encryption status
az vm encryption show -n daman-tst -g rg-daman-vm-tst
az vm encryption show -n ml-tst-gwc -g rg-ml-tst-gwc
az vm encryption show -n cicd-agent-gwc -g rg-agent-build-gws

# Encryption-At-Host encryption:
# Update a VM to enable encryption at host.
rgName=rg-rpa-tst-eus
vmName=win19-rpa-proxy-tst-eus
az vm update -n $vmName \
-g $rgName \
--set securityProfile.encryptionAtHost=true



# Enable InGuestAutoAssessmentVMPreview to enable periodic
# assessment for VMs. It needs to be enabled over the subscription
az feature register --namespace Microsoft.Compute --name InGuestAutoAssessmentVMPreview

# Invoking is required to get the change propagated
az provider register -n Microsoft.Compute

# Enable Automatic VM guest patching for Azure VMs
az vm update -g rg-agent-build-gws -n cicd-agent-gwc --set osProfile.windowsConfiguration.enableAutomaticUpdates=true osProfile.windowsConfiguration.patchSettings.patchMode=AutomaticByPlatform
az vm update -g rg-daman-vm-tst -n daman-tst --set osProfile.windowsConfiguration.enableAutomaticUpdates=true osProfile.windowsConfiguration.patchSettings.patchMode=AutomaticByPlatform
az vm update -g rg-ml-tst-gwc -n ml-tst-gwc --set osProfile.windowsConfiguration.enableAutomaticUpdates=true osProfile.windowsConfiguration.patchSettings.patchMode=AutomaticByPlatform
az vm update -g RG-RPA-TST-EUS -n win19-rpa-proxy-tst-eus --set osProfile.windowsConfiguration.enableAutomaticUpdates=true osProfile.windowsConfiguration.patchSettings.patchMode=AutomaticByPlatform


az vm get-instance-view -g rg-agent-build-gws -n cicd-agent-gwc
az vm get-instance-view -g rg-daman-vm-tst -n daman-tst
az vm get-instance-view -g rg-ml-tst-gwc -n ml-tst-gwc
az vm get-instance-view -g RG-RPA-TST-EUS -n win19-rpa-proxy-tst-eus



# Allocate a new public IP address
az network public-ip create -n website-ubuntu2204-pip \
 -g Frontend \
 --allocation-method Static \
 --sku standard \
 --location eastus 
 #--zones 1
# 

# Add/update a public IP address to an NIC
az network nic ip-config update \
 --name ipconfig1 \
 -g Frontend \
 --nic-name website-ubuntu2204159_z1 \
 --public-ip-address website-ubuntu2204-pip
#

# Add an SSH rule to NSG:
az network nsg rule create -n SSH \
 -g Frontend \
 --nsg-name website-ubuntu2204-nsg \
 --priority 200 \
 --source-address-prefixes '*' \
 --destination-port-ranges 22 \
 --access Allow \
 --protocol Tcp \
 --direction Inbound \
 --description "Allow SSH connection"
#








# Delete an NSG rule:
az network nsg rule delete -n SSH \
 --nsg-name website-ubuntu2204-nsg \
 -g Frontend
#

# Remove/update public IP address from an NIC
az network nic ip-config update \
 --name ipconfig1 \
 -g Frontend \
 --nic-name website-ubuntu2204159_z1 \
 --remove PublicIpAddress
#

# Delete a public IP address
az network public-ip delete -n website-ubuntu2204-pip \
 -g Frontend
#
