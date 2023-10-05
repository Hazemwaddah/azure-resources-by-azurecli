
# create a resource group
az group create -g rg-nsg -l centralus

az group delete -n rg-nsg --yes

# Create a new NIC and attach to a VM
az network nic create --name
                      --resource-group
                      --subnet
                      [--accelerated-networking {false, true}]
                      [--app-gateway-address-pools]
                      [--application-security-groups]
                      [--dns-servers]
                      [--edge-zone]
                      [--gateway-name]
                      [--internal-dns-name]
                      [--ip-forwarding {false, true}]
                      [--lb-address-pools]
                      [--lb-inbound-nat-rules]
                      [--lb-name]
                      [--location]
                      [--network-security-group]
                      [--no-wait]
                      [--private-ip-address]
                      [--private-ip-address-version {IPv4, IPv6}]
                      [--public-ip-address]
                      [--tags]
                      [--vnet-name]
#

# Create an NIC
az network nic create -n website-ubuntu2204159_nic \
 -g Frontend \
 --vnet-name Frontend-VN \
 --subnet default \
 --public-ip-address website-ubuntu2204-pip
#

#
az network nic update -n website-ubuntu2204159_z1 \
 -g Frontend \
 --location eastus \
 --set ipConfigurations[0].loadBalancerBackendAddressPools[0].zone=*
#

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

# Add an existing NIC to a VM
az vm nic add --nics website-ubuntu2204159_nic \
 -g Frontend \
 --vm-name website-ubuntu2204 
 --primary-nic website-ubuntu2204159_nic 
#

# Create a network security group.
az network nsg create -n 
 -g
 [--location]
 [--tags]
# 

# Create an NSG in a resource group within a region with tags.
az network nsg create -g RG-DAMAN-VM-TST \
 -n NSG-TEST 
 --tags super_secure no_80 no_22
#

# Attach an NSG to a Subnet

# Attach an NSG to an NIC
az network nic update -g RG-DAMAN-VM-TST \
 -n daman-test-nic \
 --network-security-group NSG-TEST
#

# NSG Rules
# List All rules in an NSG
az network nsg rule list --nsg-name daman-tst-nsg \
 -g rg-daman-vm-tst \
 --include-default -o table
#

# Edit/update an NSG ruls:
az network nsg rule update [--access {Allow, Deny}]
                           [--add]
                           [--description]
                           [--destination-address-prefixes]
                           [--destination-asgs]
                           [--destination-port-ranges]
                           [--direction {Inbound, Outbound}]
                           [--force-string]
                           [--ids]
                           [--name]
                           [--nsg-name]
                           [--priority]
                           [--protocol {*, Ah, Esp, Icmp, Tcp, Udp}]
                           [--remove]
                           [--resource-group]
                           [--set]
                           [--source-address-prefixes]
                           [--source-asgs]
                           [--source-port-ranges]
#

# Edit/update an NSG inbound for daman-tst
az network nsg rule update -n PSR_WinRM \
 --nsg-name daman-tst-nsg \
 -g rg-daman-vm-tst \
 --direction Inbound \
 --source-address-prefixes 102.188.120.142
#

# Edit/update an NSG inbound for daman-tst
az network nsg rule update -n PSR_WinRM \
 --nsg-name ml-tst-gwc-nsg \
 -g rg-ml-tst-gwc \
 --direction Inbound \
 --source-address-prefixes 102.188.120.142
#








