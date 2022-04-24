# Dual-imaging Raspberry Pi Compute Module 4

This repository contains the software code on the Raspberry Pi Compute Module 4 for dual-imaging display. Other development details, including PCB designs and FPGA development, are available [here](https://github.com/kotaniko/dual-imaging).

## OS info

```console
pi@raspberrypi:~ $ lsb_release -a
No LSB modules are available.
Distributor ID: Debian
Description:    Debian GNU/Linux 11 (bullseye)
Release:        11
Codename:       bullseye
```

```console
pi@raspberrypi:~ $ uname -a
Linux raspberrypi 5.10.103-v8+ #1530 SMP PREEMPT Tue Mar 8 13:06:35 GMT 2022 aarch64 GNU/Linux
```

## Scripts

* createRamdisk.sh
    - creates ramdisk at /tmp/ram

* demo_video.sh
    - script used in the demonstration video
