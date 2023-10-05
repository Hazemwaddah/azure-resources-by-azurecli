

# Type the following command to install the module to run Windows Update
Install-Module PSWindowsUpdate


# Type the following command to check for updates with PowerShell
Get-WindowsUpdate


# Type the following command to install the available Windows 10 updates
Install-WindowsUpdate


# Type the following command to download and install all the available updates and reboot the system
Get-WindowsUpdate -AcceptAll -Install -AutoReboot


Get-NetFirewallRule -AssociatedNetFirewallPortFilter 5985
Get-NetFirewallRule -Description RDP


#region Enable Windows Automatic Updates:
$reg_path = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
if (-Not (Test-Path $reg_path)) { New-Item $reg_path -Force }
Set-ItemProperty $reg_path -Name NoAutoUpdate -Value 0
Set-ItemProperty $reg_path -Name AUOptions -Value 4
$reg_path = "HKLM:\Software\Policies\Microsoft\Windows\Task Scheduler\Maintenance"
if (-Not (Test-Path $reg_path)) { New-Item $reg_path -Force }
Set-ItemProperty $reg_path -Name "Activation Boundary" -Value "2000-01-01T01:00:00"
Set-ItemProperty $reg_path -Name Randomized -Value 1
Set-ItemProperty $reg_path -Name "Random Delay" -Value "PT4H"
#endregion

#region Disable Windows Automatic Updates
$reg_path = "HKLM:\Software\Policies\Microsoft\Windows\WindowsUpdate\AU"
if (-Not (Test-Path $reg_path)) { New-Item $reg_path -Force }
Set-ItemProperty $reg_path -Name NoAutoUpdate -Value 1
Set-ItemProperty $reg_path -Name AUOptions -Value 3
#endregion

#region Enable Admin Account
$adminAccount = Get-WmiObject Win32_UserAccount -filter "LocalAccount=True" | ? {$_.SID -Like "S-1-5-21-*-500"}
if($adminAccount.Disabled)
{
  Write-Host Admin account was disabled. Enabling the Admin account.
  $adminAccount.Disabled = $false
  $adminAccount.Put()
} else
{
  Write-Host Admin account is enabled.
}
#endregion

#region Enable Emergency Management Services (EMS) to allow for serial console connection in troubleshooting scenarios.
bcdedit /ems '{current}' on
bcdedit /emssettings EMSPORT:1 EMSBAUDRATE:115200
#endregion

