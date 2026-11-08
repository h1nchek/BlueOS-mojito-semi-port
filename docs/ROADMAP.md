# Roadmap

This is an evidence-first bring-up plan. A stage is not complete merely because
a command returned success.

## Stage 1 — Establish a baseline
- [ ] Confirm exact Redmi Note 10 model and variant.
- [ ] Record ROM, Android release, firmware and vendor versions.
- [ ] Capture relevant read-only properties and partition metadata.
- [ ] Confirm the exact upstream GSI release, checksum and image type.

## Stage 2 — Understand the image and interfaces
- [ ] Review upstream GSI build configuration and TrebleDroid base.
- [ ] Determine Android framework / vendor interface expectations.
- [ ] Compare device VINTF manifests and compatibility matrices.
- [ ] Inventory relevant overlays, init services and properties.
- [ ] Identify whether the issue is reproducible through a supported test
      method and collect useful logs.

## Stage 3 — Minimal adaptation
- [ ] Make only changes supported by collected evidence.
- [ ] Keep each change isolated and documented.
- [ ] Do not bundle proprietary files without clear provenance and redistribution
      permission.
- [ ] Do not add destructive flashing automation.

## Stage 4 — Validation
- [ ] Confirm Android reaches setup and remains stable across reboot.
- [ ] Test display, touch, Wi-Fi, mobile data, audio, camera, fingerprint,
      Bluetooth, GPS, sensors, calls and charging.
- [ ] Review SELinux denials and relevant service crashes.
- [ ] Document known issues and tested firmware baseline.

## Stage 5 — Release (only after validation)
- [ ] Publish reproducible build or adaptation instructions.
- [ ] Publish checksums and a clear tested-device statement.
- [ ] Include recovery instructions for the exact model.
- [ ] Preserve BlueOS license and attribution notices.
