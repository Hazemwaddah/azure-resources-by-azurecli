
#region set RDP port
param($RDPPort=3389)

$TSPath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server'
$RDPTCPpath = $TSPath + '\Winstations\RDP-Tcp'
Set-ItemProperty -Path $TSPath -name 'fDenyTSConnections' -Value 0

# RDP port
$portNumber = (Get-ItemProperty -Path $RDPTCPpath -Name 'PortNumber').PortNumber
Write-Host Get RDP PortNumber: $portNumber
if (!($portNumber -eq $RDPPort))
{
  Write-Host Setting RDP PortNumber to $RDPPort
  Set-ItemProperty -Path $RDPTCPpath -name 'PortNumber' -Value $RDPPort
  Restart-Service TermService -force
}

#Setup firewall rules
if ($RDPPort -eq 3389)
{
  netsh advfirewall firewall set rule group="remote desktop" new Enable=Yes
} 
else
{
  $systemroot = get-content env:systemroot
  netsh advfirewall firewall add rule name="Remote Desktop - Custom Port" dir=in program=$systemroot\system32\svchost.exe service=termservice action=allow protocol=TCP localport=$RDPPort enable=yes
}
#endregion




# You can check the current port by running the following PowerShell command:
Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "PortNumber"

PortNumber   : 3389
PSPath       : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp
PSParentPath : Microsoft.PowerShell.Core\Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations
PSChildName  : RDP-Tcp
PSDrive      : HKLM
PSProvider   : Microsoft.PowerShell.Core\Registry


#region To add a new RDP Port to the registry:
$portvalue = 4096
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "PortNumber" -Value $portvalue 
New-NetFirewallRule -DisplayName 'RDPPORTLatest-TCP-In' -Profile 'Private' -Direction Inbound -Action Allow -Protocol TCP -LocalPort $portvalue 
New-NetFirewallRule -DisplayName 'RDPPORTLatest-UDP-In' -Profile 'Private' -Direction Inbound -Action Allow -Protocol UDP -LocalPort $portvalue
Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "PortNumber"
#endregion

#region Checks registry settings and domain policy settings. Suggests policy actions 
# if machine is part of a domain or modifies the settings to default values.
$RDPTCPpath = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\Winstations\RDP-Tcp'
$TSpath = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services'
$msg = 'Set Computer Configuration\Policies\Administrative Templates: Policy definitions\Windows Components\Remote Desktop Services\Remote Desktop Session Host\'
$domainJoined = (gwmi win32_computersystem).partofdomain
if ($domainJoined) {
  Write-Host Domain: (gwmi win32_computersystem).Domain
} else {
  Write-Host Not domain joined
  Set-ItemProperty -Path $RDPTCPpath -name LanAdapter -Value 0
}

function ReadReg()
{
  Param($Path,$Name,$Expected,$Text)
  $Value=(Get-ItemProperty -Path $Path -Name $Name -ErrorAction SilentlyContinue).$Name
  Write-Host ($Path+'\'+$Name+': '+$Value)
  if (!($Expected -eq $null) -and !($Expected -eq $Value)) {
    if ($domainJoined) {
      if (!($Value -eq $null)) {
        Write-Host ($msg+$Text)
      }
    } else {
      Write-Host Reset value to expected: $Expected
      Set-ItemProperty -Path $Path -Name $Name -Value $Expected -ErrorAction SilentlyContinue
    }
  }
}

ReadReg -Path $RDPTCPpath -Name PortNumber
ReadReg -Path $TSpath -Name fDenyTSConnections -Text 'Connections\Allow users to connect remotely by using Remote Desktop Services'

$t = 'Connections\Configure keep-alive connection interval'
ReadReg -Path $TSpath -Name KeepAliveEnable -Expected 1 -Text $t
ReadReg -Path $TSpath -Name KeepAliveInterval -Expected 1 -Text $t
ReadReg -Path $TSpath -Name KeepAliveTimeout -Expected 1 -Text $t

$t = 'Connections\Automatic reconnection'
ReadReg -Path $TSpath -Name fDisableAutoReconnect -Expected 0 -Text $t
ReadReg -Path $RDPTCPpath -Name fInheritReconnectSame -Expected 1 -Text $t
ReadReg -Path $RDPTCPpath -Name fReconnectSame -Expected 0 -Text $t

ReadReg -Path $RDPTCPpath -Name fInheritMaxSessionTime -Expected 1 -Text 'Session Time Limits\Set time limit for active Remote Desktop Session Services sessions'

$t = 'Session Time Limits\Set time limit for disconnected sessions'
ReadReg -Path $RDPTCPpath -Name fInheritMaxDisconnectionTime -Expected 1 -Text $t
ReadReg -Path $RDPTCPpath -Name MaxDisconnectionTime -Expected 0 -Text $t

ReadReg -Path $RDPTCPpath -Name MaxConnectionTime -Expected 0 -Text 'Session Time Limits\End session when time limits are reached'

$t = 'Session Time Limits\Set time limit for active but idle Remote Desktop Services sessions'
ReadReg -Path $RDPTCPpath -Name fInheritMaxIdleTime -Expected 1 -Text $t
ReadReg -Path $RDPTCPpath -Name MaxIdleTime -Expected 0 -Text $t

ReadReg -Path $RDPTCPpath -Name MaxInstanceCount -Expected 4294967295 -Text 'Connections\Limit number of connections'
#endregion

#region ResetRDPCert

# Removes the SSL certificate tied to the RDP listener and restores the RDP listener 
# security to default. Use this script if you see any issues with the certificate.
Write-Host Clear security certificates. Removes SSLCertificateSHA1Hash from the registry.
$name = 'SSLCertificateSHA1Hash'
$path = 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp'
Remove-ItemProperty -Path $path -Name $name -ErrorAction SilentlyContinue
Set-ItemProperty -Path $path -Name 'MinEncryptionLevel' -Value 1
Set-ItemProperty -Path $path -Name 'SecurityLayer' -Value 0
Remove-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet001\Control\Terminal Server\WinStations\RDP-Tcp' -Name $name -ErrorAction SilentlyContinue
Remove-ItemProperty -Path 'HKLM:\SYSTEM\ControlSet002\Control\Terminal Server\WinStations\RDP-Tcp' -Name $name -ErrorAction SilentlyContinue
Write-Host Restart the service
restart-service TermService -force
#endregion










