param(
    [string]$Output = ".\build\BlueOS-mojito-PREVIEW-NOT-FLASHABLE.zip"
)

$ErrorActionPreference = "Stop"
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$root = Split-Path -Parent $PSScriptRoot
$files = @(
    "recovery\META-INF\com\google\android\update-binary",
    "recovery\META-INF\com\google\android\updater-script",
    "recovery\PACKAGE-STATUS.txt",
    "installer\README.md"
)

foreach ($relative in $files) {
    $full = Join-Path $root $relative
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) {
        throw "Required package file is missing: $relative"
    }
}

$outputPath = [System.IO.Path]::GetFullPath($Output)
$outputDir = Split-Path -Parent $outputPath
New-Item -ItemType Directory -Force -Path $outputDir | Out-Null

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
        foreach ($relative in $files) {
            $entryName = $relative.Replace("\", "/")
            $entry = $archive.CreateEntry($entryName, [System.IO.Compression.CompressionLevel]::Optimal)
            if ($entryName.EndsWith("/update-binary")) {
                # Unix regular file with executable permissions (0755).
                $entry.ExternalAttributes = -2115174400
            }
            $entryStream = $entry.Open()
            try {
                $bytes = [System.IO.File]::ReadAllBytes((Join-Path $root $relative))
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

Write-Host "Created preview ZIP: $outputPath"
Write-Host "This package runs read-only recovery diagnostics only; it does not install BlueOS."
