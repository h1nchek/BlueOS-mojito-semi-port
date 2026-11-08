# BlueOS semi-port for Redmi Note 10

**Status: device bring-up / Android 17 tree adaptation — not a bootable ROM yet.**

An experimental effort to adapt BlueOS (Android 17) for the Xiaomi Redmi Note 10
(**mojito**, product family **sunny**).

- Upstream project: [GDmio/BlueOS](https://github.com/GDmio/BlueOS)
- Target device: Xiaomi Redmi Note 10 (Snapdragon 678), codename `mojito`
- Product identifier reported by fastboot: `sunny`

This repository is not an official BlueOS port and does not contain a bootable
image. The previous generic-image experiments returned to Fastboot; their cause
has not been established. We are moving toward the upstream-supported
LineageOS 24.0 device-build route rather than repeating unverified flash steps.

## Engineering direction

BlueOS upstream is based on LineageOS 24.0. Its porting guide requires a working
device tree, kernel and proprietary vendor files for a conventional device port.

A public Android 15 mojito device tree is available:
[ProjectEverest-Devices/android_device_xiaomi_mojito](https://github.com/ProjectEverest-Devices/android_device_xiaomi_mojito/tree/15).
A LineageOS 24.0 shared sm6150 common tree also exists:
[LineageOS/android_device_xiaomi_sm6150-common](https://github.com/LineageOS/android_device_xiaomi_sm6150-common/tree/lineage-24.0).

The Android 15 device tree is a starting point only; it is not being treated as
compatible with Android 17 without a forward-port and build validation.

## Current status

- [x] Repository and upstream licensing / attribution review
- [x] Redmi Note 10 identity and initial runtime baseline recorded
- [x] Android 15 mojito device-tree candidate identified
- [x] LineageOS 24.0 sm6150 common tree identified
- [ ] Forward-port mojito-specific tree to LineageOS 24.0
- [ ] Verify kernel source, defconfig and build compatibility
- [ ] Verify vendor blob source and extraction baseline
- [ ] Build and boot plain LineageOS 24.0
- [ ] Integrate BlueOS and build the device package
- [ ] Validate hardware and publish only after successful testing

See [device notes](docs/DEVICE.md), [device-tree audit](docs/DEVICE_TREE_AUDIT.md),
[compatibility notes](docs/COMPATIBILITY.md) and [roadmap](docs/ROADMAP.md).

## Safety and testing

Do not repeat partition deletion or in-place flashing experiments without a
verified installation plan and recovery path. Keep known-good firmware for the
exact device variant and back up important data before any operation that can
erase userdata. Never relock the bootloader while running an unofficial system.

No destructive flash scripts are provided.

## Attribution and license

This project uses and investigates BlueOS by GDmio. See [LICENSE](LICENSE)
and [NOTICE](NOTICE); preserve the upstream attribution condition when
redistributing derivatives. BlueOS upstream: https://github.com/GDmio/BlueOS

This repository does not include proprietary Xiaomi firmware, vendor blobs,
Google applications, or Blue Archive assets.
