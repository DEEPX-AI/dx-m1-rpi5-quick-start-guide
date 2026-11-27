#!/usr/bin/env bash
#
# dx-env-report.sh — collect a DX-M1 / Raspberry Pi 5 environment report.
#
# Read-only: this script does not change any setting, package, or firmware.
# It prints a report to stdout and saves a copy to ./dx-env-report-<time>.txt
# so it can be attached to a support request or a validation log.
#
# Commands that need root (lspci -vv capabilities, dmesg) are run with
# "sudo -n", which never prompts. Run the script with sudo to include them.
# The PCIe link speed and width are also read from sysfs, which does not
# need root, so they are reported either way.

set -u

# sysfs PCI device directory (override only for testing).
PCI_SYSFS="${DX_PCI_SYSFS:-/sys/bus/pci/devices}"

OUT="dx-env-report-$(date +%Y%m%d-%H%M%S).txt"

section() {
    printf '\n===== %s =====\n' "$1"
}

# Run a command if it exists; never abort the report on failure.
run() {
    printf '$ %s\n' "$*"
    if command -v "$1" >/dev/null 2>&1; then
        "$@" 2>&1 || printf '(exit code %d)\n' "$?"
    else
        printf '(%s: command not found)\n' "$1"
    fi
}

# Run a command as root without prompting for a password.
run_root() {
    printf '$ sudo %s\n' "$*"
    if [ "$(id -u)" -eq 0 ]; then
        "$@" 2>&1 || printf '(exit code %d)\n' "$?"
    elif sudo -n true 2>/dev/null; then
        sudo -n "$@" 2>&1 || printf '(exit code %d)\n' "$?"
    else
        printf '(skipped: needs root, re-run this script with sudo)\n'
    fi
}

report() {
    section "Report"
    echo "date: $(date -Iseconds)"
    echo "script: dx-env-report.sh"

    section "Board"
    if [ -r /proc/device-tree/model ]; then
        tr -d '\0' < /proc/device-tree/model; echo
    else
        echo "(no /proc/device-tree/model)"
    fi
    run free -h
    run df -h /

    section "OS and kernel"
    if [ -r /etc/os-release ]; then
        grep -E '^(PRETTY_NAME|VERSION_CODENAME)=' /etc/os-release
    fi
    run uname -a
    run dpkg --print-architecture

    section "Power and temperature"
    # get_throttled: 0x0 means no under-voltage or throttling since boot.
    run vcgencmd get_throttled
    run vcgencmd measure_temp

    section "PCIe configuration (config.txt)"
    for f in /boot/firmware/config.txt /boot/config.txt; do
        if [ -r "$f" ]; then
            echo "# $f"
            grep -nE '^[[:space:]]*dtparam=pciex1' "$f" || echo "(no dtparam=pciex1 lines)"
        fi
    done

    section "PCIe devices"
    run lspci -nn

    section "DEEPX NPU (PCI vendor ID 1ff4)"
    run lspci -nn -d 1ff4:

    section "PCIe link status (sysfs, no root needed)"
    # Same information as LnkSta / LnkCap in "lspci -vv", which hides
    # the PCIe capabilities from non-root users.
    found=0
    for dev in "$PCI_SYSFS"/*; do
        [ -r "$dev/current_link_speed" ] || continue
        found=1
        addr="$(basename "$dev")"
        name="$(lspci -s "$addr" 2>/dev/null | cut -d' ' -f2-)"
        mark=""
        [ "$(cat "$dev/vendor" 2>/dev/null)" = "0x1ff4" ] && mark="  <-- DEEPX NPU"
        printf '%s %s%s\n' "$addr" "${name:-(unknown device)}" "$mark"
        printf '    current: %s, x%s\n' \
            "$(cat "$dev/current_link_speed" 2>/dev/null)" \
            "$(cat "$dev/current_link_width" 2>/dev/null)"
        printf '    max:     %s, x%s\n' \
            "$(cat "$dev/max_link_speed" 2>/dev/null)" \
            "$(cat "$dev/max_link_width" 2>/dev/null)"
    done
    [ "$found" -eq 1 ] || echo "(no PCIe link information in $PCI_SYSFS)"

    section "PCIe capabilities (lspci -vv, needs root)"
    run_root sh -c 'lspci -vv 2>/dev/null | grep -E "^[0-9a-f]|LnkCap:|LnkSta:"'

    section "DEEPX packages"
    if command -v dpkg-query >/dev/null 2>&1; then
        dpkg-query -W -f='${Package} ${Version} ${Status}\n' \
            'dxrt-driver-dkms' 'libdxrt*' 'sixfab-dx*' 2>/dev/null \
            | grep . || echo "(no DEEPX packages installed)"
    fi

    section "Driver"
    run dkms status
    printf '$ lsmod | grep -iE "dx|virt_dma"\n'
    lsmod 2>/dev/null | grep -iE 'dx|virt_dma' || echo "(no matching modules loaded)"
    run systemctl is-active dxrt.service

    section "Runtime"
    # dxcli replaced dxrt-cli in DX-RT 3.5.0; dxrt-cli remains as an alias.
    if command -v dxcli >/dev/null 2>&1; then
        run dxcli -s
    else
        run dxrt-cli -s
    fi

    section "Kernel log (PCIe and DEEPX)"
    run_root sh -c 'dmesg | grep -iE "pcie|dxrt|dx_dma|deepx" | tail -n 50'
}

report 2>&1 | tee "$OUT"
printf '\nSaved to %s\n' "$OUT" >&2
