# To Enable boot diagnostics on a VM with a storage account
az storage account list -o table
az storage account list -g rg-policy -o table
az storage account list -g rg-policy
az storage account show -g rg-policy \
 -n metricsstorage27900
# 
# Create a resource group
az group create -n rg-policy -l uaenorth

az group delete -n rg-policy --yes

# Create a storage account for VM metrics
STORAGE=metricsstorage$RANDOM
az storage account create \
    --name $STORAGE \
    --sku Standard_LRS \
    --location uaenorth \
    --require-infrastructure-encryption \
    --min-tls-version TLS1_2 \
    --resource-group rg-policy
#
az group create -n rg-policy -l eastus2
STORAGE=metricsstorage$RANDOM
az storage account create \
    --name $STORAGE \
    --sku Standard_LRS \
    --location eastus2 \
    --require-infrastructure-encryption \
    --min-tls-version TLS1_2 \
    --resource-group rg-policy
#   
# Create a VM with a storage account
az vm create \
    --name monitored-linux-vm \
    --image UbuntuLTS \
    --size Standard_B1s \
    --location eastus2 \
    --admin-username azureuser \
    --boot-diagnostics-storage $STORAGE \
    --resource-group rg-tst \
    --generate-ssh-keys
#

# Connect to VM to create a stress test
ssh azureuser@20.110.208.246

# Run the following command to update the list
# of available updates.
sudo apt-get update

# Run the following command to install the stress tool
# on the VM.
sudo apt-get install stress

# Run the following command to stress the VM's CPU for 10 mintues
sudo stress --cpu 16 -v -t 10m




# Another way of creating a VM using configuration file
# Start by creating the configuration script. 
# To create the cloud-init.txt file with the configuration
# for the VM, run the following command in Azure Cloud Shell:
cat <<EOF > cloud-init.txt
#cloud-config
package_upgrade: true
packages:
- stress
runcmd:
- sudo stress --cpu 1
EOF


# To set up an Ubuntu Linux VM, run the following 
# az vm create command. 
# This command uses the cloud-init.txt file that you 
# created in the previous step to configure the VM after
# it's created.
az vm create \
    --resource-group [sandbox resource group name] \
    --name vm1 \
    --location eastUS \
    --image UbuntuLTS \
    --custom-data cloud-init.txt \
    --generate-ssh-keys
#


# Create the metric alert through the CLI

# Run the following command in Cloud Shell to obtain 
# the resource ID of the virtual machine previously created
VMID=$(az vm show \
        --resource-group [sandbox resource group name] \
        --name vm1 \
        --query id \
        --output tsv)
#

# Run the following command to create a new metric 
# alert that will be triggered when the VM CPU is 
# greater than 80 percent.
az monitor metrics alert create \
    -n "Cpu80PercentAlert" \
    --resource-group [sandbox resource group name] \
    --scopes $VMID \
    --condition "max percentage CPU > 80" \
    --description "Virtual machine is running at or greater than 80% CPU utilization" \
    --evaluation-frequency 1m \
    --window-size 1m \
    --severity 3
#
    
