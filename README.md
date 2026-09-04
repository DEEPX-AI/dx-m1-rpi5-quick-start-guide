# DEEPX DX-M1 Quick User Manual for Raspberry Pi 5

A quick-start guide for integrating the **DEEPX DX-M1** AI accelerator with the **Raspberry Pi 5** via PCIe M.2. It walks through the hardware, driver/runtime installation, and running your first NPU inference demo.

## DX-M1 at a Glance

| Item | Spec |
|---|---|
| AI Performance | 25 TOPS (INT8) |
| Host Interface | PCIe Gen3 x4 |
| Memory | 4GB LPDDR5 |
| Form Factor | M.2 2280 (M Key), 22 x 80 x 4.72 mm |
| OS Support | Windows 10/11, Debian-based Linux, Docker, Yocto Linux |

## Guide

- **[Introduction](./docs/source/01_Introduction.md)** — what the DX-M1 is and what this manual covers
- **[System Overview](./docs/source/02_System_Overview.md)** — hardware specs and physically connecting the DX-M1 M.2 module to the Raspberry Pi 5
- **[Getting Started](./docs/source/03_Getting_Started.md)** — installing the driver/runtime, optional firmware update, running the sample apps (`dx_app`, `dx_stream`), monitoring NPU usage via `dxtop`, and forcing PCIe Gen3
- **[Appendix. Troubleshooting](./docs/source/04_Appendix.md)** — fixes for common setup errors

Docs are built with MkDocs — see [`docs/make_docs.md`](./docs/make_docs.md) for install/build/preview commands.

## Release Notes

See [RELEASE_NOTES.md](./RELEASE_NOTES.md) for the version history of this manual.

## Support

- **Developer Portal**: [https://developer.deepx.ai](https://developer.deepx.ai)
- **Technical Support**: [tech-support@deepx.ai](mailto:tech-support@deepx.ai)

Copyright © DEEPX. All rights reserved.
