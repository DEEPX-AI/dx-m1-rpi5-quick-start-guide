#!/usr/bin/env bash
#
# Build or preview the documentation site.
#
#   ./mkdocs.sh            build the HTML site and the PDF manual
#   ./mkdocs.sh --no-pdf   build the HTML site only
#   ./mkdocs.sh --serve    live preview at http://127.0.0.1:8000 (no PDF)
#
# The PDF cover version and file name are read from ../versions.yml.

set -euo pipefail
cd "$(dirname "$0")"

read -r GUIDE_VERSION GUIDE_DATE < <(python3 - <<'PY'
import yaml
v = yaml.safe_load(open("../versions.yml"))
print(v["guide"]["version"], v["guide"]["date"])
PY
)

# 2026-08-26 -> cover "2026/08/26 (v1.3.0)", file suffix "AUG_2026"
export DX_PDF_COVER_SUBTITLE="${GUIDE_DATE//-//} (v${GUIDE_VERSION})"
SUFFIX="$(date -d "$GUIDE_DATE" +%b_%Y | tr '[:lower:]' '[:upper:]')"
export DX_PDF_OUTPUT_PATH="../DEEPX_DX-M1_M1M_Quick_UM_Raspberry_Pi_5_v${GUIDE_VERSION}_${SUFFIX}.pdf"

case "${1:-}" in
    --serve)
        exec mkdocs serve
        ;;
    --no-pdf)
        exec mkdocs build --strict
        ;;
    "")
        ENABLE_PDF_EXPORT=1 exec mkdocs build
        ;;
    *)
        echo "usage: $0 [--serve | --no-pdf]" >&2
        exit 2
        ;;
esac
