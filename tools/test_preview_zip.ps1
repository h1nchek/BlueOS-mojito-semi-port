param(
    [string]$ZipPath = ".\build\BlueOS-mojito-PREVIEW-NOT-FLASHABLE.zip"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression

$resolved = (Resolve-Path -LiteralPath $ZipPath).Path
$archive = [System.IO.Compression.ZipFile]::OpenRead($resolved)

try {
    $required = @(
        "META-INF/com/google/android/update-binary",
        "META-INF/com/google/android/updater-script",
        "PACKAGE-STATUS.txt",
        "README.txt"
    )

    $names = @($archive.Entries | ForEach-Object { $_.FullName })
    foreach ($name in $required) {
        if ($names -notcontains $name) {
            throw "Missing required ZIP entry: $name"
        }
    }

    if ($names -match '^recovery/' -or $names -contains "installer/README.md") {
        throw "Repository source paths leaked into the ZIP; entries must be mapped to recovery-root paths."
    }

    $forbiddenPayloads = @($names | Where-Object {
        $_ -match '(^|/)(system|system_a|system_b|payload)\.(img|bin)$' -or
        $_ -match '\.(img|img\.gz|zip)$'
    })
    if ($forbiddenPayloads.Count -gt 0) {
        throw "Unexpected payload-like file(s) in preview ZIP: $($forbiddenPayloads -join ', ')"
    }

    $entry = $archive.GetEntry("META-INF/com/google/android/update-binary")
    $unixMode = ([uint32]$entry.ExternalAttributes) -shr 16
    if (($unixMode -band 0xF000) -ne 0x8000 -or ($unixMode -band 0x1FF) -ne 0x1ED) {
        throw ("update-binary does not have Unix regular-file mode 0755 (mode: 0x{0:X4})." -f $unixMode)
    }

    $reader = [System.IO.StreamReader]::new($entry.Open())
    try { $binaryText = $reader.ReadToEnd() }
    finally { $reader.Dispose() }

    if ($binaryText -notmatch 'READ-ONLY RECOVERY DIAGNOSTIC') {
        throw "Recovery entrypoint is not marked as a read-only diagnostic."
    }
    if ($binaryText -match '(?i)\b(flash|dd|mkfs|wipe|format|delete_partition|fastboot)\b') {
        throw "Unexpected device-operation keyword found in preview entrypoint."
    }

    $statusEntry = $archive.GetEntry("PACKAGE-STATUS.txt")
    $statusReader = [System.IO.StreamReader]::new($statusEntry.Open())
    try { $statusText = $statusReader.ReadToEnd() }
    finally { $statusReader.Dispose() }

    if ($statusText -notmatch 'DIAGNOSTIC ONLY - NOT A ROM INSTALLER') {
        throw "Package status marker is missing."
    }

    $readmeEntry = $archive.GetEntry("README.txt")
    $readmeReader = [System.IO.StreamReader]::new($readmeEntry.Open())
    try { $readmeText = $readmeReader.ReadToEnd() }
    finally { $readmeReader.Dispose() }

    if ($readmeText -notmatch 'diagnostic only' -or $readmeText -notmatch 'not a ROM installer') {
        throw "README.txt does not clearly identify the package as diagnostic-only."
    }

    Write-Host "PASS: required recovery-root ZIP entries are present."
    Write-Host "PASS: no repository-only path prefixes or image payloads are included."
    Write-Host "PASS: update-binary has Unix mode 0755."
    Write-Host "PASS: recovery entrypoint and package status are diagnostic-only."
}
finally {
    $archive.Dispose()
}
