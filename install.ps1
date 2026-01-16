#
# git-worth installer for Windows (PowerShell)
# Usage: .\install.ps1
#        or: iex (irm <url>/install.ps1)
#

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║       💰 git-worth installer           ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# Check for Python 3
Write-Host "Checking for Python 3..." -ForegroundColor Yellow

$pythonCmd = $null
$pythonVersion = $null

# Try python3 first
try {
    $pythonVersion = & python3 --version 2>&1
    if ($pythonVersion -match "Python 3") {
        $pythonCmd = "python3"
    }
} catch {}

# Try python
if (-not $pythonCmd) {
    try {
        $pythonVersion = & python --version 2>&1
        if ($pythonVersion -match "Python 3") {
            $pythonCmd = "python"
        }
    } catch {}
}

# Try py launcher (Windows Python launcher)
if (-not $pythonCmd) {
    try {
        $pythonVersion = & py -3 --version 2>&1
        if ($pythonVersion -match "Python 3") {
            $pythonCmd = "py -3"
        }
    } catch {}
}

if (-not $pythonCmd) {
    Write-Host "❌ Python 3 is required but not installed." -ForegroundColor Red
    Write-Host ""
    Write-Host "Please install Python 3:"
    Write-Host ""
    Write-Host "  1. Download from: https://www.python.org/downloads/"
    Write-Host "  2. Run the installer"
    Write-Host "  3. ✓ Check 'Add Python to PATH' during installation"
    Write-Host ""
    Write-Host "  Or use winget:"
    Write-Host "    winget install Python.Python.3.12"
    Write-Host ""
    exit 1
}

Write-Host "✓ Found $pythonVersion" -ForegroundColor Green

# Create install directory
$installDir = "$env:USERPROFILE\.local\bin"
if (-not (Test-Path $installDir)) {
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

Write-Host "Installing to: $installDir" -ForegroundColor Yellow

# Get source file
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceFile = Join-Path $scriptDir "git-worth.py"

if (-not (Test-Path $sourceFile)) {
    Write-Host "❌ Cannot find git-worth.py" -ForegroundColor Red
    Write-Host "   Make sure you're running this from the git-worth directory."
    exit 1
}

# Copy the Python script
$destPy = Join-Path $installDir "git-worth.py"
Copy-Item $sourceFile $destPy -Force

# Create a batch wrapper so it can be called as 'git-worth'
$destBat = Join-Path $installDir "git-worth.cmd"
$batContent = @"
@echo off
python "%~dp0git-worth.py" %*
"@
Set-Content -Path $destBat -Value $batContent

Write-Host "✓ Installed git-worth" -ForegroundColor Green

# Check if install dir is in PATH
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$installDir*") {
    Write-Host ""
    Write-Host "Adding $installDir to your PATH..." -ForegroundColor Yellow
    
    $newPath = "$installDir;$userPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    
    # Update current session
    $env:Path = "$installDir;$env:Path"
    
    Write-Host "✓ Added to PATH" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  You may need to restart your terminal for PATH changes to take effect." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "════════════════════════════════════════" -ForegroundColor Green
Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host "════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "Usage: Navigate to any git repository and run:"
Write-Host ""
Write-Host "  git-worth" -ForegroundColor Cyan
Write-Host ""
Write-Host "Happy building! 🚀"
Write-Host ""







