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
