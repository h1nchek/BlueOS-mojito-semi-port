# Recovery ZIP preparation

**Status: not flashable yet.**

This directory documents the planned TWRP package for the Redmi Note 10
(\`mojito\` / \`sunny\`). It intentionally contains no flashing installer.

## Why there is no installable ZIP yet

The upstream BlueOS image is a generic Android 17 GSI, not a native
\`mojito\` build. The upstream guide does not provide a TWRP installation
procedure for this phone. Previous in-place GSI attempts on this device
returned to Fastboot, and the cause has not been established.

Wrapping the same image in a ZIP would not fix compatibility or boot issues.
A recovery installer must not guess partition names, slot handling, image
format, or required wipe steps.

## Offline preparation

On Windows, prepare and validate the downloaded upstream payload:

\`\`\`powershell
powershell -ExecutionPolicy Bypass -File .\\tools\\prepare_payload.ps1 -SourceGz "C:\\path\\to\\BlueOS-0.8.1-gsi_arm64_bvN4-20261107-2.img.gz"
\`\`\`

The script:
- accepts only the documented archive filename;
- decompresses the GZIP archive;
- checks that the resulting image is exactly 3,512,172,544 bytes;
- calculates SHA-256 hashes for local records;
- does not write to the phone.

The displayed hashes are not proof of authenticity unless compared with a
checksum published by the upstream project.

## Required checks before implementing flashing

1. Confirm the exact TWRP build and recovery environment.
2. Read the live partition and slot layout from recovery.
3. Determine whether the target logical partition can hold the image.
4. Verify the image format and the exact supported write method.
5. Define rollback and recovery steps that do not depend on guessing.
6. Review the final installer script before any write operation.

Until those checks are complete, do not add commands that flash \`system\`,
modify \`vbmeta\`, delete logical partitions, or format \`/data\`.

## Upstream

- BlueOS: https://github.com/GDmio/BlueOS
- Upstream GSI guide: https://github.com/GDmio/BlueOS/blob/main/GSI.md
