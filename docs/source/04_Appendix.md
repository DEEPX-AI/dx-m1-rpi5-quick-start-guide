Find your symptom in the table below, then follow the matching section.  

Table. Troubleshooting by Symptom  

| Symptom | First check | Section |
|---|---|---|
| `[dxrt-exception]` error about the firmware version | `dxcli -v` and `dxcli -s` | Q1 |
| DX-M1 not listed by `lspci -d 1ff4:`, or `dxcli -s` finds no device | `dtparam=pciex1` in `config.txt` | Q2 |
| `dxcli -s` fails after a system update | `dkms status` | Q3 |
| `LnkSta` of the DX-M1 shows `Speed 5GT/s` with Gen3 enabled | `dtparam=pciex1_gen=3` in `config.txt` | Q4 |
| `rpicam-hello --list-cameras` lists no camera, or a camera demo fails with `needs the libcamera GStreamer plugin` | Camera cable, `gstreamer1.0-libcamera` | Q5 |
| Inference slows down over time, or the system shuts down during inference | Power supply, `vcgencmd get_throttled` | Q6 |
| `dx_stream` `run_demo.sh` stops with `dxstream plugin still not found` | `source ~/.bashrc` | Q7 |

---

## Q1. Firmware Version Error Message 

**Issue Description**  

When executing the AI demo application, the program terminates with a red `[dxrt-exception]` error message that asks you to update the firmware. This occurs when the current device firmware version is lower than the minimum version required by the installed runtime library (`libdxrt`).  

**Cause**  

- **Version Conflict:** The installed firmware is lower than the minimum firmware version required by DX-RT.  

**Solution**  

- Compare the minimum firmware version printed by `dxcli -v` with the `FW version` line printed by `dxcli -s`.  

```bash
dxcli -v
dxcli -s
```

- If the `FW version` is lower than the minimum, update the firmware. Refer to [Getting Started](03_Getting_Started.md) > **Firmware Check and Update**.  

---

## Q2. DX-M1 Module Is Not Detected

**Issue Description**  

The DX-M1 does not appear in the `lspci -d 1ff4:` output, or `dxcli -s` reports that no device is found.  

**Cause**  

- **PCIe Disabled:** The external PCIe connector is not enabled in `config.txt`.  
- **Unstable Gen3 Link:** The link fails to train at PCIe Gen3 speed.  
- **Connection:** The HAT ribbon cable or the M.2 module is not seated correctly.  

**Solution**  

- Confirm that `dtparam=pciex1` is present in `/boot/firmware/config.txt`, then reboot. Refer to [Getting Started](03_Getting_Started.md) > **PCIe Configuration**.  
- Remove the `dtparam=pciex1_gen=3` line to fall back to PCIe Gen2, then reboot.  
- Power off, disconnect the power supply, and reseat the HAT cable and the M.2 module.  
- Check the kernel log for PCIe errors.  

```bash
sudo dmesg | grep -i pcie
```

---

## Q3. Driver Is Not Loaded After a Kernel Update

**Issue Description**  

The DX-M1 was working, but after a system update (for example, `sudo apt full-upgrade`) and a reboot, `dxcli -s` fails.  

**Cause**  

- **DKMS Rebuild Failure:** The NPU driver is built by DKMS for each kernel. If the build for the new kernel failed or did not run, the driver module is missing for the running kernel.  

**Solution**  

- Check whether the driver module is built for the running kernel. The output of `dkms status` should list `dxrt-driver-dkms` as `installed` for the version shown by `uname -r`.  

```bash
uname -r
dkms status
lsmod | grep -i dx
```

- If the module is not installed for the running kernel, reinstall the driver package that you downloaded in [Getting Started](03_Getting_Started.md) > **Install DEEPX DX-M1 Driver and Runtime** to rebuild the driver, then reboot.  

```bash
ls ~/Downloads/dxrt-driver-dkms_*_all.deb
sudo apt install --reinstall -y ~/Downloads/dxrt-driver-dkms_*_all.deb
sudo reboot
```

> [!NOTE]
> The `ls` command must list exactly one driver package. If it lists more than one version, delete the older files from `~/Downloads`. If it lists none, download the driver package again by following [Getting Started](03_Getting_Started.md) > **Install DEEPX DX-M1 Driver and Runtime**.  

---

## Q4. PCIe Link Stays at Gen2

**Issue Description**  

`dtparam=pciex1_gen=3` is set, but `sudo lspci -vv -d 1ff4: | grep -i "LnkSta:"` shows `Speed 5GT/s` instead of `Speed 8GT/s`.  

**Cause**  

- **Setting Not Applied:** The line is placed under a conditional section of `config.txt` (for example, `[cm4]` or `[cm5]`), so it does not apply to the Raspberry Pi 5, or the system was not rebooted.  
- **Link Training at Gen3 Failed:** The HAT or ribbon cable cannot hold a stable Gen3 link, and the link falls back to Gen2.  

