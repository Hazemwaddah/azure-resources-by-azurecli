
Really Important Note:
# In order to be able to establish PS remote session
# the server VM should have private network connection
# or in other words, device discovery and printer sharing
# shall be enabled otherwise connection will be blocked.

# Note: Must use a purchased certificate. self-signed certificates
# are not enabled to tunnel https

Enable-PSRemoting -Force
New-NetFirewallRule -Name "Allow WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5986 -Protocol TCP
$thumbprint = (New-SelfSignedCertificate -DnsName $env:COMPUTERNAME -CertStoreLocation Cert:\LocalMachine\My).Thumbprint
$command = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=""$env:computername""; CertificateThumbprint=""$thumbprint""}"
cmd.exe /C $command


Enable-PSRemoting -Force
New-NetFirewallRule -Name "Allow WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5986 -Protocol TCP
$thumbprint = (New-SelfSignedCertificate -DnsName "daman-tst.centralus.cloudapp.azure.com" -CertStoreLocation Cert:\LocalMachine\My).Thumbprint
$command = "winrm create winrm/config/Listener?Address=*+Transport=HTTPS @{Hostname=""daman-tst.centralus.cloudapp.azure.com""; CertificateThumbprint=""$thumbprint""}"
cmd.exe /C $command

$thumbprint = "A835B98FE3FB15FDAACC49E9DB0FA7C580D28A1C"
$command = winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname="daman-tst.centralus.cloudapp.azure.com"; CertificateThumbprint="$thumbprint"}'
cmd.exe /C $command

winrm create winrm/config/Listener?Address=*+Transport=HTTPS '@{Hostname="HMW-2022"; CertificateThumbprint="A531E5BE1EEC740F55170F6549B51D5163BC7463"}'
cmd.exe /C $command

# Once the certificate is installed type the following to configure WINRM to listen on HTTPS
winrm quickconfig -transport:https

# To quickly configure WinRM with nencryption using HTTP
winrm quickconfig

# Restart WinRM service
Get-Service -ComputerName HMW-2022 -Name WinRM | Restart-Service

# Check WinRM listeners
winrm e winrm/config/listener

# Delete WinRM Listener
winrm delete winrm/config/Listener?Address=*+Transport=HTTPS

# Add a remote computer to the trusted hosts
winrm set winrm/config/client  '@{TrustedHosts="daman-tst"}'
winrm set winrm/config/client  '@{TrustedHosts="ml-tst-gwc-ip.germanywestcentral.cloudapp.azure.com"}'
winrm set winrm/config/client  '@{TrustedHosts="win19-rpa-proxy"}'

# Add a rule to Remote Local Firewall to all network profies
# Private/Public/Domain
# It's important the rule is added to the wanted used profile
# For example, if the local profile used to Public when the
# private network profile is used, the connection won't work
New-NetFirewallRule -Name "Allow WinRM HTTP" -DisplayName "WinRM HTTP" -Enabled True -Profile Any -Action Allow -Direction Inbound -LocalPort 5985 -Protocol TCP


#region Create a PS remote session on Windows VMs:
#region PSremote session on Daman
$usernameme=admin
$password=xxxxxxxxx
# Create a remote session for daman-tst
$cred=Get-Credential
$ComputerName="mycompany.centralus.cloudapp.azure.com"
winrm set winrm/config/client  '@{TrustedHosts="mycompany.centralus.cloudapp.azure.com"}'
$sess = New-PSSession -Credential $cred -ComputerName $ComputerName
Enter-PSSession $sess
#endregion 

#region PSremote session on ml-tst
$usernameme=admin
$password=xxxxxxxxxx
# Create a remote session for ml-tst-gwc
$cred=Get-Credential
$ComputerName="mycompany.germanywestcentral.cloudapp.azure.com"
winrm set winrm/config/client  '@{TrustedHosts="mycompany.germanywestcentral.cloudapp.azure.com"}'
$sess = New-PSSession -Credential $cred -ComputerName $ComputerName
Enter-PSSession $sess
#endregion

#region PSremote session on win19-rpa
# Before creating a PSR session, I need to associate the public ip address
# linked with the DNS name to the VM.
az network nic ip-config update \
 --name ipconfig1 \
 -g rg-rpa-tst-eus \
 --nic-name win19-rpa-proxy-t187 \
 --public-ip-address win19-pip
#
# Create a PS remote session
$usernameme=admin
$password=xxxxxxxxxx
# Create a remote session for win19-rpa
$cred=Get-Credential
$ComputerName="mycompany.eastus.cloudapp.azure.com"
winrm set winrm/config/client  '@{TrustedHosts="mycompany.eastus.cloudapp.azure.com"}'
$sess = New-PSSession -Credential $cred -ComputerName $ComputerName
Enter-PSSession $sess

# Remove the public ip address after the session termination
az network nic ip-config update \
 --name ipconfig1 \
 -g rg-rpa-tst-eus \
 --nic-name win19-rpa-proxy-t187 \
 --remove PublicIpAddress
#
#endregion
#endregion

# How to Delete files/folders using PS
remove-item -path C:\Users\admin\Desktop\New folder (2)

# Get network category for your network connection
# to check whether it's Private or Public.
Get-NetConnectionProfile

# Change Connection from Public to Private
Set-NetConnectionProfile -InterfaceIndex <index number> -NetworkCategory Private

New-Object System.Net.Sockets.TCPClient -ArgumentList "20.218.83.190",RDP 4096

Get-Item WSMan:\localhost\Client\TrustedHosts


Get-Service -DisplayName "Remote Desktop Service" –RequiredServices
Get-Service -ComputerName daman-tst.centralus.cloudapp.azure.com -DisplayName "Remote Desktop Service" | Restart-Service

Enable-WSManCredSSP -Role "Client" -DelegateComputer "mycomputer"
Enable-WSManCredSSP -Role "Server" -DelegateComputer "mycompany.centralus.cloudapp.azure.com"


# using powershell
if ((Get-ItemProperty "hklm:\System\CurrentControlSet\Control\Terminal Server").fDenyTSConnections -eq 0) { write-host "RDP is Enabled" } else { write-host "RDP is NOT enabled" }

$ServiceStatus = Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList "$Service"


# using powershell
Get-EventLog application -EntryType Error -After (Get-Date).AddDays(-1)
Get-EventLog system -EntryType Error -After (Get-Date).AddDays(-1)




