# Auto-elevate
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -WindowStyle Hidden -Verb RunAs
    exit
}

# Disable Windows key shortcuts
$regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
New-Item -Path $regPath -Force | Out-Null
Set-ItemProperty -Path $regPath -Name "NoWinKeys" -Value 1 -Type DWord

# Log to terminal
Write-Output "[{0}] Disabled Windows key shortcuts (NoWinKeys = 1)" -f (Get-Date)

# Restart Explorer
Stop-Process -Name explorer -Force
Start-Process explorer

# Auto-close after a moment
Start-Sleep -Seconds 1
exit
