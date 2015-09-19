# The script is untested yet and should be tested in the wild

function Init-Git() {
    Copy-Item .\git\.gitconfig ~\.gitconfig
}

function Init-PowerShell() {
    # Init the profile
    Copy-Item .\powershell\Microsoft.PowerShell_profile.ps1 $profile -Force

    # Install necessary modules
    Install-Module posh-git
    Install-Module posh-npm
    Install-Module go
}