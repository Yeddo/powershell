### PowerShell template profile 
### Version 1.00
### Open PowerShell as administrator
### As a reminder, to enable unsigned script execution of local scripts on client Windows, 
### you need to run this line (or similar) from an elevated PowerShell prompt:
###     Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
### Create your profile by typing:
###     New-Item $PROFILE.CurrentUserAllHosts -ItemType File -Force
###     You’ll get an error if the file already exists. This is expected.
### File is located: C:\Users\<username>\Documents\WindowsPowerShell
### Copy this code below into your $profile
### Reload profile:
#     . $profile

# Find out if the current user identity is elevated (has admin rights)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# If so and the current host is a command line, then change to red color as warning to user that they are operating in an elevated context
if (($host.Name -match "ConsoleHost") -and ($isAdmin)) {
     $host.UI.RawUI.BackgroundColor = "DarkRed"
     $host.PrivateData.ErrorBackgroundColor = "White"
     $host.PrivateData.ErrorForegroundColor = "DarkRed"
     Clear-Host
}

# PROMPT
# UNIX-style convention for identifying whether user is elevated '#'(root) or not '$'.
function prompt { 
    $date = Get-Date -Format "yyyy-MM-dd"
    $time = Get-Date -Format "HH:mm:ss"
    $timezoneAbbreviations = @{
    "Dateline Standard Time" = "DST"
    "Samoa Standard Time" = "SST"
    "Hawaiian Standard Time" = "HST"
    "Alaskan Standard Time" = "AKST"
    "Pacific Standard Time" = "PST"
    "Pacific Standard Time (Mexico)" = "PST"
    "US Mountain Standard Time" = "MST"
    "Mountain Standard Time (Mexico)" = "MST"
    "Mountain Standard Time" = "MST"
    "Central America Standard Time" = "CAST"
    "Central Standard Time" = "CST"
    "Central Standard Time (Mexico)" = "CST"
    "Canada Central Standard Time" = "CCST"
    "SA Pacific Standard Time" = "SAPST"
    "Eastern Standard Time" = "EST"
    "Eastern Standard Time (Mexico)" = "EST"
    "Haiti Standard Time" = "HST"
    "Cuba Standard Time" = "CST"
    "SA Eastern Standard Time" = "SEST"
    "Turks And Caicos Standard Time" = "TCST"
    "Paraguay Standard Time" = "PST"
    "Atlantic Standard Time" = "AST"
    "Venezuela Standard Time" = "VST"
    "Central Brazilian Standard Time" = "CBST"
    "SA Western Standard Time" = "SWST"
    "Pacific SA Standard Time" = "PSAST"
    "Newfoundland Standard Time" = "NST"
    "Tocantins Standard Time" = "TST"
    "E. South America Standard Time" = "ESAST"
    "Argentina Standard Time" = "AST"
    "Greenland Standard Time" = "GST"
    "Montevideo Standard Time" = "MST"
    "Magallanes Standard Time" = "MST"
    "Saint Pierre Standard Time" = "SPST"
    "Bahia Standard Time" = "BST"
    "UTC-02" = "UTC-02"
    "Mid-Atlantic Standard Time" = "MST"
    "Azores Standard Time" = "AZOST"
    "Cape Verde Standard Time" = "CVST"
    "UTC" = "UTC"
    "Morocco Standard Time" = "MST"
    "GMT Standard Time" = "GMT"
    "Greenwich Standard Time" = "GST"
    "W. Europe Standard Time" = "WST"
    "Central Europe Standard Time" = "CEST"
    "Romance Standard Time" = "RST"
    "Central European Standard Time" = "CEST"
    "W. Central Africa Standard Time" = "WCAST"
    "Namibia Standard Time" = "NST"
    "Jordan Standard Time" = "JST"
    "GTB Standard Time" = "GTBST"
    "Middle East Standard Time" = "MEST"
    "Egypt Standard Time" = "EST"
    "Syria Standard Time" = "SST"
    "South Africa Standard Time" = "SAST"
    "FLE Standard Time" = "FST"
    "Turkey Standard Time" = "TST"
    "Israel Standard Time" = "IST"
    "Kaliningrad Standard Time" = "KST"
    "Libya Standard Time" = "LST"
    "Arabic Standard Time" = "AST"
    "Arab Standard Time" = "AST"
    "Belarus Standard Time" = "BST"
    "Russian Standard Time" = "RST"
    "E. Africa Standard Time" = "EAST"
    "Iran Standard Time" = "IRST"
    "Arabian Standard Time" = "AST"
    "Astrakhan Standard Time" = "AST"
    "Azerbaijan Standard Time" = "AZT"
    "Russia Time Zone 3" = "RTZ3"
    "Mauritius Standard Time" = "MST"
    "Saratov Standard Time" = "SST"
    "Georgian Standard Time" = "GST"
    "Caucasus Standard Time" = "CST"
    "Afghanistan Standard Time" = "AST"
    "West Asia Standard Time" = "WAST"
    "Ekaterinburg Standard Time" = "EST"
    "Pakistan Standard Time" = "PST"
    "Qyzylorda Standard Time" = "QST"
    "India Standard Time" = "IST"
    "Sri Lanka Standard Time" = "SLST"
    "Nepal Standard Time" = "NST"
    "Central Asia Standard Time" = "CAST"
    "Bangladesh Standard Time" = "BST"
    "Omsk Standard Time" = "OST"
    "Myanmar Standard Time" = "MST"
    "SE Asia Standard Time" = "SEAST"
    "Altai Standard Time" = "AST"
    "W. Mongolia Standard Time" = "WMST"
    "North Asia Standard Time" = "NAST"
    "N. Central Asia Standard Time" = "NCAST"
    "Tomsk Standard Time" = "TST"
    "China Standard Time" = "CST"
    "North Asia East Standard Time" = "NAEST"
    "Singapore Standard Time" = "SST"
    "W. Australia Standard Time" = "WAST"
    "Taipei Standard Time" = "TST"
    "Ulaanbaatar Standard Time" = "UST"
    "North Korea Standard Time" = "NKST"
    "Aus Central W. Standard Time" = "ACWST"
    "Transbaikal Standard Time" = "TST"
    "Tokyo Standard Time" = "TST"
    "Korea Standard Time" = "KST"
    "Yakutsk Standard Time" = "YST"
    "Cen. Australia Standard Time" = "CAST"
    "AUS Central Standard Time" = "ACST"
    "E. Australia Standard Time" = "EAST"
    "AUS Eastern Standard Time" = "AEST"
    "West Pacific Standard Time" = "WPST"
    "Tasmania Standard Time" = "TST"
    "Vladivostok Standard Time" = "VST"
    "Lord Howe Standard Time" = "LHST"
    "Bougainville Standard Time" = "BST"
    "Russia Time Zone 10" = "RTZ10"
    "Magadan Standard Time" = "MST"
    "Norfolk Standard Time" = "NST"
    "Sakhalin Standard Time" = "SST"
    "Central Pacific Standard Time" = "CPST"
    "Russia Time Zone 11" = "RTZ11"
    "New Zealand Standard Time" = "NZST"
    "UTC+12" = "UTC+12"
    "Fiji Standard Time" = "FST"
    "Chatham Islands Standard Time" = "CIST"
    "UTC+13" = "UTC+13"
    "Tonga Standard Time" = "TST"
    "Line Islands Standard Time" = "LIST"
    }
    
    $timezone = [System.TimeZoneInfo]::Local.StandardName
    $abbreviation = $timezoneAbbreviations[$timezone]
    if ($abbreviation -eq $null) {
        $abbreviation = $timezone
    }
 
    $pwd = Get-Location
    
    if ($isAdmin) {
        "$date $time $abbreviation [" + $pwd + "] # " 
    }
    else {
        "$date $time $abbreviation [" + $pwd + "] $ " 
    }
} ### END PROMPT SECTION ###


