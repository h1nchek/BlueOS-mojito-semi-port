param(
    [string]$RemotePath = "/tmp/blueos-recovery-report.txt",
    [string]$OutputPath = ".\\blueos-recovery-report.txt"
)
$ErrorActionPreference = "Stop"
if (-not (Get-Command adb -ErrorAction SilentlyContinue)) { throw "adb was not found in PATH." }
& adb get-state | Out-Null
if ($LASTEXITCODE -ne 0) { throw "ADB recovery connection unavailable. Enable ADB in TWRP and reconnect USB." }
& adb pull $RemotePath $OutputPath
if ($LASTEXITCODE -ne 0) { throw "Report not found. Run the diagnostic ZIP in TWRP first." }
Write-Host "Report saved to: $((Resolve-Path -LiteralPath $OutputPath).Path)"
