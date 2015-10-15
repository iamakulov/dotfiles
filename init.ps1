function Init-Git() {
    Push-Location
    Set-Location .\git
    .\init.ps1
    Pop-Location
}

function Init-PowerShell() {
    Push-Location
    Set-Location .\powershell
    .\init.ps1
    Pop-Location
}

Init-Git
Init-PowerShell