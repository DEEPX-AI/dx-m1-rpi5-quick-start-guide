# DEEPX DX-M1 & DX-M1M Quick User Manual for Raspberry Pi 5

![Banner](docs/source/img/Main-Banner.png)

A quick-start guide for integrating the **DEEPX DX-M1** (& **DX-M1M**) AI accelerator with the **Raspberry Pi 5** via PCIe, using an M.2 module or the Sixfab AI HAT+. It walks through the hardware and camera setup, driver/runtime installation, and running your first NPU inference demo.

> **SDK versions** — this guide targets **DX-All-Suite v2.5.0**: DX-RT 3.5.0 · NPU Driver 2.7.0 · DX-FW 2.7.6 · DX-APP 3.3.0 · DX-Stream 3.2.0  
> **Platform** — Raspberry Pi 5 · Raspberry Pi OS (64-bit), Debian 13 "trixie"

## Before You Start

Choose one of the hardware options and prepare the parts listed in **[Before You Start](./docs/source/00_Before_You_Start.md)**.

| Option | Connection |
|---|---|
| DX-M1 M.2 module | M.2 2280 module on a PCIe M.2 HAT that supports 2280 — the official Raspberry Pi M.2 HAT+ (2230/2242 only) **does not fit** |
| DX-M1M M.2 module | M.2 2242 (M+B Key) module on a PCIe M.2 HAT that supports 2242, such as the official Raspberry Pi M.2 HAT+ (Standard) |
| Sixfab AI HAT+ | DX-M1M soldered on a HAT — for assembly, refer to the [Sixfab AI HAT+ Quickstart](https://docs.sixfab.com/docs/ai-hat-plus-raspberry-pi-5-quickstart) |

For all options, install the DEEPX SDK by following this guide. All options need a Raspberry Pi 5 with Raspberry Pi OS (**64-bit**), the Raspberry Pi 27W USB-C Power Supply (recommended), and active cooling. The camera demos need a Raspberry Pi Camera Module 3 with a Standard-to-Mini camera cable, or a USB webcam.

## DX-M1 on Raspberry Pi 5 at a Glance

| Item | On Raspberry Pi 5 |
|---|---|
| AI Performance | 25 TOPS (INT8) |
| PCIe Link | **x1** (single lane) — Gen2 (5 GT/s) by default, Gen3 (8 GT/s) optional |
| NPU Memory | 4GB LPDDR5 (5600 MT/s), on the module |
| Power | 1W (min) ~ 5W (max), supplied by the Raspberry Pi 5 through the M.2 HAT |
| Form Factor | M.2 2280 (M Key) — requires a 2280-compatible M.2 HAT |
| OS | Raspberry Pi OS (64-bit), Debian 13 "trixie" |
| Models | Pre-compiled `.dxnn` models; compile your own on an x86-64 Linux host with DX-COM |

The values above are for the DX-M1 M.2 module. The DX-M1M M.2 module is M.2 2242 (M+B Key), 22 x 42 x 4.9 mm, with integrated 2GB LPDDR4x memory.

## Guide

- **[Introduction](./docs/source/01_Introduction.md)** — what the DX-M1 is and what this manual covers
- **[Before You Start](./docs/source/00_Before_You_Start.md)** — hardware options, required parts, and camera options
- **[System Overview](./docs/source/02_System_Overview.md)** — hardware specs and physically connecting the DX-M1 M.2 module and the Raspberry Pi Camera Module 3 to the Raspberry Pi 5
- **[Getting Started](./docs/source/03_Getting_Started.md)** — verifying the camera, PCIe configuration, installing the driver/runtime, firmware check, running the sample apps (`dx_app`, `dx_stream`) with video and camera input, and monitoring NPU usage via `dxtop`
- **[Appendix. Troubleshooting](./docs/source/04_Appendix.md)** — fixes for common setup errors

Docs are built with MkDocs — see [`docs/make_docs.md`](./docs/make_docs.md) for install/build/preview commands.

## Release Notes

See [RELEASE_NOTES.md](./RELEASE_NOTES.md) for the version history of this manual.

## Support

Something not working? Run the environment report on the Raspberry Pi and attach its output when you ask for help:

```bash
curl -fsSL https://raw.githubusercontent.com/DEEPX-AI/dx-m1-rpi5-quick-start-guide/main/scripts/dx-env-report.sh | bash
```

- **Developer Portal**: [https://developer.deepx.ai](https://developer.deepx.ai)
- For technical questions, including problems with this guide, please ask in the DEEPX Developer Community: https://community.deepx.ai/c/support/5

See [SUPPORT.md](./SUPPORT.md) for details.

Copyright © DEEPX. All rights reserved.
