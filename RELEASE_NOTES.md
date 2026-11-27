
## Release Note

## v1.3.1 / 2026.11.27

Targets DX-All-Suite v2.5.0. No SDK version change.

### Changed

- Moved PCIe configuration before driver installation, added the PCIe Gen3 stability caution and Gen2 fallback, and corrected the description of Gen3 (link bandwidth, not NPU TOPS)
- Pinned all downloads and `git clone` commands to release tags (`dx_rt` v3.5.0, NPU driver v2.7.0, `dx_fw` v2.7.6, `dx_app` v3.3.0, `dx_stream` v3.2.0) instead of the `main` branch, and removed the unneeded `--recurse-submodules` option
- Firmware section: added download commands for the DX-M1 and DX-M1M M.2 modules (DX-FW 2.7.6) and the `dxcli -g` check before updating
- Removed `$` prompts from commands so they can be copied as-is
- Firmware check now compares the minimum version from `dxcli -v` with the current `FW version` from `dxcli -s`
- Notes and cautions use GitHub alert syntax (`> [!NOTE]`), which renders on GitHub and as admonitions on the site and in the PDF
- Cross-references link to the target page and name the section
- Replaced the outdated firmware error screenshot in Troubleshooting with the `dxcli -v` check
- Replaced the `dxcli -s` screenshot in Getting Started with the text output and a description of each field
- Spec tables describe the DX-M1 on the Raspberry Pi 5 (PCIe x1, Raspberry Pi OS) instead of the generic module specifications, and list the DX-M1M M.2 module form factor and memory
- Introduction and README describe both connection types (M.2 module and Sixfab AI HAT+)
- The DEEPX SDK is installed by following this guide for every hardware option; the Sixfab AI HAT+ documentation is linked for reference on assembly

### Added

- Before You Start page: hardware options (DX-M1 M.2, DX-M1M M.2, Sixfab AI HAT+), required parts, and camera options, with a warning that the official Raspberry Pi M.2 HAT+ does not fit the 2280 DX-M1 module
- Troubleshooting: symptom table, module not detected (Q2), driver not loaded after a kernel update (Q3), PCIe link stays at Gen2 (Q4), camera not detected or the libcamera GStreamer plugin missing (Q5), inference slows down or the system shuts down (Q6), `dx_stream` plugin not found after the first build (Q7)
- Note to run the graphical demos on the Raspberry Pi desktop or through VNC
- `source ~/.bashrc` step after building `dx_stream`, so the first `run_demo.sh` finds the plugin
- SDK version block in README and Getting Started
- `versions.yml` as the single source of SDK versions, and `scripts/check_docs.py` to keep the docs consistent with it
- `scripts/dx-env-report.sh` read-only environment report, and `SUPPORT.md`
- Docs CI (`.github/workflows/docs.yml`), `docs/mkdocs.sh`, `docs/requirements.txt`
- Hardware validation protocol and results template (`docs/validation/`)

### Fixed

- Docs build: missing `mkdocs.sh` and missing `include-markdown` plugin in the install instructions
- PDF cover version and file name are no longer hard-coded in `mkdocs.yml`
- `mkdocs build --strict` with PDF output failed because of code line anchors (`anchor_linenums`)
- PDF tables broke words in the middle (for example, "S / tep-by-Step"); cells now wrap at word boundaries

---

## v1.3.0 / 2026.11.06

### Changed

- Reformatted the Quick User Manual into Markdown style
- Update DX-M1 Driver and Runtime Installation guide for SDK 2.5.0 release
- Update `dx_app` installation to use a Python virtual environment
- Replace all screen captures

### Added

- Add Raspberry Pi Camera Module 3 connection and camera verification steps
- Add camera input demos for `dx_app` and `dx_stream`

---

## v1.2.0 / 2026.05.15

### Changed

- Update M1 Driver and Runtime Installation guide for SDK 2.3.0 release

---

## v1.1.0 / 2026.04.08

### Fixed

- Fix hyphen copying issues in source code and improved readability and the typo

### Added

- Add "Optional: Firmware Update" section (Getting Started) and Appendix for firmware update
- Add `./install.sh` in dx_app and dx_stream

---

## v1.0.0 / 2026.02.24

### Changed

- Full-Scale Revision

---
