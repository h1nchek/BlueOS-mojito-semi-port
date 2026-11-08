param(
    [string]$Output = ".\build\BlueOS-mojito-PREVIEW-NOT-FLASHABLE.zip"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression

$root = Split-Path -Parent $PSScriptRoot

# Source paths in the repository are deliberately mapped to conventional
# recovery ZIP paths. Keep the diagnostic package non-installing.
$files = @(
    @{ Source = "recovery\META-INF\com\google\android\update-binary"; Entry = "META-INF/com/google/android/update-binary" },
    @{ Source = "recovery\META-INF\com\google\android\updater-script"; Entry = "META-INF/com/google/android/updater-script" },
    @{ Source = "recovery\PACKAGE-STATUS.txt"; Entry = "PACKAGE-STATUS.txt" },
    @{ Source = "installer\README.md"; Entry = "README.txt" }
)

foreach ($file in $files) {
    $full = Join-Path $root $file.Source
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
        throw "Required package file is missing: $($file.Source)"
    }
}

$outputPath = [System.IO.Path]::GetFullPath($Output)
$outputDir = Split-Path -Parent $outputPath
if (-not (Test-Path -LiteralPath $outputDir)) {
    New-Item -ItemType Directory -Force -Path $outputDir | Out-Null
}

if (Test-Path -LiteralPath $outputPath) {
    Remove-Item -LiteralPath $outputPath -Force
}

$stream = [System.IO.File]::Open($outputPath, [System.IO.FileMode]::CreateNew)
try {
    $archive = [System.IO.Compression.ZipArchive]::new(
        $stream,
        [System.IO.Compression.ZipArchiveMode]::Create,
        $false
    )
    try {
        foreach ($file in $files) {
            $entry = $archive.CreateEntry(
                $file.Entry,
                [System.IO.Compression.CompressionLevel]::Optimal
            )

            if ($file.Entry -eq "META-INF/com/google/android/update-binary") {
                # Unix regular file with executable permissions (0755).
                $entry.ExternalAttributes = -2115174400
            }

            $entryStream = $entry.Open()
            try {
                $bytes = [System.IO.File]::ReadAllBytes((Join-Path $root $file.Source))
                $entryStream.Write($bytes, 0, $bytes.Length)
            }
            finally {
                $entryStream.Dispose()
            }
        }
    }
    finally {
        $archive.Dispose()
    }
}
finally {
    $stream.Dispose()
}

Write-Host "Created diagnostic ZIP: $outputPath"
Write-Host "ZIP entries use recovery-root paths (META-INF/ and README.txt)."
Write-Host "This package runs read-only recovery diagnostics only; it does not install BlueOS."
