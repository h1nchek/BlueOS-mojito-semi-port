# TWRP installer investigation

Status: planning / read-only recovery inspection. No flashing code is enabled.

## Target

- Device family: Xiaomi Redmi Note 10
- Device codenames: `mojito` / `sunny`
- Recovery reported by the maintainer: TWRP
- Source image: upstream BlueOS Android 17 GSI

## Why the installer is not implemented yet

The upstream BlueOS GSI guide documents DSU and a fastbootd installation path. It does not provide a TWRP installer. A recovery ZIP is not just a wrapper around `system.img`: it must correctly identify the active slot, resolve the dynamic logical system partition, verify the image format and size, and handle the recovery environment's block-device mapping.

The Redmi Note 10 has A/B and dynamic-partition characteristics in published device-tree configuration. That does not establish the exact mapper paths exposed by the installed TWRP build. The earlier GSI attempts returned to Fastboot, and their cause is unknown.

For that reason this repository does not yet contain a script that writes to `system`, changes vbmeta, deletes partitions, or formats userdata.

## Read-only information to collect in TWRP

Boot into TWRP, connect USB, then run these commands from the computer:

```sh
adb devices
adb shell getprop ro.twrp.version
adb shell getprop ro.product.device
adb shell getprop ro.boot.slot_suffix
adb shell getprop ro.build.ab_update
adb shell ls -l /dev/block/mapper
adb shell ls -l /dev/block/by-name
adb shell mount
adb shell df -h /tmp /sdcard
```

These commands only inspect recovery properties, block-device names, mounts and available space. Do not run any `dd`, `wipe`, `format`, `delete-logical-partition` or `flash` commands as part of this inspection.

If `adb devices` reports `sideload` rather than `recovery`, exit sideload mode in TWRP and use its normal ADB connection.

Before sharing output, redact serial numbers and any personal paths.

## Installer acceptance checks

A future ZIP must stop without writing anything unless all checks pass:

1. Device identity is exactly an allowed Redmi Note 10 identity (`mojito` or `sunny`).
2. Recovery exposes the expected A/B slot and dynamic-partition mapping.
3. The embedded image checksum matches the release manifest.
4. The image format and expanded size are known and fit the target logical partition.
5. The install method is validated for this exact recovery environment.
6. The installer has a clear abort path before the first write.

Passing these checks would validate installer preconditions only. It would not prove that Android 17 BlueOS is compatible with this phone or will boot.

## Upstream references

- BlueOS GSI guide: https://github.com/GDmio/BlueOS/blob/main/GSI.md
- Project device notes: [DEVICE.md](DEVICE.md)
- Compatibility assessment: [COMPATIBILITY.md](COMPATIBILITY.md)
