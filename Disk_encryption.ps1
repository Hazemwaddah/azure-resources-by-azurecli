
# This feature is not accessible by default, it requires registeration first.
# Execute the following command to register the feature for your subscription
az feature register --namespace Microsoft.Compute --name EncryptionAtHost

# Check that the registration state is Registered (takes a few minutes) 
# using the command below before trying out the feature.
az feature show --namespace Microsoft.Compute --name EncryptionAtHost


# Check the status of encryption at host for a VM
rgName=rg-mycompany-vm-tst
vmName=mycompany-tst

az vm show -n $vmName \
 -g $rgName \
 --query [securityProfile.encryptionAtHost] -o tsv
#


# Update a VM to enable encryption at host.
rgName=rg-mycompany-vm-tst
vmName=mycompany-tst

az vm update -n $vmName \
 -g $rgName \
 --set securityProfile.encryptionAtHost=true
#

# Disable encryption at host for a VM
rgName=rg-mycompany-vm-tst
vmName=mycompany-tst

az vm update -n $vmName \
 -g $rgName \
 --set securityProfile.encryptionAtHost=false
#