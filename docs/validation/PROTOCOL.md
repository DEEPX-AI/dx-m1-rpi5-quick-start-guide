# Validation Protocol

How to validate this guide on real hardware against a DX-All-Suite release. A guide release may say "validated" only after this protocol passes and the record is committed under `docs/validation/v<DX-All-Suite version>/`.

This directory is not part of the published documentation site.

## Principles

- **Clean OS every time.** Flash a fresh image for each run of T1. Do not reuse a card that already had a DEEPX package installed.
- **Follow the guide literally.** Copy every command from the branch under test. If you have to type anything that is not in the guide, that is a finding.
- **Record text, not screenshots.** Capture the whole session with `script` so every command and output is in one log.
- **Pin and hash every artifact.** Record the exact file name, source URL, and `sha256sum` of each `.deb` and `fw.bin` you install, especially for RC builds.

## Equipment record

Fill this in once per validation round (see `TEMPLATE.md`).

| Item | Record |
|---|---|
| Raspberry Pi 5 RAM | 4 / 8 / 16 GB |
| M.2 HAT | vendor and model |
| DX-M1 / DX-M1M module | marking on the module, `dxcli -s` output |
| Power supply | model and rating |
| Cooling | model |
| Boot media | microSD model and size |
| OS image | exact image file name from Raspberry Pi Imager, release date |
| Network | wired / Wi-Fi, approximate download speed |

## Session setup

On the freshly booted Raspberry Pi:

```bash
mkdir -p ~/validation && cd ~/validation
script -a ~/validation/session.log
```

Everything until `exit` is recorded in `session.log`. Prefix each guide command with `time` when measuring step duration.

Take a baseline environment report before installing anything:

```bash
curl -fsSL https://raw.githubusercontent.com/DEEPX-AI/dx-m1-rpi5-quick-start-guide/main/scripts/dx-env-report.sh | sudo bash
```

Run the same report again after T1 completes and after each scenario that changes the system.

## Test scenarios

Priority: **must** blocks the guide release; **should** is required unless time does not allow, in which case the gap is recorded as a known limitation; **nice** is optional.

| ID | Priority | Scenario | Pass criteria |
|---|---|---|---|
| T1 | must | **Clean install, as written.** Follow Getting Started top to bottom on Raspberry Pi OS (64-bit), Debian 13. | Every command succeeds as copied. Checkpoints C1–C9 below pass. |
| T2 | must | **Reboot persistence.** Reboot after T1. | `dxrt.service` is active, `dxcli -s` works, demo runs without reinstalling anything. |
| T3 | must | **Kernel update.** After T1, run `sudo apt update && sudo apt full-upgrade -y`, reboot. | If the kernel changed, `dkms status` shows `dxrt-driver-dkms` installed for the new `uname -r`, and `dxcli -s` works. Record kernel before and after. |
| T4 | must | **Install method decision.** Repeat the driver/runtime install with each method on a clean OS: (a) pinned `.deb` download, (b) DEEPX apt repository, (c) one-line install with `DX_RT_VERSION` / `DX_DRIVER_VERSION` / `DX_FW_VERSION` pinned. | For each method: success or failure, installed package versions (`dpkg-query`), time. Decide which method the guide uses. |
| T5 | should | **PCIe Gen2 vs Gen3.** Run the `dx_app` demo once with and once without `dtparam=pciex1_gen=3`. | `LnkSta` shows 5GT/s and 8GT/s respectively, no PCIe errors in `dmesg` at Gen3, demo FPS recorded for both. |
| T6 | should | **Upgrade from the previous guide.** On a clean OS, install by the previous guide release (DX-All-Suite v2.4.2), then upgrade by the new guide. | Upgrade completes without removing packages manually, or the required extra steps are recorded for an "Upgrading" section. |
| T7 | should | **Headless.** Run the demos from an SSH session without a desktop session. | Record what happens. Determines whether the guide needs a headless path. |
| T8 | nice | **Stability.** Run the `dx_app` demo in a loop for 1 hour at Gen3. | No crash. `vcgencmd get_throttled` is `0x0` at the end; record NPU temperature from `dxtop`. |

## Checkpoints for T1

| ID | After step | Check | Expected |
|---|---|---|---|
| C1 | OS install | `dpkg --print-architecture` | `arm64` |
| C2 | PCIe configuration + reboot | `lspci -d 1ff4:` | DX-M1 is listed. Record the exact line, it goes into the guide as expected output. |
| C3 | PCIe configuration + reboot | `sudo lspci -vv -d 1ff4: \| grep -i "LnkSta:"` | `Speed 8GT/s` with Gen3 enabled |
| C4 | Driver install | `dkms status` | `dxrt-driver-dkms/<ver>` installed for the running kernel |
| C5 | Runtime install | `dxcli -s` | Device found. Record full output as text. |
| C6 | Firmware check | `dxcli -s` | FW version is at least the minimum required by DX-RT (see `versions.yml`). If the module shipped with an older FW, run the update and record before/after. |
| C7 | `dx_app` install | `./install.sh --all` | Completes. Record duration and disk usage (`df -h /` before/after). |
| C8 | `dx_app` demo | `./run_demo.sh` | Demo runs. Record which demo was selected, FPS, and download size of the models fetched on first run. |
| C9 | `dx_stream` build + demo | `./build.sh`, `./run_demo.sh` | Build completes, demo runs. Record build duration. |

## Recording results

1. Copy `TEMPLATE.md` to `docs/validation/v<DX-All-Suite version>/RESULTS.md` and fill it in.
2. Put `session.log` and every `dx-env-report-*.txt` in the same directory. Remove Wi-Fi credentials or other secrets if they appear.
3. Report SDK bugs in the [DEEPX Developer Community](https://community.deepx.ai/c/support/5) and link the posts in `RESULTS.md`.
4. When every **must** scenario passes, update `versions.yml`:
   - `components.*` to the validated versions
   - `validation.status: validated`, `validation.date`, `validation.kernel`, `validation.hat`, `validation.log`
5. Update the docs to match `versions.yml` and run `python3 scripts/check_docs.py`.
