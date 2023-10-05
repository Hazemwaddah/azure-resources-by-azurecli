az network public-ip update [--add]
                            [--allocation-method {Dynamic, Static}]
                            [--dns-name]
                            [--force-string]
                            [--idle-timeout]
                            [--ids]
                            [--ip-tags]
                            [--name]
                            [--public-ip-prefix]
                            [--remove]
                            [--resource-group]
                            [--reverse-fqdn]
                            [--set]
                            [--sku {Basic, Standard}]
                            [--tags]
                            [--version {IPv4, IPv6}]
#


az network public-ip update \
 -n nphies1 \
 -g rg-test \
 --public-ip-prefix 40.122.233.149 \
 --sku standard 
#  

# Allocate a public IP address
az network public-ip create -n win19-pip \
 -g rg-rpa-tst-eus
# 
# Add/update a public IP address to an NIC
az network nic ip-config update \
 --name ipconfig1 \
 -g rg-rpa-tst-eus \
 --nic-name win19-rpa-proxy-t187 \
 --public-ip-address win19-pip
#

# Remove/update public IP address from an NIC
az network nic ip-config update \
 --name ipconfig1 \
 -g rg-rpa-tst-eus \
 --nic-name win19-rpa-proxy-t187 \
 --remove PublicIpAddress
#

az network public-ip create -n nphies \
 -g rg-test \
 --allocation-method Static \
 --ip-address 40.122.233.149 \
 --sku standard 
#

--public-ip-prefix 40.122.233.149 \


az network public-ip create --name
                            --resource-group
                            [--allocation-method {Dynamic, Static}]
                            [--dns-name]
                            [--edge-zone]
                            [--idle-timeout]
                            [--ip-address]
                            [--ip-tags]
                            [--location]
                            [--public-ip-prefix]
                            [--reverse-fqdn]
                            [--sku {Basic, Standard}]
                            [--tags]
                            [--tier {Global, Regional}]
                            [--version {IPv4, IPv6}]
                            [--zone {1, 2, 3}]
#
