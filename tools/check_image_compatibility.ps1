param(
    [Parameter(Mandatory = $true)]
    [string]$ImagePath,

    [long]$SystemPartitionBytes = 2424047616,

    [string]$ExpectedSha256 = ""
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $ImagePath -PathType Leaf)) {
    throw "Image not found: $ImagePath"
}

$item = Get-Item -LiteralPath $ImagePath
$actualHash = (Get-FileHash -LiteralPath $ImagePath -Algorithm SHA256).Hash.ToLowerInvariant()

Write-Host "BlueOS image compatibility preflight"
Write-Host "===================================="
Write-Host ("Image: {0}" -f $item.FullName)
Write-Host ("Image size: {0:N0} bytes" -f $item.Length)
Write-Host ("SHA256: {0}" -f $actualHash)
Write-Host ""

if ($ExpectedSha256) {
    if ($actualHash -ne $ExpectedSha256.Trim().ToLowerInvariant()) {
        throw "SHA256 mismatch. Do not use this image."
    }
    Write-Host "PASS: SHA256 matches the supplied expected value."
} else {
    Write-Warning "No upstream checksum supplied; SHA256 is recorded but authenticity is NOT verified."
}

if ($item.Length -ne 3512172544) {
    Write-Warning "Image length differs from the documented BlueOS GSI expanded size (3,512,172,544 bytes)."
} else {
    Write-Host "PASS: image length matches the documented expanded size."
}

Write-Host ("Reference system partition size: {0:N0} bytes" -f $SystemPartitionBytes)
if ($item.Length -le $SystemPartitionBytes) {
    Write-Warning "Image is no larger than the supplied reference system size. This is only a size comparison, not proof that flashing is supported."
} else {
    Write-Warning "Image exceeds the supplied reference system size. It cannot fit in that reference size as-is."
}

$magic = [System.IO.File]::OpenRead($item.FullName)
try {
    $buffer = New-Object byte[] 4
    $read = $magic.Read($buffer, 0, 4)
} finally {
    $magic.Dispose()
}
$hex = if ($read -eq 4) { [BitConverter]::ToString($buffer) } else { "unavailable" }
Write-Host ("First four bytes: {0}" -f $hex)

if ($read -eq 4 -and $hex -eq "3A-FF-26-ED") {
    Write-Host "Image header resembles Android sparse image magic."
} elseif ($read -eq 4) {
    Write-Host "Image does not start with Android sparse image magic; it may be a raw filesystem image or another format."
}

Write-Host ""
Write-Warning "This tool does not validate Android boot compatibility, vendor interfaces, AVB/vbmeta, or recovery write support."
Write-Host "READ-ONLY PREFLIGHT COMPLETE. No device was accessed or modified."
