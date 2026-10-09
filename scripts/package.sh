#!/usr/bin/env bash
# Build the release zips from a folder of built liveries (the SDK's Bundles output or a game Skins folder).
# Usage: scripts/package.sh <skins-dir> <out-dir> [version]
set -euo pipefail
SRC=${1:?skins dir}; OUT=${2:?out dir}; VER=${3:-v1.0.0}
LIVERIES=(
  TAL_Cricket_SorrelRacer TAL_Cricket_StickerBomb
  TAL_Ifrit_GlacierSplinter TAL_Ifrit_SharkMouth
  TAL_Tarantula_ArcticResearch
  TAL_Darkreach_GhostKnight TAL_Darkreach_BareMetal
  TAL_Medusa_DigitalCamo TAL_Medusa_StickerBomb
  TAL_Chicane_Rattlesnake
  TAL_Revoker_TigerMeet TAL_Revoker_StickerBomb
)
AIRCRAFT=(Cricket Ifrit Tarantula Darkreach Medusa Chicane Revoker)
mkdir -p "$OUT"; OUT=$(cd "$OUT" && pwd)
cd "$SRC"
for d in "${LIVERIES[@]}"; do
  for f in meta.json catalog_1.json catalog_1.hash; do [ -f "$d/$f" ] || { echo "missing $d/$f" >&2; exit 1; }; done
  ls "$d"/*_assets_all.bundle >/dev/null
done
TZ=UTC zip -X -r -q "$OUT/Talamander-Liveries-$VER-all.zip" "${LIVERIES[@]}"
for a in "${AIRCRAFT[@]}"; do
  sel=(); for d in "${LIVERIES[@]}"; do [[ $d == TAL_${a}_* ]] && sel+=("$d"); done
  TZ=UTC zip -X -r -q "$OUT/Talamander-Liveries-$VER-$a.zip" "${sel[@]}"
done
(cd "$OUT" && sha256sum Talamander-Liveries-"$VER"-*.zip > SHA256SUMS.txt && cat SHA256SUMS.txt)
