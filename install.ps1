# install.ps1 - SteamFast & Millennium Installer (Structured Version)
$ErrorActionPreference = "Stop"

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "   SteamFast v8.4 - Installation Script            " -ForegroundColor Cyan
Write-Host "   Created by Ecren Studio                         " -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan

# 1. Windows Script Execution Policy Check
$currentPolicy = Get-ExecutionPolicy
if ($currentPolicy -eq "Restricted") {
    Write-Host ""
    Write-Host "[!] Security Warning: Windows is blocking script execution." -ForegroundColor Yellow
    Write-Host "[!] Windows Execution Policy is currently set to 'Restricted'." -ForegroundColor Yellow
    Write-Host "--------------------------------------------------" -ForegroundColor Yellow
    Write-Host "To allow this installation, please open PowerShell as Administrator" -ForegroundColor White
    Write-Host "and run the following command to temporarily bypass the restriction:" -ForegroundColor White
    Write-Host ""
    Write-Host "   Set-ExecutionPolicy RemoteSigned -Scope Process" -ForegroundColor Green
    Write-Host ""
    Write-Host "After running the command, execute the SteamFast installation script again." -ForegroundColor White
    Write-Host "--------------------------------------------------" -ForegroundColor Yellow
    Write-Host "[-] Installation aborted due to policy restrictions." -ForegroundColor Red
    exit 1
}

# 2. Find Steam Path
$steamPath = (Get-ItemProperty -Path "HKCU:\Software\Valve\Steam" -ErrorAction SilentlyContinue).SteamPath
if (-not $steamPath) {
    $steamPath = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Wow6432Node\Valve\Steam" -ErrorAction SilentlyContinue).InstallPath
}

if (-not $steamPath) {
    Write-Host "[-] Error: Steam installation could not be found." -ForegroundColor Red
    exit 1
}

Write-Host "[+] Found Steam path: $steamPath" -ForegroundColor Green

$millenniumDll = "$steamPath\millennium.dll"
$pluginsDir = "$steamPath\plugins"

# 3. Check and Install Millennium
if (Test-Path $millenniumDll) {
    Write-Host "[*] Millennium is already installed. Skipping core download..." -ForegroundColor Yellow
} else {
    Write-Host "[+] Millennium not found. Fetching latest release from GitHub API..." -ForegroundColor Cyan
    
    $repoUrl = "https://api.github.com/repos/Millennium-Launcher/Millennium/releases/latest"
    try {
        $releaseInfo = Invoke-RestMethod -Uri $repoUrl -UseBasicParsing
        $downloadUrl = ($releaseInfo.assets | Where-Object { $_.name -like "*.zip" })[0].browser_download_url
    } catch {
        Write-Host "[-] Failed to fetch Millennium updates from GitHub." -ForegroundColor Red
        exit 1
    }

    Write-Host "[+] Downloading Millennium from: $downloadUrl" -ForegroundColor Cyan
    $tempZip = "$env:TEMP\millennium_latest.zip"
    Invoke-WebRequest -Uri $downloadUrl -OutFile $tempZip -UseBasicParsing

    Write-Host "[+] Extracting Millennium core files..." -ForegroundColor Cyan
    $tempExtracted = "$env:TEMP\millennium_extracted"
    if (Test-Path $tempExtracted) { Remove-Item -Recurse -Force $tempExtracted }
    Expand-Archive -Path $tempZip -DestinationPath $tempExtracted -Force

    Copy-Item -Path "$tempExtracted\*" -Destination $steamPath -Recurse -Force
    Write-Host "[+] Millennium installed successfully." -ForegroundColor Green
}

# 4. Create Plugins Directory if missing
if (-not (Test-Path $pluginsDir)) {
    New-Item -ItemType Directory -Path $pluginsDir | Out-Null
    Write-Host "[+] Created plugins directory at: $pluginsDir" -ForegroundColor Green
}

# 5. Download and Extract SteamFast (Only the 'src' folder)
$pluginTarget = "$pluginsDir\steamfast"

if (Test-Path $pluginTarget) {
    Write-Host "[*] SteamFast is already installed. Updating to version 8.4..." -ForegroundColor Yellow
    Remove-Item -Recurse -Force $pluginTarget
} else {
    Write-Host "[+] Installing SteamFast v8.4..." -ForegroundColor Cyan
}

$repoZipUrl = "https://github.com/ecrenstudio/steamfast/archive/refs/heads/main.zip"
$pluginZip = "$env:TEMP\steamfast_src.zip"

Write-Host "[+] Fetching SteamFast source from GitHub..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $repoZipUrl -OutFile $pluginZip -UseBasicParsing

$pluginExtracted = "$env:TEMP\steamfast_extracted"
if (Test-Path $pluginExtracted) { Remove-Item -Recurse -Force $pluginExtracted }
Expand-Archive -Path $pluginZip -DestinationPath $pluginExtracted -Force

# השינוי המרכזי: מעבירים רק את התוכן של תיקיית src מתוך ה-ZIP שחולץ לקבלת מבנה נקי בתוך סטים
$sourceFolder = "$pluginExtracted\steamfast-main\src"
Move-Item -Path $sourceFolder -Destination $pluginTarget -Force

Write-Host "==================================================" -ForegroundColor Green
Write-Host "[+] SUCCESS: SteamFast v8.4 & Millennium are set up!" -ForegroundColor Green
Write-Host "[*] Please restart Steam completely to apply changes." -ForegroundColor Yellow
Write-Host "==================================================" -ForegroundColor Green
