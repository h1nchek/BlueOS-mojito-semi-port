# Build-readiness audit

Date: 2026-11-09

## Verdict

**NOT BUILD-READY**

There is no basis to promise a successful first Android build yet. The GitHub
repository `h1nchek/BlueOS-mojito-semi-port` is a preparation repository, not a
synced Android source tree. It contains project notes and helper scripts, but
not the source checkout and complete, validated device integration needed to
compile a ROM.

The correct milestone is not "run brunch now". It is to make plain LineageOS
24.0 configure, build and boot for mojito first, then add BlueOS.

## Confirmed findings

### 1. No Android build tree in this repository

The inspected repository files include documentation, PowerShell helpers and a
read-only recovery diagnostic package. There is no checked-in LineageOS source
tree, no completed device tree under `device/xiaomi/mojito`, no kernel checkout,
no vendor checkout, and no local repo manifest describing a tested combination.

The helper `build_preview_zip.ps1` only creates a diagnostic ZIP. It does not
compile Android or produce a ROM.

### 2. BlueOS upstream build order

The upstream `BUILDING.md` says BlueOS is LineageOS 24.0 plus
`vendor/blueos`. It explicitly instructs builders to:
1. Sync LineageOS 24.0.
2. Set up the device using its build instructions and obtain the matching blobs.
3. Build and boot plain LineageOS first.
4. Add the `vendor/blueos` local manifest and the
   `vendor/extra/product.mk` inherit line.
5. Run `source build/envsetup.sh`, inspect every BlueOS patch result, then
   build with `breakfast <device>` and `m bacon`.

Upstream also recommends Ubuntu 22.04/24.04 or WSL2, 32 GB RAM (16 GB is
described as slow), 32–48 GB swap, and approximately 350 GB free SSD space.

Source: https://github.com/GDmio/BlueOS/blob/main/BUILDING.md

### 3. The current device tree is only an Android 15 starting point

The inspected ProjectEverest mojito tree has:
- `AndroidProducts.mk` pointing to `lineage_mojito.mk`;
- product identity `mojito` / Redmi Note 10;
- OTA assert aliases `mojito,sunny`;
- `TARGET_KERNEL_CONFIG := vendor/mojito_defconfig`;
- `TARGET_KERNEL_SOURCE := kernel/xiaomi/mojito`;
- an include of `device/xiaomi/sm6150-common/BoardConfigCommon.mk`;
- an include of `vendor/xiaomi/mojito/BoardConfigVendor.mk`.

This is useful evidence about the older tree, but it is not proof that the
makefiles, kernel or proprietary blobs work on LineageOS 24.0.

Sources:
- https://github.com/ProjectEverest-Devices/android_device_xiaomi_mojito
- https://github.com/ProjectEverest-Devices/android_device_xiaomi_sm6150-common

### 4. Kernel checkout path needs reconciliation

The inspected LineageOS 24.0 sm6150 common dependency manifest requests
`android_kernel_xiaomi_sm6150` at `kernel/xiaomi/sm6150`. The mojito
device-tree candidate's BoardConfig instead selects
`kernel/xiaomi/mojito`.

This is a concrete integration question, not yet a proven compile error: the
selected device tree, common tree and kernel must agree on which kernel project
is checked out and which path the build system uses. Do not create a local
manifest by blindly combining these two paths. Inspect both trees' kernel
references and select one coherent arrangement first.

### 5. Vendor files are not validated

The device BoardConfig includes
`vendor/xiaomi/mojito/BoardConfigVendor.mk`, and the product makefile expects
the device vendor makefile. A public vendor repository or branch name alone
does not prove that its blobs match the installed firmware or the Android 17
vendor interface. Record the source fingerprint, extraction method, blob
checksums and licensing before pinning it.

### 6. BlueOS integration is not present here

The BlueOS hook belongs in the Android source checkout at
`vendor/extra/product.mk`, not in this preparation repository. The upstream
manifest project is `GDmio/BlueOS` at path `vendor/blueos`. The upstream
instructions should be followed after the plain LineageOS baseline works.

Do not copy the upstream `manifests/blueos-pinned.xml` blindly: the version
retrieved during this audit contains `<extend-project name="">` entries with
empty project names. Treat that file as requiring upstream verification; do
not use it as a local manifest until those entries are corrected upstream or
replaced with verified project names.

## Actual errors / inconsistencies found in this repository

- `recovery/META-INF/com/google/android/updater-script` said the paired
  `update-binary` intentionally aborts. The current update-binary instead
  runs read-only diagnostics and exits successfully. The comment has been
  corrected.
- The preflight scripts inspect a GSI payload and preview ZIP only. They do
  not validate the Android device tree, kernel, vendor blobs, Soong modules,
  BlueOS patch application or a ROM build.
- The default system partition size in `check_image_compatibility.ps1` is a
  historical reference value. It must not be interpreted as a current,
  measured partition size or as a build compatibility result.

## Required gates before claiming build-ready

1. Select exact LineageOS 24.0 device and common tree revisions.
2. Resolve kernel project, branch, checkout path and defconfig.
3. Resolve matching vendor source / extraction baseline.
4. Forward-port the Android 15 mojito tree and run product configuration.
5. Sync all sources from a pinned manifest.
6. Build and boot plain LineageOS 24.0.
7. Add BlueOS using the upstream documented hook.
8. Confirm there are no failed BlueOS patches, then build BlueOS.
9. Save full source revision manifest, build log and artifact checksums.

Until gates 1–6 pass, the project must remain labelled not build-ready.
