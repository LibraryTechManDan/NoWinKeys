# Disable-WindowsKey.ps1
# Auto-elevate
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Registry path
$regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Keyboard Layout"
New-Item -Path $regPath -Force | Out-Null

# Scancode Map binary to disable Win keys
$scancodeMap = @(
    0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00,
    0x03, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x5B, 0xE0,
    0x00, 0x00, 0x5C, 0xE0,
    0x00, 0x00, 0x00, 0x00
)

Set-ItemProperty -Path $regPath -Name "Scancode Map" -Value ([byte[]]$scancodeMap)

Write-Output "[{0}] Windows keys disabled using Scancode Map." -f (Get-Date)

Restart-Computer -Force
