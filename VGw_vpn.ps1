# Create a resource group
# Create a virtual network
# Add a gateway subnet
# Request a public IP address
# Create the VPN gateway


# Create a resource group
az group create --name rg-vpn --location eastus

az group delete --name rg-vpn --yes

# Create a virtual network
az network vnet create \
  -n vpn-fin \
  -g rg-vpn \
  -l eastus \
  --address-prefix 10.240.0.0/24 \
  --subnet-name Frontend \
  --subnet-prefix 10.240.0.0/24
#

# Add a gateway subnet
az network vnet subnet create \
  --vnet-name rg-rpa-tst-eus-vnet \
  -n GatewaySubnet \
  -g rg-rpa-tst-eus \
  --address-prefix 172.17.1.0/24
#

# Request a public IP address
az network public-ip create \
  -n win19-fin-rpa-eus284 \
  -g rg-rpa-tst-eus \
  --allocation-method Static
#

# Create the VPN gateway
az network vnet-gateway create \
  -n VGW-VPN \
  -l eastus \
  -g rg-rpa-tst-eus \
  --public-ip-address rg-vpn-pip \
  --vnet rg-rpa-tst-eus-vnet  \
  --gateway-type Vpn \
  --sku basic \
  --vpn-type RouteBased \
  --no-wait
#

# View the VPN gateway
az network vnet-gateway show \
  -n VGW-VPN \
  -g rg-rpa-tst-eus
#

# View the public IP address
az network public-ip show \
  --name VNet1GWIP \
  --resource-group TestRG11
#

# Associate an existing VM to a public IP
az network nic ip-config update \
  --name ipconfig1 \
  --nic-name win19-fin-rpa-eus284 \
  --resource-group rg-rpa-tst-eus \
  --public-ip-address win19-fin-rpa-eus284
#

# Dissociate an existing VM to a public IP
az network nic ip-config update \
  --name ipconfig1 \
  --nic-name win19-fin-rpa-eus284  \
  --resource-group rg-rpa-tst-eus \
  --remove publicIpAddress
#

# List all P2S connections
az network p2s-vpn-gateway list -g rg-rpa-tst-eus
az network p2s-vpn-gateway show -n vgw-vpn -g MC_General_General_eastus 
az network p2s-vpn-gateway create
az network p2s-vpn-gateway delete
az network p2s-vpn-gateway vpn-client

az network p2s-vpn-gateway connection show --gateway-name vgw-vpn \
  --resource-group MC_General_General_eastus \
  --name vgw-vpn
#

az network p2s-vpn-gateway connection list \
 --gateway-name vgw-vpn \
 --resource-group MC_General_General_eastus 
#

az --version



# How to reset VGW
az network vnet-gateway reset -g MC_General_General_eastus -n vgw-vpn




CloudVPN
MIIC4TCCAcmgAwIBAgIQPNdBKOmguLZGiWINiqo1KzANBgkqhkiG9w0BAQsFADAT
MREwDwYDVQQDDAhDbG91ZFZQTjAeFw0yMTExMDMxMzQyMjVaFw0yMjExMDMxNDAy
MjVaMBMxETAPBgNVBAMMCENsb3VkVlBOMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAv5BJ7kCcXsmNJ7/Os2h5nLoCP+oQ0VzJeOx+tUhZ+qgm5eN+Do8c
zSW3h9rnmd2rTkJ9VwRlK67RwCC8dnXbYDnE1Ln9gIJt0Q/nfnmFUMz5/o1AcV13
WmSFD6KhtvWaCbbPItvr14y54TQtaIzeMJuD64TTeC+i18YSov0VY3bMRzsYznnU
I3N5E5HR26iR2iWvdwwTYVPIjAUC5uRr8+XMauVTJDjaxIxNY2OaMGHovSoGpEhr
ploX9dwEIS64K0BWyC4m+iSSQdP+hi24+H4jOS83GKMTkmqJPJDr1evhgIW8g3eT
Q5qCg3Owsf2iEloidiz6kidpMTmxrAfBXQIDAQABozEwLzAOBgNVHQ8BAf8EBAMC
AgQwHQYDVR0OBBYEFHa8L5BF8wy0fTSiSfScmVEetNgJMA0GCSqGSIb3DQEBCwUA
A4IBAQCDKy6Q3xVYMpF4KkXpRLBJC2Rv+EhbeFwb8soqMr8HW/X73nnOReXcjN3J
QTRjanRuNx1g1jlTmwgmwxZSodr5bkclWniHuJez54Cvv50QOKR9PDJBzTQetdF8
s+INSM/vSHN/BkExM/hjB+KZLvsqjVoszwqpZO2cjDOgV6H3N8Raa6aR5Z8x/vjn
07BZQkV7r088PZq7Sh9hpcc4Mu1VBzjCmTgnOcyTdT2fc9oPjX7w5dWG9ARJj8Fj
xAC91OU+mgYW59kHhiK5Zd5cPhOrI9++xqVH3nN+usy6Rj3QVwyMr4721SUleEys
sMCBWMJw1p0Cj/T/PJ5Va5Dpxw88

Revoked certificates
leaving employee
61A507E34B6D618308A7AA1B4745F43744F72CD0