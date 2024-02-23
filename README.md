# powershell
powershell stuff


PowerShell Profile Locations:
Description	Path	                                                                                                        Command to open
Current user – Current host	$Home\[My ]Documents\PowerShell\Microsoft.PowerShell_profile.ps1	                            $profile
Current user –  All hosts	$Home\[My ]Documents\PowerShell\Profile.ps1                                                    	$profile.CurrentUserAllHosts
All Users – Current Host	$PSHOME\Microsoft.PowerShell_profile.ps1	                                                      $profile.AllUsersCurrentHost
All Users – All Hosts	$PSHOME\Profile.ps1                                                                                	$profile.AllUsersAllHosts

To create a specific profile for PowerShell ISE you will need to run the command from within PowerShell ISE itself.

Create your PowerShell Profile:
Test if you already have a profile. Open PowerShell and type:
test-path $profile

If it returns False, then we need to create the profile first, type:
New-Item -Path $profile -Type File -Force

To use the profile you will need to make sure you have set the Execution Policy to Remote Signed. Otherwise, you won’t be able to run the script when PowerShell opens. Make sure you run PowerShell with elevated permissions (admin mode) to change the execution policy:
Get-ExecutionPolicy
# Set the ExecutionPolicy to RemoteSigned:
Set-ExecutionPolicy RemoteSigned

The profile is now created, allowing you to open and edit the PowerShell Profile. Again we are using the PowerShell command to open the profile file:
ise $profile

Set Default Location
By default, PowerShell starts in your home folder $home. But you can set the default location to start PowerShell in:
# Set Default location
Set-Location D:\SysAdmin\scripts

Load scripts from different locations
Load the folders that contain the scripts into your environment path $env:path. This allows you to have access to all your script without the need to change directories every time:
# Load scripts from the following locations
$env:Path += ";D:\SysAdmin\scripts\PowerShellBasics"
$env:Path += ";D:\SysAdmin\scripts\Connectors"
$env:Path += ";D:\SysAdmin\scripts\Office365"

Set default variables
# Set default variables

Import modules or Scripts
Module files need to be placed in your modules folder: $HOME\Documents\PowerShell\Modules.
# Lazy way to use scripts as module
Set-Alias ConnectTo-SharePointAdmin ConnectTo-SharePointAdmin.ps1
Set-Alias ConnectTo-EXO ConnectTo-EXO.ps1
Set-Alias Get-MFAStatus MFAStatus.ps1
Set-Alias Get-MailboxSizeReport MailboxSizeReport.ps1
Set-Alias Get-OneDriveSizeReport OneDriveSizeReport.ps1

# Create aliases for frequently used commands
Set-Alias im Import-Module
Set-Alias tn Test-NetConnection

After you have made all the changes, save your profile file and restart your PowerShell console.
