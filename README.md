# BlueOS semi-port for Redmi Note 10

**Status: not build-ready — device-tree forward-port and source integration are still missing.**

An experimental effort to adapt BlueOS (LineageOS 24.0 / Android 17) for the Xiaomi Redmi Note 10 (**mojito**, product family **sunny**).

- Upstream project: [GDmio/BlueOS](https://github.com/GDmio/BlueOS)
- Target device: Xiaomi Redmi Note 10 (Snapdragon 678), codename `mojito`
- Product identifier reported by fastboot: `sunny`

This repository is a research and preparation repository, **not an Android source checkout and not a compilable ROM tree**. It currently contains documentation, read-only diagnostics and preview-package scripts. It does not contain a LineageOS manifest checkout, a completed LineageOS 24.0 device tree, a validated kernel integration, or matching vendor files. No successful Android build has been performed.

## Build-readiness blockers

1. The public mojito device-tree candidate is on Android 15; it has not been forward-ported or validated against LineageOS 24.0 / Android 17.
2. The candidate's `BoardConfig.mk` selects `kernel/xiaomi/mojito`, while the inspected LineageOS 24.0 sm6150 common dependency manifest requests a kernel checkout at `kernel/xiaomi/sm6150`. These paths must be reconciled before creating a local manifest.
3. A matching kernel branch, defconfig and vendor blob baseline have not been proven to build together.
4. Plain LineageOS 24.0 for mojito has not yet been built and booted. Upstream BlueOS explicitly requires this baseline before adding BlueOS.
5. The current repository has no tested end-to-end build manifest or CI build.

See [build-readiness audit](docs/BUILD_READINESS_AUDIT.md) for evidence and the exact stop conditions.

## Engineering direction

The intended route is a conventional device build on LineageOS 24.0, then integration of upstream `vendor/blueos` using the hook documented by BlueOS. The Android 15 mojito tree is a starting point only; it is not treated as compatible with Android 17 without a forward-port and build validation.

## Current status

- [x] Repository and upstream licensing / attribution review
- [x] Redmi Note 10 identity and initial runtime baseline recorded
- [x] Android 15 mojito device-tree candidate identified
- [x] LineageOS 24.0 sm6150 common tree identified
- [x] Initial build-readiness audit and blocker list
- [ ] Reconcile device/common kernel source paths and dependency manifests
- [ ] Forward-port mojito-specific tree to LineageOS 24.0
- [ ] Verify kernel source, defconfig and build compatibility
- [ ] Verify vendor blob source and extraction baseline
- [ ] Build and boot plain LineageOS 24.0
- [ ] Integrate BlueOS at a pinned upstream revision
- [ ] Run BlueOS patch checks and build the device package
- [ ] Validate hardware and publish only after successful testing

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
