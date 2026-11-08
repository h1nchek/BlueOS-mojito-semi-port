# Roadmap

The target is a reproducible BlueOS device build for Redmi Note 10 (mojito),
based on LineageOS 24.0 / Android 17. Do not treat a GSI flash as a device port.

## Stage 1 — Source baseline
- [x] Review BlueOS upstream porting and building requirements.
- [x] Identify public Android 15 mojito device-tree candidate.
- [x] Identify LineageOS 24.0 sm6150 shared common tree.
- [x] Record initial device runtime properties.
- [ ] Identify exact kernel repository / branch and verify it builds for the target.
- [ ] Identify matching vendor source / extraction baseline and licensing.
- [ ] Resolve the mismatch between vendor fingerprint Android 12 string and API 34 properties.

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
- [ ] Build the device-specific BlueOS package.
- [ ] Record build environment, source revisions and checksums.

## Stage 5 — Validation and release
- [ ] Confirm setup wizard, repeated boots and basic stability.
- [ ] Test display, touch, Wi-Fi, mobile data, audio, camera, fingerprint,
      Bluetooth, GPS, sensors, calls and charging.
- [ ] Review SELinux denials and service crashes.
- [ ] Publish tested firmware baseline, known issues and recovery instructions.
