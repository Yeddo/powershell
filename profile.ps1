### PowerShell template profile 
### Version 1.00 - Yeddo
### From https://
### Open PowerShell as administrator
#Create your profile by typing New-Item $profile
#You’ll get an error if the file already exists. This is expected.
#Copy the code block below into your $profile
#     Set-Location $env:TEMP
#     Import-Module PSReadLine -Verbose
#     Set-Alias ll Get-ChildItem -Option AllScope
#Type:
#     & $profile

### This file should be stored in $PROFILE.CurrentUserAllHosts
### If $PROFILE.CurrentUserAllHosts doesn't exist, you can make one with the following:
###    PS> New-Item $PROFILE.CurrentUserAllHosts -ItemType File -Force
### This will create the file and the containing subdirectory if it doesn't already 
###
### As a reminder, to enable unsigned script execution of local scripts on client Windows, 
### you need to run this line (or similar) from an elevated PowerShell prompt:
###   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
### For more information about execution policies, run Get-Help about_Execution_Policies.

# Find out if the current user identity is elevated (has admin rights)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# If so and the current host is a command line, then change to red color 
# as warning to user that they are operating in an elevated context
if (($host.Name -match "ConsoleHost") -and ($isAdmin))
{
     $host.UI.RawUI.BackgroundColor = "DarkRed"
     $host.PrivateData.ErrorBackgroundColor = "White"
     $host.PrivateData.ErrorForegroundColor = "DarkRed"
     Clear-Host
}

# Useful shortcuts for traversing directories
function cd...  { cd ..\.. }
function cd.... { cd ..\..\.. }

# Compute file hashes - useful for checking successful downloads 
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }

# Quick shortcut to start notepad
function n      { notepad $args }

# Drive shortcuts
function HKLM:  { Set-Location HKLM: }
function HKCU:  { Set-Location HKCU: }
function Env:   { Set-Location Env: }

# Creates drive shortcut for Work Folders, if current user account is using it
if (Test-Path "$env:USERPROFILE\Work Folders")
{
    New-PSDrive -Name Work -PSProvider FileSystem -Root "$env:USERPROFILE\Work Folders" -Description "Work Folders"
    function Work: { Set-Location Work: }
}

# Creates drive shortcut for OneDrive, if current user account is using it
if (Test-Path HKCU:\SOFTWARE\Microsoft\OneDrive)
{
    $onedrive = Get-ItemProperty -Path HKCU:\SOFTWARE\Microsoft\OneDrive
    if (Test-Path $onedrive.UserFolder)
    {
        New-PSDrive -Name OneDrive -PSProvider FileSystem -Root $onedrive.UserFolder -Description "OneDrive"
        function OneDrive: { Set-Location OneDrive: }
    }
    Remove-Variable onedrive
}

### Prompt section ###
# Prompt is a reserved name for the function that covers how your prompt is setup.
# Prompt is a reserved name for the function that covers how your prompt is setup.
#function prompt {
#    # Shout out to the Stack Overflow article that helped with this test.
#    # https://serverfault.com/questions/95431/in-a-powershell-script-how-can-i-check-if-im-running-with-administrator-privil
#    if ($IsWindows) {
#        $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
#        if ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
#            "n$(Get-Date -Format "yyyy-MM-dd HH:mm:ss K")n$env:USERNAME as Administrator on $(hostname)n$pwdnPS > "
#        } else {
#            "n$(Get-Date -Format "yyyy-MM-dd HH:mm:ss K")n$env:USERNAME as standard user on $(hostname)n$pwdnPS > "
#        }
#    }
#
#    if ($isLinux -Or $isMac) {
#        "n$(Get-Date -Format "yyyy-MM-dd HH:mm:ss K")n$env:USERNAME on $(hostname)n$pwdnPS > "
#    }
#}

# Set up command prompt and window title. Use UNIX-style convention for identifying 
# whether user is elevated (root) or not. Window title shows current version of PowerShell
# and appends [ADMIN] if appropriate for easy taskbar identification
function prompt { 
    if ($isAdmin) {
        "[" + (Get-Location) + "] # " 
    }
    else {
        "[" + (Get-Location) + "] $ "
    }
}

### end of prompt section ###

$Host.UI.RawUI.WindowTitle = "PowerShell {0}" -f $PSVersionTable.PSVersion.ToString()
if ($isAdmin)
{
    $Host.UI.RawUI.WindowTitle += " [ADMIN]"
}

# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    }
    else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

# Simple function to start a new elevated process. If arguments are supplied then 
# a single command is started with admin rights; if not then a new admin instance
# of PowerShell is started.
function admin {
    if ($args.Count -gt 0) {   
       $argList = "& '" + $args + "'"
       Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $argList
    }
    else {
       Start-Process "$psHome\powershell.exe" -Verb runAs
    }
}

# Set UNIX-like aliases for the admin command, so sudo <command> will run the command
# with elevated rights. 
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin

# Make it easy to edit this profile once it's installed
function Edit-Profile {
    if ($host.Name -match "ise") {
        $psISE.CurrentPowerShellTab.Files.Add($profile.CurrentUserAllHosts)
    }
    else {
        notepad $profile.CurrentUserAllHosts
    }
}

# We don't need these any more; they were just temporary variables to get to $isAdmin. 
# Delete them to prevent cluttering up the user profile. 
Remove-Variable identity
Remove-Variable principal


### Transcript Section ###
# Used to setup automated transcript start when PowerShell starts
# Transcriptions were added in PowerShell v 5.0. They record the input and output of anything that is show in the PowerShell terminal.
# Get-Help Start-Transcript -ShowWindow.

## Transcript Section Variables ##
# On Windows, I like to put it in the C drive directly.
if ($IsWindows) {
    $TranscriptDir = "C:\transcripts\"
}

# use linux or Mac path for those OSs
#if ($IsLinux -Or $IsMac) {
#    $TranscriptDir = "/home/test/.transcripts/"
#}

# Transcript log sets up the file's name. It will tell you:
     # - the computer the transcript came from
     # - the user's PowerShell session that is recordedf
     # - the day the transcript was made
$TranscriptLog = (hostname)+"_"+$env:USERNAME+"_"+(Get-Date -UFormat "%Y-%m-%d")

# Transcript Path is the full path and file name of the transcript log.
$TrascriptPath = $TranscriptDir + $TranscriptLog
## end of transcript section variables ##

# Test to see if the transcript directory exists. If it doesn't create it.
if (!($TranscriptDir)) {
    New-Item $TranscriptDir -Type Directory -Force
}

# Start the transcription based on the path we've created above
Start-Transcript -LiteralPath $TrascriptPath -Append

### end of transcript section ###

