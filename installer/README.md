# Recovery ZIP preparation

**Current package status: diagnostic only — not a ROM installer.**

This project is investigating a BlueOS Android 17 GSI on the Redmi Note 10
(`mojito` / `sunny`). The repository does not yet contain a supported
installation procedure.

## Why there is no installable ZIP

The upstream BlueOS image is a generic GSI, not a native `mojito` build.
The upstream guide does not provide a TWRP installation procedure for this
phone. Previous in-place GSI attempts returned to Fastboot, and the cause
has not been established.

Wrapping the same image in a ZIP cannot fix compatibility or boot issues.
An installer must not guess partition names, slot handling, image format,
or required wipe steps.

## Offline image preparation

On Windows, prepare the downloaded upstream payload:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\prepare_payload.ps1 -SourceGz "C:\path\to\BlueOS-0.8.1-gsi_arm64_bvN4-20261107-2.img.gz"
```

The script decompresses the archive, checks the documented expanded size,
and calculates local hashes. A locally calculated hash does not prove
authenticity unless it is compared with a checksum published upstream.

Run the local image preflight:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\check_image_compatibility.ps1 -ImagePath "C:\path\to\BlueOS.img"
```

This checks local file metadata only. It does not establish boot
compatibility or permission to install.

## Diagnostic recovery ZIP

Build the read-only diagnostic package from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\build_preview_zip.ps1
powershell -ExecutionPolicy Bypass -File .\tools\test_preview_zip.ps1
```

Output:
`build/BlueOS-mojito-PREVIEW-NOT-FLASHABLE.zip`

The archive uses conventional recovery-root paths:
- `META-INF/com/google/android/update-binary`
- `META-INF/com/google/android/updater-script`
- `PACKAGE-STATUS.txt`
- `README.txt`

The entrypoint gathers recovery properties, block-device links, mapper
entries, and available inspection tools. It writes its report to
`/tmp/blueos-recovery-report.txt`. It does not install BlueOS or modify
partitions.

After running the diagnostic package in TWRP, retrieve the report over ADB:

```powershell
powershell -ExecutionPolicy Bypass -File .\tools\pull_recovery_report.ps1
```

The ZIP test checks archive layout and selected safety markers. It does not
emulate TWRP, prove that the recovery can run the script, or establish
device compatibility.

## Requirements before any installer work

1. Confirm the exact recovery build and environment.
2. Obtain the live partition and slot layout from recovery.
3. Determine actual logical partition sizes and available free space.
4. Verify the image format and supported write method.
5. Establish a tested rollback and recovery path.
6. Review the complete installer and its effects before any write operation.

Until those checks are complete, do not add commands that write `system`,
modify `vbmeta`, delete logical partitions, or format `/data`.

## Upstream

- BlueOS: https://github.com/GDmio/BlueOS
- Upstream GSI guide: https://github.com/GDmio/BlueOS/blob/main/GSI.md
