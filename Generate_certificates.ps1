## Generate a new self-signed certificate using PS

## Generate a new self-signed certificate
New-SelfSignedCertificate `
  -CertStoreLocation "cert:\localmachine\my" `
  -dnsname www.contoso.com
#

Get-Help New-SelfSignedCertificate -examples
Get-Help New-SelfSignedCertificate
## Response should take the following format
PSParentPath: Microsoft.PowerShell.Security\Certificate::LocalMachine\my

Thumbprint                                Subject
----------                                -------
E1E81C23B3AD33F9B4D1717B20AB65DBB91AC630  CN=www.contoso.com

## Export the certificate into .pfx file and add a password to it
$pwd = ConvertTo-SecureString -String <your password> -Force -AsPlainText
Export-PfxCertificate `
  -cert cert:\localMachine\my\E1E81C23B3AD33F9B4D1717B20AB65DBB91AC630 `
  -FilePath c:\appgwcert.pfx `
  -Password $pwd
#

####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
####################################################################################################################################

$cert = New-SelfSignedCertificate -Type Custom -KeySpec Signature `
-Subject "CN=P2SRootCert" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" -KeyUsageProperty Sign -KeyUsage CertSign
##############################################################################################################################
## In case generating client certificates through the same powershell session
New-SelfSignedCertificate -Type Custom -DnsName P2SChildCert -KeySpec Signature `
-Subject "CN=P2SChildCert" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")
##############################################################################################################################
## In case generating additional client certificates in a different powershell session
##
Get-ChildItem -Path "Cert:\CurrentUser\My"
Get-ChildItem -Path "Cert:\CurrentUser\root"   # trusted root certificates
Get-ChildItem -Path "Cert:\LocalMachine\My"
Get-ChildItem -Path "Cert:\LocalMachine\root"
## Result
Thumbprint                                Subject
----------                                -------
AED812AD883826FF76B4D1D5A77B3C08EFA79F3F  CN=P2SChildCert4
7181AA8C1B4D34EEDB2F3D3BEC5839F3FE52D655  CN=P2SRootCert

## Identify the self-signed root certificate that is installed on the computer:
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My"

# Locate the subject name from the returned list, then copy the thumbprint that is located next to it to a text file:
# Declare a variable for the root certificate using the thumbprint from the previous step, then
# Replace THUMBPRINT with the thumbprint of the root certificate from which you want to generate a child certificate:
# For example, using the thumbprint for P2SRootCert in the previous step, the variable looks like this:
$cert = Get-ChildItem -Path "Cert:\CurrentUser\My\3CDB640F7C4832F9B96B881B903CA89F354B2968"
$cert = Get-ChildItem -Path "Cert:\CurrentUser\root\3CDB640F7C4832F9B96B881B903CA89F354B2968"

## Modify and run the example to generate a client certificate:
New-SelfSignedCertificate -Type Custom -DnsName CloudVPN -KeySpec Signature `
-Subject "CN=Ragab Salim" -KeyExportPolicy Exportable `
-HashAlgorithm sha256 -KeyLength 2048 `
-CertStoreLocation "Cert:\CurrentUser\My" `
-Signer $cert -TextExtension @("2.5.29.37={text}1.3.6.1.5.5.7.3.2")


# Display local certificates
Get-ChildItem -path cert:\LocalMachine\My 

# Revoke a certificate from VPN connection
az network vnet-gateway revoked-cert create -g MC_General_General_eastus -n CloudVPN \
    --gateway-name vgw-vpn --thumbprint 61A507E34B6D618308A7AA1B4745F43744F72CD0
#


Get-PSDrive cert | ft -AutoSize

Get-ChildItem Cert:\LocalMachine\Root\

Get-Item Cert:\LocalMachine\Root\* | ft -AutoSize

Get-ChildItem Cert:\LocalMachine\Root\ | where{$_.Subject -like "*Microsoft*"} |ft -AutoSize
Get-ChildItem Cert:\LocalMachine\Root\ | where{$_.FriendlyName -eq 'Sectigo'} |ft -AutoSize

Get-ChildItem Cert:\LocalMachine\ -Recurse | where{$_.FriendlyName -eq 'DigiCert'}|ft -AutoSize


# Print certificate public key to console
gci -path cert:\localmachine\My | % {write-host Friendlyname: $_.FriendlyName; $_.PublicKey.Key}



(Get-PfxCertificate -FilePath star-tachyhealth-com.pfx).GetPublicKey()






$gw = Get-AzApplicationGateway -Name $appgwName -ResourceGroupName $resgpName
$gw = Remove-AzApplicationGatewayTrustedRootCertificate -ApplicationGateway $gw -Name "myRootCA"
$gw = Set-AzApplicationGateway -ApplicationGateway $gw



# Generate certificates through OpenSSL
openssl ecparam -out backend.key -name prime256v1 -genkey
openssl req -new -sha256 -key backend.key -out backend.csr -subj "//CN=backend"
openssl x509 -req -sha256 -days 1095 -in backend.csr -signkey backend.key -out backend.crt


