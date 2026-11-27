#!/usr/bin/env python3
"""Lint the guide's Markdown against versions.yml.

Checks:
  1. Every SDK version string in the docs matches versions.yml.
  2. Shell code blocks are copy-paste safe: a language tag on every fence
     and no "$ " prompt prefix. Fences inside blockquotes / GitHub alerts
     ("> ```bash") are checked too.
  3. Notes use GitHub alert syntax ("> [!NOTE]"), not MkDocs "!!! note",
     so they render on GitHub as well as on the site and in the PDF.

Usage: python3 scripts/check_docs.py        (exit 1 on any error)
"""

import re
import sys
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parent.parent
DOCS = [ROOT / "README.md", *sorted((ROOT / "docs" / "source").rglob("*.md"))]

VER = r"(\d+\.\d+\.\d+)"

# (description, regex with one version group, versions.yml key path)
VERSION_RULES = [
    ("DX-All-Suite version", rf"DX-All-Suite v{VER}", "dx_all_suite"),
    ("DX-RT version", rf"DX-RT {VER}", "components.dx_rt"),
    ("libdxrt-bin package", rf"libdxrt-bin_{VER}", "components.dx_rt"),
    ("dx_rt download tag", rf"dx_rt/raw/refs/tags/v{VER}/", "components.dx_rt"),
    ("dx_rt release dir", rf"dx_rt/raw/[^\s)]*/release/{VER}/", "components.dx_rt"),
    ("NPU Driver version", rf"NPU Driver {VER}", "components.npu_driver"),
    ("dxrt-driver-dkms package", rf"dxrt-driver-dkms_{VER}", "components.npu_driver"),
    ("driver download tag", rf"dx_rt_npu_linux_driver/raw/refs/tags/v{VER}/", "components.npu_driver"),
    ("driver release dir", rf"dx_rt_npu_linux_driver/raw/[^\s)]*/release/{VER}/", "components.npu_driver"),
    ("DX-FW version", rf"DX-FW {VER}", "components.dx_fw"),
    ("firmware download tag", rf"dx_fw/raw/refs/tags/v{VER}/", "components.dx_fw"),
    ("firmware path", rf"dx_fw/raw/[^\s)]*/m1m?/{VER}/", "components.dx_fw"),
    ("minimum firmware", rf"[Mm]inimum (?:required )?firmware(?: version)? (?:is )?\*{{0,2}}v{VER}", "minimum.dx_fw"),
    ("DX-APP version", rf"DX-APP {VER}", "components.dx_app"),
    ("dx_app clone tag", rf"--branch v{VER}[^\n]*dx_app\.git", "components.dx_app"),
    ("DX-Stream version", rf"DX-Stream {VER}", "components.dx_stream"),
    ("dx_stream clone tag", rf"--branch v{VER}[^\n]*dx_stream\.git", "components.dx_stream"),
]

# Downloads and clones must be pinned to a tag, never a moving branch.
UNPINNED_RULES = [
    ("download from a branch", r"github\.com/DEEPX-AI/[\w-]+/raw/refs/heads/"),
    ("clone without --branch", r"git clone (?![^\n]*--branch)[^\n]*DEEPX-AI/"),
]

SHELL_LANGS = {"bash", "sh", "shell", "console"}


def lookup(data, dotted):
    for key in dotted.split("."):
        data = data[key]
    return str(data)


def line_of(text, pos):
    return text.count("\n", 0, pos) + 1


def check_versions(path, text, versions, errors):
    for desc, pattern, key in VERSION_RULES:
        want = lookup(versions, key)
        for m in re.finditer(pattern, text):
            if m.group(1) != want:
                errors.append(
                    f"{path}:{line_of(text, m.start())}: {desc} is "
                    f"{m.group(1)}, versions.yml {key} is {want}"
                )
    for desc, pattern in UNPINNED_RULES:
        for m in re.finditer(pattern, text):
            errors.append(f"{path}:{line_of(text, m.start())}: {desc}")


def check_code_blocks(path, text, errors):
    fence = None  # (indent, marker, lang) of the open fence
    for no, raw in enumerate(text.splitlines(), 1):
        # Strip blockquote markers so fences inside "> [!NOTE]" are checked.
        line = re.sub(r"^(\s*>\s?)+", "", raw)
        if fence is None and re.match(r"^\s*!!!\s", line):
            errors.append(
                f"{path}:{no}: use a GitHub alert (> [!NOTE], > [!CAUTION], "
                "> [!WARNING]) instead of '!!!'"
            )
            continue
        m = re.match(r"^(\s*)(`{3,}|~{3,})\s*([\w+-]*)", line)
        if fence is None:
            if m:
                fence = (m.group(1), m.group(2), m.group(3))
                if not fence[2]:
                    errors.append(
                        f"{path}:{no}: code block has no language tag "
                        "(use bash for commands, text for file contents)"
                    )
            continue
        if m and m.group(2).startswith(fence[1]) and not m.group(3):
            fence = None
            continue
        if fence[2] in SHELL_LANGS and re.match(r"^\s*\$ ", line):
            errors.append(
                f"{path}:{no}: remove the '$ ' prompt so the command "
                "can be copied as-is"
            )


def main():
    versions = yaml.safe_load((ROOT / "versions.yml").read_text())
    errors = []
    for doc in DOCS:
        text = doc.read_text(encoding="utf-8")
        rel = doc.relative_to(ROOT)
        check_versions(rel, text, versions, errors)
        check_code_blocks(rel, text, errors)

    for e in errors:
        print(f"ERROR {e}")
    print(f"checked {len(DOCS)} files, {len(errors)} error(s)")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
