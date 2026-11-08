param(
    [Parameter(Mandatory = $true)]
    [string]$SourceGz,
    [string]$OutputDir = ".\build\payload",
    [switch]$Force
)

$ErrorActionPreference = "Stop"
$ExpectedImageSize = 3512172544L
$ExpectedArchiveName = "BlueOS-0.8.1-gsi_arm64_bvN4-20261107-2.img.gz"

$source = (Resolve-Path -LiteralPath $SourceGz).Path
$archiveName = [System.IO.Path]::GetFileName($source)
if ($archiveName -ne $ExpectedArchiveName) {
    throw "Unexpected archive name: $archiveName. Expected: $ExpectedArchiveName"
}

$outDir = [System.IO.Path]::GetFullPath($OutputDir)
$imagePath = Join-Path $outDir "BlueOS.img"
if ((Test-Path -LiteralPath $imagePath) -and -not $Force) {
    throw "Output already exists: $imagePath. Use -Force to replace it."
}

New-Item -ItemType Directory -Force -Path $outDir | Out-Null
$tempPath = "$imagePath.tmp"
if (Test-Path -LiteralPath $tempPath) { Remove-Item -LiteralPath $tempPath -Force }

$inputStream = $null
$gzipStream = $null
$outputStream = $null
[long]$total = 0

try {
    $inputStream = [System.IO.File]::OpenRead($source)
    $gzipStream = [System.IO.Compression.GZipStream]::new($inputStream, [System.IO.Compression.CompressionMode]::Decompress)
    $outputStream = [System.IO.File]::Create($tempPath)
    $buffer = New-Object byte[] (1MB)

    while (($read = $gzipStream.Read($buffer, 0, $buffer.Length)) -gt 0) {
        $outputStream.Write($buffer, 0, $read)
        $total += $read
        $percent = [Math]::Min(100, ($total / $ExpectedImageSize) * 100)
        Write-Progress -Activity "Decompressing BlueOS image" -Status ("{0:N0} / {1:N0} bytes" -f $total, $ExpectedImageSize) -PercentComplete $percent
    }
    $outputStream.Flush()
}
catch {
    if (Test-Path -LiteralPath $tempPath) { Remove-Item -LiteralPath $tempPath -Force }
    throw
}
finally {
    if ($outputStream) { $outputStream.Dispose() }
    if ($gzipStream) { $gzipStream.Dispose() }
    if ($inputStream) { $inputStream.Dispose() }
    Write-Progress -Activity "Decompressing BlueOS image" -Completed
}

if ($total -ne $ExpectedImageSize) {
    Remove-Item -LiteralPath $tempPath -Force
    throw "Image size mismatch. Got $total bytes; expected $ExpectedImageSize bytes. Output discarded."
}

if (Test-Path -LiteralPath $imagePath) { Remove-Item -LiteralPath $imagePath -Force }
Move-Item -LiteralPath $tempPath -Destination $imagePath

$archiveHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
$imageHash = (Get-FileHash -LiteralPath $imagePath -Algorithm SHA256).Hash

Write-Host ""
Write-Host "Payload prepared successfully."
Write-Host "Image: $imagePath"
Write-Host "Image size: $((Get-Item -LiteralPath $imagePath).Length) bytes"
Write-Host "Archive SHA256: $archiveHash"
Write-Host "Image SHA256: $imageHash"
Write-Host "Hashes are for local records; authenticity requires an upstream-published checksum."
Write-Host "This script only decompresses and validates the file size. It does not flash or modify the phone."
