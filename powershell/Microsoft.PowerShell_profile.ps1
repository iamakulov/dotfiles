# Store specific configuration
$ProfileInitialSettings = @{
	DefaultBackgroundColor = (Get-Host).UI.RawUI.BackgroundColor
	DefaultForegroundColor = (Get-Host).UI.RawUI.ForegroundColor
}

# Init posh-git
Import-Module posh-git
Start-SshAgent -Quiet

# Init posh-npm
Import-Module posh-npm

# Set up a prompt
function prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    # Reset colors
	$Host.UI.RawUI.BackgroundColor = $ProfileInitialSettings.DefaultBackgroundColor
    $Host.UI.RawUI.ForegroundColor = $ProfileInitialSettings.DefaultForegroundColor

	# Is command ran as administrator?
	$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
	$principal = [Security.Principal.WindowsPrincipal] $identity
	$isAdministrator = $principal.IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")
	
	# Write the prompt
	# ...Current path
	Write-Host
    Write-Host (Get-Location).Path -NoNewLine

	# ...Git branch
    Write-VcsStatus
	
	# ...PS >
	Write-Host
	if ($isAdministrator) {
		$promptColor = [ConsoleColor]"Red"
	} else {
		$promptColor = [ConsoleColor]"Blue"
	}
	Write-Host "PS ❯" -NoNewLine -ForegroundColor $promptColor
	
    $global:LASTEXITCODE = $realLASTEXITCODE
    return " "
}

# Switch the directory if necessary
$currentLocation = Get-Location

Set-Location $PSScriptRoot
$initialPaths = Get-Content ./Config/initial-paths.json | ConvertFrom-Json
$computerName = (Get-Content env:computername).ToLower()

if ($initialPaths.$computerName) {
	Set-Location $initialPaths.$computerName
} else {
	Set-Location $currentLocation
}