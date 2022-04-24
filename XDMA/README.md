# XDMA

XDMA contains the linux driver and tools to communicate DMA/Bridge Subsystem for PCI Express IP core on FPGA.

## Installation

1. Copy **XDMA** directory from the [Xilinx/dma_ip_drivers](https://github.com/Xilinx/dma_ip_drivers) github page

2. Follow the instruction in **linux-kernel/readme.txt**

3. May need to execute the following command

```console
pi@raspberrypi:~ $ sudo depmod -a
```

4. Create **/etc/modprobe.d/xdma.conf** with the following content

```console
pi@raspberrypi:~ $ cat /etc/modprobe.d/xdma.conf
options xdma interrupt_mode=3 enable_st_c2h_credit=1
```

This enables the MSI-X interrupt and the card-to-host stream credit feature. Make sure the file owner/group and permissions are correct.

5. Reboot

## Useful Commands

```console
pi@raspberrypi:~ $ sudo lspci -v
00:00.0 PCI bridge: Broadcom Inc. and subsidiaries BCM2711 PCIe Bridge (rev 20) (prog-if 00 [Normal decode])
        Device tree node: /sys/firmware/devicetree/base/scb/pcie@7d500000/pci@0,0
        Flags: bus master, fast devsel, latency 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 00000000-00000fff [size=4K]
        Memory behind bridge: [disabled]
        Prefetchable memory behind bridge: 00000000c0000000-00000000c00fffff [size=1M]
        Capabilities: [48] Power Management version 3
        Capabilities: [ac] Express Root Port (Slot-), MSI 00
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [180] Vendor Specific Information: ID=0000 Rev=0 Len=028 <?>
        Capabilities: [240] L1 PM Substates

01:00.0 Serial controller: Xilinx Corporation Device 7021 (prog-if 01 [16450])
        Subsystem: Xilinx Corporation Device 0007
        Device tree node: /sys/firmware/devicetree/base/scb/pcie@7d500000/pci@0,0/usb@0,0
        Flags: bus master, fast devsel, latency 0, IRQ 50
        Memory at 600000000 (64-bit, prefetchable) [size=64K]
        Capabilities: [40] Power Management version 3
        Capabilities: [60] Express Endpoint, MSI 00
        Capabilities: [9c] MSI-X: Enable+ Count=31 Masked-
        Capabilities: [100] Device Serial Number 00-00-00-00-00-00-00-00
        Kernel driver in use: xdma
        Kernel modules: xdma
```

```console
pi@raspberrypi:~ $ modinfo xdma
filename:       /lib/modules/5.10.103-v8+/extra/xdma.ko
license:        Dual BSD/GPL
version:        2020.2.2
description:    Xilinx XDMA Reference Driver
author:         Xilinx, Inc.
srcversion:     C49C31CE18C3897CFC3D332
depends:
name:           xdma
vermagic:       5.10.103-v8+ SMP preempt mod_unload modversions aarch64
parm:           h2c_timeout:H2C sgdma timeout in seconds, default is 10 sec. (uint)
parm:           c2h_timeout:C2H sgdma timeout in seconds, default is 10 sec. (uint)
parm:           poll_mode:Set 1 for hw polling, default is 0 (interrupts) (uint)
parm:           interrupt_mode:0 - Auto , 1 - MSI, 2 - Legacy, 3 - MSI-x (uint)
parm:           enable_st_c2h_credit:Set 1 to enable ST C2H engine credit feature, default is 0 ( credit control disabled) (uint)
parm:           desc_blen_max:per descriptor max. buffer length, default is (1 << 28) - 1 (uint)
```