**Solution**  

- Make sure `dtparam=pciex1_gen=3` is under the `[all]` section of `/boot/firmware/config.txt`, then reboot. Refer to [Getting Started](03_Getting_Started.md) > **PCIe Configuration**.  
- Reseat the HAT ribbon cable and check again.  
- If the link still stays at Gen2, keep using Gen2. The DX-M1 works normally at Gen2; only the host-to-NPU transfer bandwidth is lower.  

---

## Q5. Camera Is Not Detected or Cannot Be Opened

**Issue Description**  

- `rpicam-hello --list-cameras` reports that no cameras are available, or the camera demos cannot open the camera.  
- A `dx_app` camera demo with the Raspberry Pi Camera Module 3 (for example, `-c 0`) stops with the following error:  

```text
[DXAPP] [ERROR] Raspberry Pi camera (index 0) needs the libcamera GStreamer plugin, which is not installed.
[DXAPP] [ERROR] Failed to open input source.
```

**Cause**  

- **Cable:** The cable is not a Standard-to-Mini camera cable, is inserted at an angle, or the connector latch is not closed.  
- **Cable Orientation:** The cable is inserted upside down at the Raspberry Pi 5 or the camera end. The camera is not detected when the cable is reversed.  
- **Hot Plugging:** The camera was connected while the Raspberry Pi 5 was powered on.  
- **Missing libcamera GStreamer Plugin:** `dx_app` reads the Raspberry Pi Camera Module 3 through the libcamera GStreamer plugin (`gstreamer1.0-libcamera`). The plugin is not installed by default, for example when only `dx_app` is installed without `dx_stream`.  

**Solution**  

- Power off and disconnect the power supply, then reconnect the camera with a Standard-to-Mini camera cable. Check the cable orientation at both ends against the figure in [System Overview](02_System_Overview.md) > **Step 3. Connecting the Raspberry Pi Camera Module 3**.  
- Power on and run the check again.  

```bash
rpicam-hello --list-cameras
```

- If `rpicam-hello` lists the camera but the `dx_app` demo shows the libcamera GStreamer plugin error, install the plugin, then run the demo again.  

```bash
sudo apt install -y gstreamer1.0-libcamera
```

---

## Q6. Inference Slows Down or the System Shuts Down

**Issue Description**  

- The demo runs normally at first, but the frame rate drops after running for a while.  
- The Raspberry Pi 5 shuts down or reboots suddenly while running inference.  

**Cause**  

- **Thermal Throttling:** The Raspberry Pi 5 or the NPU is overheating.  
- **Under-voltage:** The power supply cannot provide enough power. When the NPU and the Raspberry Pi 5 are both under load, an insufficient power supply can cause the system to shut down during inference.  

**Solution**  

- Use the Raspberry Pi 27W USB-C Power Supply. Phone chargers and USB-C power supplies with a lower rating may not provide enough current.  
- Check the throttling status and the SoC temperature. A `get_throttled` value other than `throttled=0x0` means that under-voltage or throttling has occurred since boot.  

```bash
vcgencmd get_throttled
vcgencmd measure_temp
```

- Check the NPU temperature with `dxtop`.  
- Use active cooling for the Raspberry Pi 5 and keep airflow around the M.2 module.  

---

## Q7. dx_stream Plugin Is Not Found

**Issue Description**  

Right after installing and building `dx_stream`, `./run_demo.sh` stops with the following messages:  

```text
[WARNING] dxstream plugin not found. Trying to reload environment variables...
[ERROR] dxstream plugin still not found.
[ERROR] Please build DX-STREAM first:
```

**Cause**  

- **Environment Variables Not Loaded:** `./build.sh` adds the environment variables for the `dx_stream` GStreamer plugin (`GST_PLUGIN_PATH`, `LD_LIBRARY_PATH`, `PKG_CONFIG_PATH`, and `PATH`) to the end of `~/.bashrc`, between the `# DeepX Stream GStreamer Plugin` and `# DeepX Stream GStreamer Plugin - END` lines. The terminal in which you ran the build was opened before this change, so the variables are not set in it.  

**Solution**  

- Load `~/.bashrc` in the current terminal, then run the demo again. Opening a new terminal or rebooting has the same effect.  

```bash
source ~/.bashrc
cd ~/sample/dx_stream
./run_demo.sh
```

- If the error still appears in a new terminal, check that `~/.bashrc` contains the `dx_stream` block and that `GST_PLUGIN_PATH` is set.  

```bash
grep -A 6 "DeepX Stream GStreamer Plugin" ~/.bashrc
echo $GST_PLUGIN_PATH
```

- If the block is missing, the build did not complete. Run `./build.sh` again in `~/sample/dx_stream` and check its output for errors.  

---
