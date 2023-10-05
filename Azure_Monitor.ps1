
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

#region Show AKS clusters addons
az aks show \
 -g production \
 -n env-production
#

# Result should be something like this:
# "addonProfiles": {
#    "omsagent": {
#        "config": {
#          "logAnalyticsWorkspaceResourceID": "/subscriptions/<WorkspaceSubscription>/resourceGroups/<DefaultWorkspaceRG>/providers/Microsoft.OperationalInsights/workspaces/<defaultWorkspaceName>"
#        },
#        "enabled": true
#      }
#    }
#endregion

#region Show & Delete a solution from Log analytics
az monitor log-analytics solution delete --name
                                         --resource-group
                                         [--no-wait]
                                         [--yes]
#

az monitor log-analytics solution delete \
 -n ContainerInsights \
 -g defaultresourcegroup-dewc \
 --no-wait 
 --yes \
#

# Display All solutions in the Sub
az monitor log-analytics solution list
az monitor log-analytics solution list -g rg-monitor
az monitor log-analytics solution list -g defaultresourcegroup-dewc
az monitor log-analytics solution show --resource-group MyResourceGroup --name SolutionName
#endregion

#region Enable monitoring AKS clusters
# Connect to the AKS cluster
# Production
az aks get-credentials --resource-group production --name env-production
# Testing
az aks get-credentials --resource-group Testing --name Env-Testing

az aks enable-addons -a monitoring \
 -n env-production \
 -g production \
 --workspace-resource-id 9fe6586e-0e64-4d95-b7ce-fb7f61f7fa09
 --subnet-name VirtualNodeSubnet # -s = --subnet-name
#endregion

#region Disable monitoring AKS clusters
# Connect to the AKS cluster
# Production
az aks get-credentials --resource-group production --name env-production
# Testing
az aks get-credentials --resource-group Testing --name Env-Testing


# Use the az aks disable-addons command to disable
# Container insights. 
# Production
az aks disable-addons -a monitoring \
 -n env-production \
 -g production
#
# Testing
az aks disable-addons -a monitoring \
 -n Env-Testing \
 -g Testing
#endregion

