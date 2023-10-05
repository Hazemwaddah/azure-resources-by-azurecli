# Windows Defender using PowerShell
Install-module -name WindowsDefender -AllowClobber -force

## Check the status of Windows Defender
Get-MpComputerStatus

## Stop Windows Defender service
Set-MpPreference -DisableRealtimeMonitoring $true

## Uninstall/Remove Windows Defender service
Uninstall-WindowsFeature -Name Windows-Defender

## Start Windows Defender service
sc start WinDefend

## Stop Windows Defender service
sc stop WinDefend

## Uninstall/Remove Windows Defender service
sc config WinDefend start= disabled
sc stop WinDefend

## Check the current state
sc query WinDefend

# Start a computer scan
Start-MpScan
     [-ScanPath <String>]
     [-ScanType <ScanType>] # Full/Quick/Custom scan
     [-CimSession <CimSession[]>]
     [-ThrottleLimit <Int32>]
     [-AsJob]
     [<CommonParameters>]
#
Start-MpScan -ScanType full -AsJob

# Get the detected malware/threats
Get-MpThreatDetection |out-gridview
# Gets the history of threats detected on the computer.
Get-MpThreat
# Gets known threats from the definitions catalog.
Get-MpThreatCatalog
## Schedule a periodic full scan daily to work in the background
Set-MpPreference -ScanOnlyIfIdleEnabled $true
Set-MpPreference -ScanParameters
Set-MpPreference -ScanScheduleDay 0
Set-MpPreference -ScanScheduleTime
Set-MpPreference -RandomizeScheduleTaskTimes
# 0: Everyday
#1: Sunday
#2: Monday
#3: Tuesday
#4: Wednesday
#5: Thursday
#6: Friday
#7: Saturday
#8: Never

# Gets preferences for the Windows Defender scans and updates.
Get-MpPreference

## PowerShell cmdlets for scheduling scans when an endpoint is not in use
Set-MpPreference -ScanOnlyIfIdleEnabled $true

## Display Defender services with their status working/stopped
get-service | where {$_.DisplayName -Like "Defender*"} | Select Status,DisplayName

## Update AV signature
update-mpsignature
## Example 1: Schedule to check for definition updates everyday
Set-MpPreference -SignatureScheduleDay Everyday

## Add an exclusion from AV protection
Set-MpPreference -ExclusionPath C:\
Set-MpPreference -ExclusionPath C:\Users\Hazem\.wsl
Set-MpPreference -ExclusionPath F:\Cracks
## Remove the exclusion from AV protection
Remove-MpPreference -ExclusionPath C:\
Remove-MpPreference -ExclusionPath F:\Cracks

Send-MailMessage
$PSEmailServer='smtp.office365.com'
Send-MailMessage -From 'User01 xxxxxxx@live.com' -To 'User02 xxxxxxx@live.com' -Subject 'Test mail' -smtpserver $PSEmailServer

Send-MailMessage -From 'xxxxxxx@live.com' -To 'xxxxxxx@live.com' -Subject 'Test mail' -smtpserver 'smtp.office365.com'




reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /f

reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies" /f

reg delete "HKCU\Software\Microsoft\WindowsSelfHost" /f

reg delete "HKCU\Software\Policies" /f 

reg delete "HKLM\Software\Microsoft\Policies" /f 

reg delete "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies" /f

reg delete "HKLM\Software\Microsoft\WindowsSelfHost" /f 

reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\Policies" /f

reg delete "HKLM\Software\WOW6432Node\Microsoft\Windows\CurrentVersion\WindowsStore\WindowsUpdate" /f



## Reset Windows Security for NOT opening [common in Windows 11]
Get-AppxPackage Microsoft.SecHealthUI -AllUsers | Reset-AppxPackage

Get-AppxPackage *

Get-AppxPackage *Microsoft.SecHealthUI* | Reset-AppxPackage
Get-AppxPackage *Windos.immersivecontrolpanel* | Reset-AppxPackage

Install-Module -name Appx -repository  PSGallery -AllowClobber
Install-Module -name Appx -repository  NuGet -AllowClobber

Import-Module Appx
import-module appx
Find-Module -Name Appx | Install-Module
get-module  -ListAvailable
Get-InstalledModule
Get-PSRepository