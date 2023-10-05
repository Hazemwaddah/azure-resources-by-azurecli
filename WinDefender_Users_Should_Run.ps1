# You can run this script in PowerShell.exe with "Run as administrator" and this will do 
# Enable Micrososft's built-in AV, update the signature, and do scan the computer

# Enable running scripts
set-executionpolicy unrestricted

# Add the repository PSGallery as trusted
Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted

# Make sure the module is 
Install-module -name WindowsDefender -AllowClobber -force

## Start Windows Defender service
sc start WinDefend

## Update AV signature
update-mpsignature

## Example 1: Schedule to check for definition updates everyday
Set-MpPreference -SignatureScheduleDay Everyday

## Schedule a periodic full scan daily to work in the background
## PowerShell cmdlets for scheduling scans when an endpoint is not in use
Set-MpPreference -ScanOnlyIfIdleEnabled $true

## Starts a scan in the background
Start-MpScan -ScanType full -AsJob

# Apply a best practice policy on local machine
set-executionpolicy Allsigned

