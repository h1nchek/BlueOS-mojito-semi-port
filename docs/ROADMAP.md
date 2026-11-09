# Roadmap

The target is a reproducible BlueOS device build for Redmi Note 10 (mojito),
based on LineageOS 24.0 / Android 17. The project is **not build-ready** until
plain LineageOS 24.0 can be configured, built and booted for this device.

## Stage 0 — Build readiness audit
- [x] Confirm this repository is a preparation repo, not an Android source checkout.
- [x] Read the current upstream BlueOS build requirements.
- [x] Identify that the available mojito device-tree candidate is Android 15, not a ready LineageOS 24.0 tree.
- [x] Record the device/common kernel checkout-path mismatch for resolution.
- [ ] Resolve kernel repository, branch and target path before writing a local manifest.

## Stage 1 — Source baseline
- [x] Review BlueOS upstream porting and building requirements.
- [x] Identify public Android 15 mojito device-tree candidate.
- [x] Identify LineageOS 24.0 sm6150 shared common tree.
- [x] Record initial device runtime baseline.
- [ ] Identify exact kernel repository / branch and verify its defconfig builds for mojito.
- [ ] Identify matching vendor source / extraction baseline and licensing.
- [ ] Resolve the mismatch between vendor fingerprint Android 12 string and API 34 properties.
- [ ] Create a pinned local manifest only after all project paths and revisions are verified.

## Stage 2 — Forward-port device tree
- [ ] Compare Android 15 mojito tree with LineageOS 24.0 common tree.
- [ ] Update product makefiles, BoardConfig, dependencies and namespaces.
- [ ] Port only required init, sepolicy, overlays and device-specific configuration.
- [ ] Keep proprietary blobs out of the public repository unless redistribution is permitted.
- [ ] Make the device tree pass product configuration / Soong checks.

## Stage 3 — Establish a plain LineageOS 24.0 build
- [ ] Set up a supported Linux build environment with sufficient SSD space and memory / swap.
- [ ] Sync LineageOS 24.0 and required device, common, kernel and vendor sources.
- [ ] Complete a reproducible build of plain LineageOS.
- [ ] Boot and validate the plain build before adding BlueOS.

## Stage 4 — Integrate BlueOS
- [ ] Add the upstream BlueOS manifest at a pinned revision.
- [ ] Apply BlueOS patches and resolve any patch conflicts.
- [ ] Confirm there are no `BlueOS: FAILED` patch messages from `source build/envsetup.sh`.
- [ ] Build the device-specific BlueOS package.
- [ ] Record build environment, source revisions and checksums.

## Stage 5 — Validation and release
- [ ] Confirm setup wizard, repeated boots and basic stability.
- [ ] Test display, touch, Wi-Fi, mobile data, audio, camera, fingerprint,
      Bluetooth, GPS, sensors, calls and charging.
- [ ] Review SELinux denials and service crashes.
- [ ] Publish tested firmware baseline, known issues and recovery instructions.

## Upstream build constraints

The upstream BlueOS build guide currently recommends Ubuntu 22.04/24.04 or
WSL2, 32 GB RAM (16 GB is described as slow), 32–48 GB swap, and about 350 GB
free SSD space. Most importantly, it says to build and boot plain LineageOS
24.0 first. These are upstream recommendations, not proof that this device is
supported.
