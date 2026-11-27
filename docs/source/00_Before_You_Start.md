This chapter helps you choose the hardware and prepare all parts before you assemble and power on the Raspberry Pi 5.  

## Choose Your Hardware

A DEEPX NPU can be connected to the Raspberry Pi 5 in several ways. Choose the option that matches your hardware, then follow the assembly and installation guide listed for it.  

Table. Hardware Options  

| Option | NPU | Connection to the Raspberry Pi 5 | Assembly | Runtime installation |
|---|---|---|---|---|
| DX-M1 M.2 module | DX-M1 | M.2 2280 (M Key) module on a PCIe M.2 HAT that supports the 2280 form factor | [System Overview](02_System_Overview.md) > **Step-by-Step Connection Guide** | [Getting Started](03_Getting_Started.md) |
| DX-M1M M.2 module | DX-M1M | M.2 2242 (M+B Key) module on a PCIe M.2 HAT that supports the 2242 form factor, such as the official Raspberry Pi M.2 HAT+ (Standard) | [System Overview](02_System_Overview.md) > **Step-by-Step Connection Guide** | [Getting Started](03_Getting_Started.md) |
| Sixfab AI HAT+ | DX-M1M, soldered on the board | HAT stacked on the 40-pin header, PCIe through the included ribbon cable | Refer to the [Sixfab AI HAT+ Quickstart](https://docs.sixfab.com/docs/ai-hat-plus-raspberry-pi-5-quickstart) | [Getting Started](03_Getting_Started.md) |

> [!NOTE]
> Install the DEEPX SDK by following [Getting Started](03_Getting_Started.md) for every hardware option, including the Sixfab AI HAT+. The commands in this guide are pinned to DX-All-Suite v2.5.0. The Sixfab documentation is linked for reference on assembling the board.

> [!WARNING]
> The DX-M1 M.2 module is **22 x 80 mm (2280)**. The official Raspberry Pi M.2 HAT+ supports only the 2230 and 2242 form factors and **cannot hold the DX-M1 M.2 module**. The DX-M1M M.2 module is **22 x 42 mm (2242)**. Check that your M.2 HAT supports the length of your module before purchasing.

## Required Parts

Table. Required Parts  

| Item | Requirement |
|---|---|
| Host | Raspberry Pi 5 |
| M.2 adapter | For an M.2 module only: PCIe M.2 HAT for Raspberry Pi 5 with an **M Key** slot that supports the module's length |
| Power supply | Raspberry Pi 27W USB-C Power Supply (USB-C PD, recommended) |
| Cooling | Active cooling for the Raspberry Pi 5 (e.g. Raspberry Pi Active Cooler) |
| Storage | microSD card or other boot media |
| OS | Raspberry Pi OS (64-bit), Debian 13 "trixie". A 32-bit OS is not supported. |
| Network | Internet connection for downloading packages, sample models, and videos |

## Camera Options

A camera is required only for the camera input demos. The video demos run without a camera.  

Table. Camera Options  

| Camera | Connection | Used by |
|---|---|---|
| Raspberry Pi Camera Module 3 (any variant) | CAM/DISP 0 or CAM/DISP 1 connector, with a **Standard-to-Mini camera cable** | `dx_app` and `dx_stream` camera demos |
| USB webcam | USB port | `dx_app` camera demo |

> [!NOTE]
> The Raspberry Pi 5 uses mini 22-pin camera connectors, while the cable included with the Camera Module 3 is a standard 15-pin cable. Order a **Standard-to-Mini camera cable** together with the camera.

## Checklist

Confirm the following before you assemble the hardware.  

- [ ] Hardware option chosen, and the matching assembly guide at hand
- [ ] For an M.2 module: an M.2 HAT that supports the module's length
- [ ] Raspberry Pi 27W USB-C Power Supply and active cooling
- [ ] Raspberry Pi OS (64-bit) written to the boot media
- [ ] For the camera demos: Camera Module 3 with a Standard-to-Mini camera cable, or a USB webcam
- [ ] Internet connection

---
