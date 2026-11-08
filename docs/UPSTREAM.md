# Upstream project notes

Source: [GDmio/BlueOS](https://github.com/GDmio/BlueOS)

Reviewed upstream files:
- [README.md](https://github.com/GDmio/BlueOS/blob/main/README.md)
- [GSI.md](https://github.com/GDmio/BlueOS/blob/main/GSI.md)
- [PORTING.md](https://github.com/GDmio/BlueOS/blob/main/PORTING.md)
- [BUILDING.md](https://github.com/GDmio/BlueOS/blob/main/BUILDING.md)
- [LICENSE](https://github.com/GDmio/BlueOS/blob/main/LICENSE)
- [NOTICE](https://github.com/GDmio/BlueOS/blob/main/NOTICE)

## Relevant upstream facts

- BlueOS is described upstream as based on LineageOS 24.0 / Android 17.
- The experimental GSI uses TrebleDroid.
- The upstream GSI guide says it was checked on a Pixel 6a via DSU; its
  fastboot installation method is explicitly untested on a real phone.
- The guide warns that Xiaomi and MediaTek devices may have hardware issues.
- The GSI keeps the target phone's kernel, recovery and boot logo; hardware
  support remains dependent on the device firmware and vendor implementation.
- Upstream porting guidance says a conventional device port normally starts
  from a working LineageOS 24.0 device tree, kernel and proprietary files.
  This repository instead investigates whether a narrower GSI adaptation is
  feasible.

## Licensing requirement

BlueOS has an Apache License 2.0 base with an additional attribution condition.
When distributing work based on BlueOS, the upstream license requires keeping
the upstream NOTICE and clearly crediting BlueOS by GDmio with a link to the
original project. See the copied [LICENSE](../LICENSE) and [NOTICE](../NOTICE).

Do not assume that this license covers third-party components, proprietary
device files, fonts or other assets. Check each component's own terms.


## GSI prerequisites and test coverage

The current upstream GSI guide requires:
- ro.treble.enabled=true;
- ro.product.cpu.abi=arm64-v8a;
- ro.boot.dynamic_partitions=true;
- firmware based on Android 13 or newer;
- an unlocked bootloader.

The guide reports testing only on a Pixel 6a through DSU. It explicitly says that the in-place fastboot installation method has not been tested on a real phone. It also warns that Xiaomi devices can have hardware compatibility problems.

For the Redmi Note 10 project, these upstream checks must be compared with properties collected from the currently working ROM. Do not assume that the requirements are satisfied solely because a previous custom ROM booted.
