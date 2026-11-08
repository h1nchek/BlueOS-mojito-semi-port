# Device notes — Redmi Note 10

## Identity

| Field | Value | Confidence |
|---|---|---|
| Commercial name | Xiaomi Redmi Note 10 | User-provided target |
| Device codename | `mojito` | Project target |
| Product identifier | `sunny` | Previously reported by fastboot |
| SoC | Qualcomm Snapdragon 678 | Device specification |
| Current target OS | BlueOS GSI, Android 17 | Experimental target |

Confirm the exact model/variant before using any device-specific files. Do not
assume that files for Redmi Note 10S, Redmi Note 10 5G, or another related model
are interchangeable.

## Known test history

A previous attempt to boot the upstream BlueOS GSI through fastboot did not
reach Android; the phone returned to fastboot after the Xiaomi splash screen.
This is an observation, **not a diagnosis**. There is not yet enough evidence
to attribute it to vendor mismatch, kernel, AVB, partition layout, or a GSI bug.

The GSI guide states that its fastboot installation method has not been tested
on a real phone and that the image was checked only on a Pixel 6a via DSU.

## Baseline information to collect

Record outputs from the currently booted, known-working ROM before proposing
device changes. Redact serial numbers and other personal identifiers.

Useful read-only commands:

```sh
adb shell getprop ro.product.device
adb shell getprop ro.product.vendor.device
adb shell getprop ro.product.name
adb shell getprop ro.build.version.release
adb shell getprop ro.build.version.sdk
adb shell getprop ro.treble.enabled
adb shell getprop ro.product.cpu.abi
adb shell getprop ro.boot.dynamic_partitions
adb shell getprop ro.boot.flash.locked
adb shell getprop ro.vndk.version
adb shell getprop ro.vendor.build.fingerprint
adb shell getprop ro.build.fingerprint
```

Also record:
- exact model number and region;
- current ROM, Android version and security patch;
- firmware/vendor base version;
- active slot and partition layout (read-only inspection);
- whether DSU is available;
- boot and service logs from a failed attempt, if safely recoverable.

Do not publish a full bugreport without reviewing it: it can contain personal
information such as network names, installed apps and account-related details.

## Compatibility questions

- Does the current vendor implementation expose the interfaces expected by the
  Android 17 GSI?
- Are required VINTF declarations and vendor services present?
- Are there device-specific overlays or properties needed for display, audio,
  camera, fingerprint, radio and power?
- Does the kernel support the required Android userspace features?
- Are SELinux policy and init service definitions compatible?

Each proposed change must cite the evidence that motivates it. Avoid copying
configuration from a different Xiaomi device merely because its codename looks
similar.


## Preliminary compatibility research (2026-11-08)

A public Redmi Note 10 device tree was inspected:
- https://github.com/VoltageOS-Devices/android_device_xiaomi_mojito
- https://github.com/VoltageOS-Devices/android_device_xiaomi_sm6150-common/blob/12/BoardConfigCommon.mk

The device tree identifies mojito and accepts mojito,sunny as OTA device assertions. Its board configuration enables A/B OTA and lists logical partitions including product, system, system_ext, vendor and odm. The shared configuration declares a dynamic-partition group and a super partition size of 9,126,805,504 bytes. This matches the super size previously reported by fastboot during this project's tests.

Important limitation: the inspected shared configuration is on branch 12 and is a build configuration, not a dump of the exact firmware currently installed on this phone. It does not prove the current slot layout, available free space, VNDK compatibility, or the exact reason the GSI boot attempt failed.

The same device tree's dependency manifest points to a separate shared sm6150-common tree, kernel and proprietary vendor repositories. Device support is not contained in the mojito device tree alone.

### Interpretation of previous fastboot attempts

The previous attempts used the in-place fastboot GSI method and both returned to Fastboot after the Xiaomi splash screen. Upstream explicitly marks that installation method as untested on a real phone. Therefore, the result is not enough to identify a specific cause.

Do not infer that deleting product is a required permanent device configuration. It was a space workaround in the upstream guide; partition changes must not be repeated without checking the exact active slot, logical partition metadata and recovery path.
