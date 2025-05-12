<#
.SYNOPSIS
Boutrik's Dotfiles install script for Windows

.DESCRIPTION
This script automates the setup of my Windows environment by installing:
1. Chocolatey (package manager)
2. VsCode (integrated development environment)
3. Komorebi (tiling window manager)
4. Yasb (functional bar)

.EXAMPLE
.\install.ps1 -Install
Runs the installation process
#>

# Script parameters
param (
    [switch]$Install,
    [switch]$Stop,
    [switch]$Help
)

# Display help information and usage examples
function Show-Help() {
    Write-Host @"
USAGE: .\install.ps1 [-Install] [-Stop] [-Help]

OPTIONS:
    -Install    Run the installation process.
    -Stop       Stop komorebi and yasb (for debug purposes).
    -Help       Show this help message.

INSTALLATION INCLUDES:
    1. Chocolatey (package manager)
    2. VsCode (integrated development environment)
    3. Komorebi (tiling window manager)
    4. Yasb (functional bar)

"@
}

# Checks if a command/program is installed on the system
function Check-Installed {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$CommandName,
        [Parameter()]
        [string]$ErrorMessage = "---",
        [Parameter()]
        [switch]$Quiet
    )

    if (!(Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        throw "ERROR: $ErrorMessage installation failed."
    } else {
        if (-not $Quiet) {
            Write-Host "$CommandName installed." -ForegroundColor Green
        }
        return $true
    }
}

# Stops Komorebi and Yasb (for debug purposes)
function Stop-All() {
    if (Check-Installed komorebic -Quiet:$true) {
        komorebic stop
        komorebic kill
    }
    if (Check-Installed yasbc -Quiet:$true) {
        yasbc stop
    }
}

# Refresh environment variables (machine + user)
function Refresh-Env() {
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

# Install Chocolatey
function Install-Chocolatey() {
    if (!(Get-Command choco -ErrorAction SilentlyContinue)) {
        # Allow script execution (temporary)
        Set-ExecutionPolicy Bypass -Scope Process -Force

        # Force TLS 1.2 for secure download
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

        # Install Chocolatey
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

        Refresh-Env

        Check-Installed -CommandName "choco" -ErrorMessage "Chocolatey"
    }
}

# Install some packages using Chocolatey
function Install-Packages() {
    Write-Host "Install-Packages not implemented yet." -ForegroundColor Yellow

    choco install -y vscode make cmake
    Refresh-Env
}

# Install Komorebi and Yasb
function Install-Komorebi() {
    if (!(Get-Command winget -ErrorAction SilentlyContinue)) {
        throw "ERROR: Winget not found. Please install it first."
    }

    # Install Komorebi and its hotkey daemon
    winget install --id LGUG2Z.komorebi --accept-package-agreements --accept-source-agreements
    winget install --id LGUG2Z.whkd --accept-package-agreements --accept-source-agreements

    # Install Yasb bar and its required fonts
    choco install -y jetbrainsmono nerd-fonts-JetBrainsMono
    winget install --id AmN.yasb --accept-package-agreements --accept-source-agreements

    Refresh-Env

    Check-Installed -CommandName "komorebic" -ErrorMessage "Komorebi"
    Check-Installed -CommandName "yasbc" -ErrorMessage "Yasb"

    # Quickstart configuration
    komorebic quickstart

    # Apply custom configuration
    # Invoke-WebRequest -Uri "https://raw.githubusercontent.com/alexandreboutrik/dotfiles/main/acer-nitro-5/komorebi.json" -OutFile "$env:USERPROFILE\komorebi.json" -ErrorAction Stop
    #
    Copy-Item -Path "$env:USERPROFILE\komorebi-custom.json" -Destination "$env:USERPROFILE\komorebi.json" -Force
    Write-Host "Custom config loaded." -ForegroundColor Green

    komorebic start --whkd
    yasbc start
}

# Main
try {
    # Check if running as Administrator
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        throw "ERROR: Execute this script as Administrator."
    }

    if ($Help -or ($PSBoundParameters.Count -eq 0)) { Show-Help ; exit 0 }

    if ($Stop) { Stop-All ; exit 0 }

    if ($Install) {
        Install-Chocolatey
        Install-Packages
        Install-Komorebi
    }
}
catch {
    Write-Host "ERROR: $_" -ForegroundColor Red
    exit 1
}
