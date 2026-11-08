# Device-tree audit for a BlueOS Android 17 port

Date: 2026-11-08

## Decision

The supported upstream route is a **device build on LineageOS 24.0**, not another blind GSI flash. BlueOS upstream says it is layered on LineageOS 24.0 and that a conventional port requires a working LineageOS 24.0 device tree, kernel and proprietary vendor files.

## What exists for mojito

### Android 15 device tree

A public Android 15 device tree exists:

- Repository: https://github.com/ProjectEverest-Devices/android_device_xiaomi_mojito
- Branch: `15`
- Product makefile: `lineage_mojito.mk`
- Device: `mojito`
- OTA aliases: `mojito,sunny`
- SoC family: `sm6150`
- Kernel source path expected by the tree: `kernel/xiaomi/mojito`
- Shared tree expected: `device/xiaomi/sm6150-common`
- Proprietary files expected: `vendor/xiaomi/mojito`

The tree contains BoardConfig.mk, device.mk, AndroidProducts.mk, overlays, init configuration and a proprietary-files manifest. It is a useful Android 15 starting point, **not a ready Android 17 tree**.

### Kernel and vendor leads (not yet validated)

GitHub search also found:
- Kernel candidate: https://github.com/ximi-mojito/android_kernel_xiaomi_mojito, branch `17.0`.
- Vendor candidate: https://github.com/romgharti/vendor_xiaomi_mojito, branch `fourteen`.

These are leads only. The branch names do not prove that the kernel builds with LineageOS 24.0 or that the vendor blobs match the phone's installed firmware. Before adding them to a build manifest, inspect their commit history, defconfig, kernel version, blob source fingerprint and common-tree dependencies.

### Shared common tree

A LineageOS shared common tree exists on the Android 17 / LineageOS 24.0 branch:

- https://github.com/LineageOS/android_device_xiaomi_sm6150-common
- Branch: `lineage-24.0`

This does not by itself provide the mojito-specific device tree, kernel or vendor blobs.

## Missing pieces before a device build

1. A mojito device tree adapted to LineageOS 24.0.
2. A compatible sm6150-common tree and its required dependencies.
3. A kernel source and defconfig that build against the selected LineageOS 24.0 toolchain.
4. A matching, legally redistributable vendor tree or locally extracted proprietary files.
5. A successful plain LineageOS 24.0 build and boot before adding BlueOS.

## Why the Android 15 tree is not wired into a LineageOS 24.0 manifest yet

Mixing an Android 15 device tree with an Android 17 framework without a verified forward-port is not a reproducible build plan. The device tree must be reviewed and adapted first. Do not pin a branch simply because its codename matches.

## Current device evidence

The currently booted system reports:
- Android system API: 34
- `ro.vendor.build.version.sdk=34`
- `ro.vndk.version=34`
- Treble: enabled
- ABI: arm64-v8a
- Dynamic partitions: enabled

The vendor fingerprint still contains an Android 12 build string. This conflicts with the API 34 properties and remains unresolved. It is not enough to declare the firmware incompatible or compatible with Android 17.

## Sources

- BlueOS porting guide: https://github.com/GDmio/BlueOS/blob/main/PORTING.md
- BlueOS build guide: https://github.com/GDmio/BlueOS/blob/main/BUILDING.md
- Android 15 mojito tree: https://github.com/ProjectEverest-Devices/android_device_xiaomi_mojito/tree/15
- LineageOS 24.0 sm6150 common tree: https://github.com/LineageOS/android_device_xiaomi_sm6150-common/tree/lineage-24.0

## Next engineering task

Audit the Android 15 mojito tree against the LineageOS 24.0 sm6150 common tree. Port only the required makefiles, BoardConfig settings, overlays and init configuration; keep proprietary blobs out of this repository unless their license explicitly permits redistribution. Then establish a reproducible plain LineageOS build.
