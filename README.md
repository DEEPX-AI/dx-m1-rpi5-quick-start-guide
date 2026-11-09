# DEEPX DX-M1 & DX-M1M Quick User Manual for Raspberry Pi 5

![Banner](docs/source/img/Main-Banner.png)

A quick-start guide for integrating the **DEEPX DX-M1** (& **DX-M1M**) AI accelerator with the **Raspberry Pi 5** via PCIe M.2. It walks through the hardware and camera setup, driver/runtime installation, and running your first NPU inference demo.

## DX-M1 at a Glance

| Item | Spec |
|---|---|
| AI Performance | 25 TOPS (INT8) |
| Host Interface | PCIe Gen3 x4 |
| Memory | 4GB LPDDR5 (5600 MT/s) |
| Power Consumption | 1W (min) ~ 5W (max) |
| Form Factor | M.2 2280 (M Key), 22 x 80 mm |
| OS Support | Windows 11/10, Debian-based Linux (Ubuntu, Raspberry Pi OS), Yocto Project |

## Guide

- **[Introduction](./docs/source/01_Introduction.md)** — what the DX-M1 is and what this manual covers
- **[System Overview](./docs/source/02_System_Overview.md)** — hardware specs and physically connecting the DX-M1 M.2 module and the Raspberry Pi Camera Module 3 (Wide) to the Raspberry Pi 5
- **[Getting Started](./docs/source/03_Getting_Started.md)** — verifying the camera, installing the driver/runtime, optional firmware update, running the sample apps (`dx_app`, `dx_stream`) with video and camera input, monitoring NPU usage via `dxtop`, and forcing PCIe Gen3
- **[Appendix. Troubleshooting](./docs/source/04_Appendix.md)** — fixes for common setup errors

Docs are built with MkDocs — see [`docs/make_docs.md`](./docs/make_docs.md) for install/build/preview commands.

## Release Notes

See [RELEASE_NOTES.md](./RELEASE_NOTES.md) for the version history of this manual.

## Support

- **Developer Portal**: [https://developer.deepx.ai](https://developer.deepx.ai)
- **Technical Support**: [tech_support@deepx.ai](mailto:tech_support@deepx.ai)

Copyright © DEEPX. All rights reserved.
