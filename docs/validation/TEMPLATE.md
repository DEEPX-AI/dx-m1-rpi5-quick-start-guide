# Validation Results — DX-All-Suite vX.Y.Z

- Guide branch / commit:
- Date:
- Tester:
- Protocol: [PROTOCOL.md](../PROTOCOL.md)

## Equipment

| Item | Record |
|---|---|
| Raspberry Pi 5 RAM | |
| M.2 HAT | |
| DX-M1 module | |
| Power supply | |
| Cooling | |
| Boot media | |
| OS image | |
| Kernel (`uname -r`) after install | |
| Network | |

## Artifacts

| Component | Version | File / source URL | sha256 |
|---|---|---|---|
| NPU Driver (`dxrt-driver-dkms`) | | | |
| DX-RT (`libdxrt-bin`) | | | |
| DX-FW (`fw.bin`, mdot2) | | | |
| DX-APP | | git tag | commit: |
| DX-Stream | | git tag | commit: |

## Scenarios

| ID | Result (pass / fail / skipped) | Duration | Notes / community post links |
|---|---|---|---|
| T1 Clean install | | | |
| T2 Reboot persistence | | | |
| T3 Kernel update | | | kernel before → after: |
| T4a Pinned `.deb` | | | |
| T4b apt repository | | | |
| T4c One-line install (pinned) | | | |
| T5 Gen2 vs Gen3 | | | FPS Gen2: / Gen3: |
| T6 Upgrade from previous | | | |
| T7 Headless | | | |
| T8 Stability 1 h | | | throttled: / NPU temp: |

## Checkpoints (T1)

| ID | Result | Recorded output / value |
|---|---|---|
| C1 arch | | |
| C2 lspci | | |
| C3 LnkSta | | |
| C4 dkms status | | |
| C5 dxcli -s | | |
| C6 firmware | | before: / after: |
| C7 dx_app install | | duration: / disk: |
| C8 dx_app demo | | demo: / FPS: / download: |
| C9 dx_stream | | build duration: |

## Guide deviations

Every place where a command had to be changed, added, or reordered to make it work.

| Guide section | What the guide says | What was needed |
|---|---|---|
| | | |

## Decisions

- Install method for the guide (T4):
- Headless path needed (T7):
- Known limitations to document:
