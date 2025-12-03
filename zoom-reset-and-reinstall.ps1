# Zoom reset + reinstall for Linux, macOS, and Windows
# Run with:  pwsh ./zoom-reset-and-reinstall.ps1

Write-Host "Detecting OS..." -ForegroundColor Cyan

if ($IsLinux) {
    Write-Host "Linux detected. Resetting Zoom..." -ForegroundColor Green

    # Kill Zoom if running
    try { pkill zoom 2>/dev/null } catch {}

    # Remove user config/cache
    sudo rm -rf ~/.zoom ~/.config/zoom ~/.cache/zoom

    # Remove zoom package if present
    sudo apt remove --purge zoom -y 2>/dev/null
    sudo apt autoremove --purge -y

    # Download latest .deb
    Write-Host "Downloading latest Zoom .deb..." -ForegroundColor Cyan
    mkdir -p ~/Downloads | Out-Null
    wget https://zoom.us/client/latest/zoom_amd64.deb -O ~/Downloads/zoom.deb

    # Install
    Write-Host "Installing Zoom..." -ForegroundColor Cyan
    sudo apt install ~/Downloads/zoom.deb -y

    Write-Host "Launching Zoom..." -ForegroundColor Cyan
    zoom

}
elseif ($IsMacOS) {
    Write-Host "macOS detected. Resetting Zoom..." -ForegroundColor Green

    # Kill Zoom
    try { pkill -x "zoom.us" 2>/dev/null } catch {}

    # Remove app bundle
    sudo rm -rf /Applications/zoom.us.app

    # Remove user data
    rm -rf ~/Library/"Application Support"/zoom.us
    rm -rf ~/Library/Logs/zoom.us
    rm -rf ~/Library/Caches/us.zoom.xos
    rm -rf ~/Library/Preferences/us.zoom.xos.plist

    # Download latest pkg
    Write-Host "Downloading latest Zoom.pkg..." -ForegroundColor Cyan
    mkdir -p ~/Downloads | Out-Null
    curl -L https://zoom.us/client/latest/Zoom.pkg -o ~/Downloads/Zoom.pkg

    # Install
    Write-Host "Installing Zoom..." -ForegroundColor Cyan
    sudo installer -pkg ~/Downloads/Zoom.pkg -target /

    Write-Host "Launching Zoom..." -ForegroundColor Cyan
    open /Applications/zoom.us.app

}
elseif ($IsWindows) {
    Write-Host "Windows detected. Resetting Zoom..." -ForegroundColor Green

    # Uninstall Zoom (MSI-based)
    try {
        Get-WmiObject -Class Win32_Product |
            Where-Object { $_.Name -like "*Zoom*" } |
            ForEach-Object {
                Write-Host "Uninstalling $($_.Name)..." -ForegroundColor Yellow
                $_.Uninstall() | Out-Null
            }
    } catch {}

    # Remove leftover folders
    $paths = @(
        "$env:APPDATA\Zoom",
        "$env:LOCALAPPDATA\Zoom",
        "$env:PROGRAMFILES\Zoom",
        "$env:PROGRAMFILES(X86)\Zoom"
    )

    foreach ($p in $paths) {
        if (Test-Path $p) {
            Write-Host "Removing $p" -ForegroundColor Yellow
            Remove-Item $p -Recurse -Force -ErrorAction SilentlyContinue
        }
    }

    # Download latest installer
    Write-Host "Downloading latest ZoomInstallerFull.exe..." -ForegroundColor Cyan
    $downloadPath = Join-Path $env:USERPROFILE "Downloads\ZoomInstaller.exe"
    Invoke-WebRequest "https://zoom.us/client/latest/ZoomInstallerFull.exe" `
        -OutFile $downloadPath

    # Install silently
    Write-Host "Installing Zoom..." -ForegroundColor Cyan
    Start-Process $downloadPath "/silent" -Wait

    # Try standard install path
    $zoomExe = "C:\Program Files\Zoom\bin\Zoom.exe"
    if (-not (Test-Path $zoomExe)) {
        $zoomExe = "C:\Program Files (x86)\Zoom\bin\Zoom.exe"
    }

    if (Test-Path $zoomExe) {
        Write-Host "Launching Zoom..." -ForegroundColor Cyan
        Start-Process $zoomExe
    } else {
        Write-Host "Zoom installed, but executable not found in default paths." -ForegroundColor Red
    }
}
else {
    Write-Host "Unsupported OS for this script." -ForegroundColor Red
}

