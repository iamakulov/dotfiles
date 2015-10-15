# The script is untested yet and should be tested in the wild

## Functions
function Add-ConsoleFont($Font) {
    Start-Process powershell -Verb runAs -ArgumentList "New-ItemProperty -Name 000 -Value '$Font' -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Console\TrueTypeFont'"
}

function Init-Chocolatey() {
    Get-PackageProvider -name Chocolatey -ForceBootstrap
    Set-PackageSource -Name chocolatey -Trusted
}

function Init-Scoop() {
    Invoke-Expression (New-Object NET.WebClient).DownloadString('https://get.scoop.sh')
}

function Init-PowerShell() {
    # Update execution policy to let modules run
    Start-Process powershell -Verb runAs -ArgumentList "Set-ExecutionPolicy RemoteSigned"

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