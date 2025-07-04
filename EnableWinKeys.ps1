# Enable-WindowsKey.ps1
# Auto-elevate
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Registry path
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"

# Remove Scancode Map if it exists
if (Test-Path $regPath) {
    Remove-ItemProperty -Path $regPath -Name "Scancode Map" -ErrorAction SilentlyContinue
    Write-Output "[{0}] Scancode Map removed. Windows key should be re-enabled." -f (Get-Date)
} else {
    Write-Output "[{0}] Keyboard Layout key not found. No changes made." -f (Get-Date)
}

Restart-Computer -Force
