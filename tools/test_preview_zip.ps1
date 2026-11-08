param(
    [string]$ZipPath = ".\build\BlueOS-mojito-PREVIEW-NOT-FLASHABLE.zip"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$resolved = (Resolve-Path -LiteralPath $ZipPath).Path
$archive = [System.IO.Compression.ZipFile]::OpenRead($resolved)

try {
    $required = @(
        "META-INF/com/google/android/update-binary",
        "META-INF/com/google/android/updater-script",
        "PACKAGE-STATUS.txt",
        "installer/README.md"
    )

    $names = @($archive.Entries | ForEach-Object { $_.FullName })
    foreach ($name in $required) {
        if ($names -notcontains $name) {
            throw "Missing required ZIP entry: $name"
        }
    }

    $forbiddenPayloads = @($names | Where-Object {
        $_ -match '(^|/)(system|system_a|system_b|payload)\.(img|bin)$' -or
        $_ -match '\.(img|img\.gz|zip)$'
    })
    if ($forbiddenPayloads.Count -gt 0) {
        throw "Unexpected payload-like file(s) in preview ZIP: $($forbiddenPayloads -join ', ')"
    }

    $entry = $archive.GetEntry("META-INF/com/google/android/update-binary")
    $reader = [System.IO.StreamReader]::new($entry.Open())
    try { $binaryText = $reader.ReadToEnd() }
    finally { $reader.Dispose() }

    if ($binaryText -notmatch '(?m)^exit\s+1\s*$') {
        throw "Recovery entrypoint does not contain the expected abort exit."
    }
    if ($binaryText -match '(?i)\b(flash|dd|mkfs|wipe|format|delete_partition|fastboot)\b') {
        throw "Unexpected device-operation keyword found in preview entrypoint."
    }

    $statusEntry = $archive.GetEntry("PACKAGE-STATUS.txt")
    $statusReader = [System.IO.StreamReader]::new($statusEntry.Open())
    try { $statusText = $statusReader.ReadToEnd() }
    finally { $statusReader.Dispose() }

    if ($statusText -notmatch 'PREVIEW ONLY - NOT FLASHABLE') {
        throw "Package status marker is missing."
    }

    Write-Host "PASS: required ZIP entries are present."
    Write-Host "PASS: no image or nested ZIP payload is included."
    Write-Host "PASS: recovery entrypoint is abort-only."
    Write-Host "PASS: package is clearly marked as not flashable."
}
finally {
    $archive.Dispose()
}
