# Preliminary compatibility assessment

Date: 2026-11-08

Status: research only; no compatibility claim.

## Upstream GSI requirements

According to https://github.com/GDmio/BlueOS/blob/main/GSI.md, the experimental Android 17 GSI expects:
- Treble enabled;
- ARM64 userspace (arm64-v8a);
- dynamic partitions;
- firmware based on Android 13 or newer;
- unlocked bootloader.

The upstream author reports testing the GSI only on a Pixel 6a via DSU. The guide explicitly labels the in-place fastboot installation method as untested on a real phone.

## Redmi Note 10 device-tree evidence

Sources inspected:
- https://github.com/VoltageOS-Devices/android_device_xiaomi_mojito
- https://github.com/VoltageOS-Devices/android_device_xiaomi_sm6150-common/blob/12/BoardConfigCommon.mk
- https://github.com/VoltageOS-Devices/android_device_xiaomi_mojito/blob/main/voltage.dependencies

Observed in the published build configuration:
- device tree is for Redmi Note 10 (mojito), with OTA assert aliases mojito,sunny;
- A/B OTA is enabled;
- dynamic partition group is configured;
- logical partition list includes odm, product, system, system_ext and vendor;
- configured super size is 9,126,805,504 bytes, matching the size previously reported by this project's fastboot inspection;
- the build depends on separate shared sm6150-common, kernel and vendor trees.

These are source-tree facts, not proof of the exact layout or vendor state on the user's current installation. The inspected common configuration is from branch 12; it must not be treated as a definitive description of a newer installed ROM.

## What is not known yet

- Current ROM's vendor fingerprint and firmware base.
- Actual values of the upstream GSI prerequisite properties.
- VNDK cross-version compatibility.
- Whether DSU is available in the current ROM.
- The reason the previous fastboot boots returned to the bootloader.
- Whether any device-specific overlay, init, VINTF or SELinux adjustment is needed.

## Next evidence to collect

From the currently booted, known-working ROM, collect the read-only baseline commands in DEVICE.md. The most important missing compatibility check is VNDK cross-version support. Android's official GSI documentation describes checking the vendor namespace configuration in ld.config.*.txt: https://developer.android.com/topic/generic-system-image

Do not publish a full bugreport without reviewing it for personal information. Do not repeat partition deletion or flashing experiments to collect this data.
