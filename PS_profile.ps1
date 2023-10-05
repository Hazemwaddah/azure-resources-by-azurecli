## about_Profiles


# To display the current values of the $PROFILE variable, type:
 $PROFILE | Get-Member -Type NoteProperty
#

# The following command opens the "Current User, Current Host" profile in Notepad
notepad $PROFILE               # CurrentUserCurrentHost
notepad $PROFILE.CurrentUserAllHosts              
notepad $PROFILE.AllUsersAllHosts
notepad $PROFILE.AllUsersCurrentHost              

# The following command determines whether an "All Users, All Hosts" profile has been created on the local computer
Test-Path -Path $PROFILE.AllUsersAllHosts
Test-Path -Path $PROFILE.AllUsersCurrentHost
Test-Path -Path $PROFILE.CurrentUserAllHosts
Test-Path -Path $PROFILE.CurrentUserCurrentHost

## How to create a profile without overrwriting an existing one, that's the job of the if condition.
if (!(Test-Path -Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force
  }
#


#region ################ Suggestions to put in the profile file #######################
# Add commands that make it easy to open your profile
function Pro {notepad $PROFILE.CurrentUserAllHosts}

# Add a function that lists the aliases for any cmdlet
function Get-CmdletAlias ($cmdletname) {
    Get-Alias |
      Where-Object -FilterScript {$_.Definition -like "$cmdletname"} |
        Format-Table -Property Definition, Name -AutoSize
  }        
  Get-CmdletAlias
# 

# Customize your console
function Color-Console {
    $Host.ui.rawui.backgroundcolor = "white"
    $Host.ui.rawui.foregroundcolor = "black"
    $hosttime = (Get-ChildItem -Path $PSHOME\PowerShell.exe).CreationTime
    $hostversion="$($Host.Version.Major)`.$($Host.Version.Minor)"
    $Host.UI.RawUI.WindowTitle = "PowerShell $hostversion ($hosttime)"
    Clear-Host
  }
  Color-Console
#

# Add a customized PowerShell prompt
function Prompt
{
$env:COMPUTERNAME + "\" + (Get-Location) + "> "
}

#endregion


# Remote
# The following command runs the "Current user, Current Host" profile from the local computer in the session in $s.
Invoke-Command -Session $s -FilePath $PROFILE

# The following command runs the "Current user, Current Host" profile from the remote computer in the session in $s. 
# Because the $PROFILE variable is not populated, the command uses the explicit path to the profile. 
# We use dot sourcing operator so that the profile executes in the current scope on the remote computer and not in its own scope.
Invoke-Command -Session $s -ScriptBlock {
    . "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
  }
#


# A Set-ExecutionPolicy command sets and changes your execution policy. 
# It is one of the few commands that applies in all PowerShell sessions because the value is saved in the registry. 
# You do not have to set it when you open the console, and you do not have to store a Set-ExecutionPolicy command in your profile.
Set-ExecutionPolicy
Get-ExecutionPolicy

# Example 1: Get all execution policies
Get-ExecutionPolicy -List

# Example 2: Set an execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

# Example 3: Unblock a script to run it without changing the execution policy
# This example shows how the RemoteSigned execution policy prevents you from running unsigned scripts.
# A best practice is to read the script's code and verify it's safe before using the Unblock-File cmdlet. 
# The Unblock-File cmdlet unblocks scripts so they can run, but doesn't change the execution policy.
#region #################### Unblock a file ##########################
PS> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine

PS> Get-ExecutionPolicy

RemoteSigned

PS> .\Start-ActivityTracker.ps1

.\Start-ActivityTracker.ps1 : File .\Start-ActivityTracker.ps1 cannot be loaded.
The file .\Start-ActivityTracker.ps1 is not digitally signed.
The script will not execute on the system.
For more information, see about_Execution_Policies at https://go.microsoft.com/fwlink/?LinkID=135170.
At line:1 char:1
+ .\Start-ActivityTracker.ps1
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ CategoryInfo          : NotSpecified: (:) [], PSSecurityException
+ FullyQualifiedErrorId : UnauthorizedAccess

PS> Unblock-File -Path .\Start-ActivityTracker.ps1

PS> Get-ExecutionPolicy

RemoteSigned

PS> .\Start-ActivityTracker.ps1

Task 1:
#endregion






