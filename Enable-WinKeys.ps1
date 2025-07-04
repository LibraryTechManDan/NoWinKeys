# Auto-elevate
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -WindowStyle Hidden -Verb RunAs
    exit
}

# Enable Windows key shortcuts
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
Remove-ItemProperty -Path $regPath -Name "NoWinKeys" -ErrorAction SilentlyContinue

# Log to terminal
Write-Output "[{0}] Enabled Windows key shortcuts (NoWinKeys removed)" -f (Get-Date)

# Restart Explorer
Stop-Process -Name explorer -Force
Start-Process explorer

# Auto-close after a moment
Start-Sleep -Seconds 1
exit
