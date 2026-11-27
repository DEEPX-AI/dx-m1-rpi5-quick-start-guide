# User-Guide

## Mkdocs quick start

All commands below are run from the `docs/` directory.

### Installation

Install MkDocs and the plugins used by `mkdocs.yml`:

```bash
pip install -r requirements.txt
```

PDF output uses WeasyPrint, which needs the Pango library from the OS (e.g. `sudo apt install libpango-1.0-0 libpangoft2-1.0-0` on Debian/Ubuntu).

**Reference** : https://github.com/domWalters/mkdocs-to-pdf

### Building the site

Build the HTML site (`docs/docs/`) and the PDF manual (`docs/DEEPX_DX-M1_M1M_Quick_UM_Raspberry_Pi_5_v<version>_<MON>_<YEAR>.pdf`):

```bash
./mkdocs.sh
```

Build the HTML site only, failing on any warning (same as CI):

```bash
./mkdocs.sh --no-pdf
```

The PDF cover version and file name come from `../versions.yml` (`guide.version`, `guide.date`).

### Start the server

```bash
./mkdocs.sh --serve
```

**Reference** : https://mkdocs.readthedocs.io/en/stable/getting-started/
