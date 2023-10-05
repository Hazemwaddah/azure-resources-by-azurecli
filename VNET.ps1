
# Create a resource group
az group create -g rg-vm-test -l germanywestcentral
az group delete -g rg-vm-test --yes

# Create a virtual network
az network vnet create \
  -n VM_TEST \
  -g rg-vm-test \
  -l germanywestcentral \
  --address-prefix 172.20.0.0/24 \
  --subnet-name Subnet \
  --subnet-prefix 172.20.0.0/24
#