# WINDOW TITLE
# Shows current version of Powershell and appends [ADMIN] if appropriate
$Host.UI.RawUI.WindowTitle = "PowerShell {0}" -f $PSVersionTable.PSVersion.ToString()
if ($isAdmin)
{
    $Host.UI.RawUI.WindowTitle += " [ADMIN]"
} # END WINDOW TITLE


# Does the the rough equivalent of dir /s /b. For example, dirs *.png is dir /s /b *.png
function dirs {
    if ($args.Count -gt 0) {
        Get-ChildItem -Recurse -Include "$args" | Foreach-Object FullName
    }
    else {
        Get-ChildItem -Recurse | Foreach-Object FullName
    }
}

# Function to start a new elevated ISE.
# If arguments are supplied then a single command is started with admin rights; if not then a new admin instance of PowerShell is started.
function admin {
    if ($args.Count -gt 0) {   
       $argList = "& '" + $args + "'"
       Start-Process "$psHome\powershell_ise.exe" -Verb runAs -ArgumentList $argList
    }
    else {
       Start-Process "$psHome\powershell_ise.exe" -Verb runAs
    }
}

# Compute file hashes - useful for checking successful downloads 
function md5    { Get-FileHash -Algorithm MD5 $args }
function sha1   { Get-FileHash -Algorithm SHA1 $args }
function sha256 { Get-FileHash -Algorithm SHA256 $args }


# Set UNIX-like aliases for the admin command, so sudo <command> will run the command with elevated rights. 
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

# Get your current public IP
Function Get-PubIP {
 (Invoke-WebRequest http://ifconfig.me/ip ).Content
}

# Get the date and time in UTC
Function Get-Zulu {
 Get-Date -Format u
}

# Generate a pseudo random password
Function Get-Pass {
-join(48..57+65..90+97..122|ForEach-Object{[char]$_}|Get-Random -C 20)
}

# Display system uptime
function uptime {
        Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';
        EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}
}

# Reload profile
function reload-profile {
        & $profile
}

# Find a file
function find-file($name) {
        ls -recurse -filter "*${name}*" -ErrorAction SilentlyContinue | foreach {
                $place_path = $_.directory
                echo "${place_path}\${_}"
        }
}

# Unzip a file
function unzip ($file) {
        $dirname = (Get-Item $file).Basename
        echo("Extracting", $file, "to", $dirname)
        New-Item -Force -ItemType directory -Path $dirname
        expand-archive $file -OutputPath $dirname -ShowProgress
}

# Linux-like Scripts
#grep
function grep($regex, $dir) {
        if ( $dir ) {
                ls $dir | select-string $regex
                return
        }
        $input | select-string $regex
}

# touch
function touch($file) {
        "" | Out-File $file -Encoding ASCII
}

# df
function df {
        get-volume
}

# sed
function sed($file, $find, $replace){
        (Get-Content $file).replace("$find", $replace) | Set-Content $file
}

# which
function which($name) {
        Get-Command $name | Select-Object -ExpandProperty Definition
}

# export
function export($name, $value) {
        set-item -force -path "env:$name" -value $value;
}

# pkill
function pkill($name) {
        ps $name -ErrorAction SilentlyContinue | kill
}

# pgrep
function pgrep($name) {
        ps $name
}

# Don't need these any more; they were just temporary variables to get to $isAdmin. 
Remove-Variable identity
Remove-Variable principal


### Transcript Section ###
# Used to setup automated transcript start when PowerShell starts
# Transcriptions were added in PowerShell v 5.0. They record the input and output of anything that is show in the PowerShell terminal.
# Get-Help Start-Transcript -ShowWindow.

## Transcript Section Variables ##
$TranscriptDir = "C:\transcripts\"

# Transcript log sets up the file's name. It will tell you:
     # - the computer the transcript came from
     # - the user's PowerShell session that is recordedf
     # - the day the transcript was made
$TranscriptLog = (hostname)+"_"+$env:USERNAME+"_"+(Get-Date -UFormat "%Y-%m-%d")+".txt"

# Transcript Path is the full path and file name of the transcript log.
$TrascriptPath = $TranscriptDir + $TranscriptLog
## end of transcript section variables ##

# Test to see if the transcript directory exists. If it doesn't create it.
if (!($TranscriptDir)) {
    New-Item -path $TranscriptDir -ItemType Directory -Force
}

# Start the transcription based on the path we've created above
Start-Transcript -LiteralPath $TrascriptPath -Append
### END TRANSCRIPT SECTION ###
