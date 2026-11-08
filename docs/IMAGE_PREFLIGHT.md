# Image preflight (Windows)

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File .\\tools\\check_image_compatibility.ps1 -ImagePath "C:\\BlueOS\\BlueOS.img"
```

Optional checksum comparison:

```powershell
powershell -ExecutionPolicy Bypass -File .\\tools\\check_image_compatibility.ps1 -ImagePath "C:\\BlueOS\\BlueOS.img" -ExpectedSha256 "<SHA256_FROM_UPSTREAM>"
```

The default reference system size is 2,424,047,616 bytes, taken from the
previously recorded fastbootd output for this device. Override it only with a
freshly verified value:

```powershell
- SystemPartitionBytes 2424047616
```

This is a read-only local-file check. It records the image hash, compares the
file length with the documented GSI expanded size, checks the first four bytes
for Android sparse-image magic, and compares the image length to a supplied
reference partition size.

A passing size check does not establish boot compatibility. This script does
not connect to the phone, inspect its current partitions, verify the upstream
signature, or flash anything. Do not treat its result as permission to install.
