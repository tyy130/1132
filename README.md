# Zoom Reset and Reinstall Script

A cross-platform PowerShell script that completely removes Zoom (including all user data and configurations) and reinstalls the latest version. Useful for troubleshooting Zoom issues or performing a clean reinstall.

## Features

- **Cross-platform support**: Works on Linux, macOS, and Windows
- **Complete cleanup**: Removes all Zoom application files, user data, cache, and configurations
- **Fresh install**: Automatically downloads and installs the latest version of Zoom
- **Auto-launch**: Launches Zoom after installation is complete

## Prerequisites

- **PowerShell 7+** (PowerShell Core) must be installed
  - Linux/macOS: Install via [Microsoft's instructions](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell)
  - Windows: PowerShell 7+ can be installed from the [Microsoft Store](https://apps.microsoft.com/store/detail/powershell/9MZ1SNWT0N5D) or [GitHub releases](https://github.com/PowerShell/PowerShell/releases)

### Additional Requirements by OS

- **Linux**: `sudo` access, `apt` package manager (Debian/Ubuntu-based systems), `wget`
- **macOS**: `sudo` access, `curl`
- **Windows**: Administrator privileges

## Usage

Run the script using PowerShell 7+:

```powershell
pwsh ./zoom-reset-and-reinstall.ps1
```

Or from within a PowerShell session:

```powershell
./zoom-reset-and-reinstall.ps1
```

> **Note**: On Linux and macOS, you may be prompted for your password due to `sudo` commands. On Windows, run PowerShell as Administrator for best results.

## What the Script Does

### Linux (Debian/Ubuntu-based)
1. Kills any running Zoom processes
2. Removes Zoom user configuration and cache directories (`~/.zoom`, `~/.config/zoom`, `~/.cache/zoom`)
3. Uninstalls Zoom via `apt`
4. Downloads the latest Zoom `.deb` package
5. Installs Zoom
6. Launches Zoom

### macOS
1. Kills any running Zoom processes
2. Removes the Zoom application from `/Applications`
3. Removes user data from Library folders (Application Support, Logs, Caches, Preferences)
4. Downloads the latest Zoom `.pkg` installer
5. Installs Zoom
6. Launches Zoom

### Windows
1. Uninstalls Zoom via WMI (MSI-based installations)
2. Removes leftover Zoom folders from AppData and Program Files
3. Downloads the latest Zoom installer
4. Installs Zoom silently
5. Launches Zoom

## Troubleshooting

- **Permission denied**: Ensure you have administrator/sudo privileges
- **Package manager not found (Linux)**: This script currently supports `apt`-based distributions. For other distributions, you may need to modify the script
- **Zoom not launching after install**: The script will report if it cannot find the Zoom executable. You may need to launch Zoom manually from your applications menu

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
