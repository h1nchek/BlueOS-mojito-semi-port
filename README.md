# BlueOS semi-port for Redmi Note 10

**Status: research / bring-up — not a usable ROM yet.**

An experimental effort to investigate adapting the BlueOS Android 17 GSI to the
Xiaomi Redmi Note 10 (**mojito**, product family **sunny**).

- Upstream project: [GDmio/BlueOS](https://github.com/GDmio/BlueOS)
- Upstream GSI guide: [GSI.md](https://github.com/GDmio/BlueOS/blob/main/GSI.md)
- Target device: Xiaomi Redmi Note 10 (Snapdragon 678), codename `mojito`
- Product identifier reported by fastboot: `sunny`

This repository is **not** an official BlueOS port, does not contain a bootable
image, and does not claim that the upstream GSI is compatible with this device.

## What “semi-port” means here

The starting point is the existing generic system image. The work is to identify
which device-specific configuration, overlays, properties, init rules and
vendor-interface adjustments (if any) are actually needed for this phone.

A GSI replaces the Android system image; it does not replace the device's kernel,
vendor implementation, modem firmware or other hardware-specific components.
A successful flash is not proof that the system will boot or that hardware works.

## Current status

- [x] Repository and research structure created
- [x] Upstream GSI documentation and attribution requirements reviewed
- [ ] Record exact stock / current ROM baseline and firmware version
- [ ] Collect device properties and partition / Treble information
- [ ] Inspect upstream GSI build details and compatibility
- [ ] Identify required device-side changes from logs and evidence
- [ ] Validate boot and hardware functions before any release

See [device notes](docs/DEVICE.md), [roadmap](docs/ROADMAP.md) and
[upstream notes](docs/UPSTREAM.md).

## Safety and testing

Do not flash experimental images on a primary phone. Keep a known-good stock
firmware package and a recovery route for the exact device variant. Back up
important data before any operation that can erase partitions or userdata.
Never relock the bootloader while running an unofficial system.

No flash scripts are provided at this stage. Any future installation guide must
be based on verified device-specific information, not assumptions.

## Attribution and license

This project uses and investigates BlueOS by GDmio. See [LICENSE](LICENSE)
and [NOTICE](NOTICE); the upstream attribution condition must be preserved.
BlueOS upstream: https://github.com/GDmio/BlueOS

This repository does not include proprietary Xiaomi firmware, vendor blobs,
Google applications, or Blue Archive assets.
