


# Enable Hyper-v

# Disable Hyper-v
Remove-windowsfeature -name Hyper-V

# check if Hyper-v is enabled:
Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V

# Another way to check Hyper-v state:
$hyperv = Get-WindowsOptionalFeature -FeatureName Microsoft-Hyper-V-All -Online
# Check if Hyper-V is enabled
if($hyperv.State -eq "Enabled") {
    Write-Host "Hyper-V is enabled."
} else {
    Write-Host "Hyper-V is disabled."
}