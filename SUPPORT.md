# Support

## Where to ask

All technical questions, including problems with this guide (a command that fails as written, a broken link, a missing step) and problems with the DEEPX SDK, are handled in the **DEEPX Developer Community**:

**[DEEPX Developer Community — Support](https://community.deepx.ai/c/support/5)**

Please do not open GitHub issues in this repository.

For product information and SDK documentation, see the [DEEPX Developer Portal](https://developer.deepx.ai).

## What to include

Run the environment report on the Raspberry Pi and attach the saved file to your post. It is read-only and does not change your system.

```bash
curl -fsSL https://raw.githubusercontent.com/DEEPX-AI/dx-m1-rpi5-quick-start-guide/main/scripts/dx-env-report.sh | bash
```

Run it with `sudo` to also include the PCIe link status and the kernel log.

Please also include:

- The guide version or commit you followed, and the section
- The exact command you ran
- What you expected and what happened instead (full error output as text, not a screenshot)
- Your M.2 HAT model and power supply
