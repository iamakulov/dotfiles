# The script is untested yet and should be tested in the wild

## Functions
function Get-IsRunningElevated() {
    $windowsPrincipal = [Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())
    $administratorRole = [Security.Principal.WindowsBuiltInRole]::Administrator

    Return $windowsPrincipal.IsInRole($administratorRole)
}

function Add-ConsoleFont($Font) {
    New-ItemProperty -Name 000 -Value "$Font" -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont"
}

function Init-Chocolatey() {
    Invoke-Expression (New-Object NET.WebClient).DownloadString('https://chocolatey.org/install.ps1')
}

function Init-Scoop() {
    Invoke-Expression (New-Object NET.WebClient).DownloadString('https://get.scoop.sh')
}

function Init-PowerShell() {
    # Restart the script in elevated console if necessary
    if (-Not (Get-IsRunningElevated)) {
        Read-Host -Prompt "Press Enter to relaunch the script in elevated invironment"
        Start-Process powershell -Verb runAs -ArgumentList "$PSCommandPath; Pause"
        Return
    }

    # Update execution policy to let modules run
    Set-ExecutionPolicy RemoteSigned

    # Init the profile
    Copy-Item .\powershell\Microsoft.PowerShell_profile.ps1 $profile -Force

    # Register package managers
    Init-Chocolatey
    Init-Scoop

    # Install necessary modules
    scoop install sudo
    Install-Module posh-git -Scope CurrentUser
    Install-Module posh-npm -Scope CurrentUser
    Install-Module go -Scope CurrentUser

    # Add console fonts
    Add-ConsoleFont Hack
}


## Execute functions
Init-PowerShell