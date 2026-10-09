#!/bin/sh
# Assemble src/nhlpa93snes.asm with asar and verify byte-identical to lst/nhlpa93snes.bin.
cd "$(dirname "$0")"
mkdir -p output
ASAR=asar; [ -x tools/bin/asar ] && ASAR=tools/bin/asar
if command -v sha1sum >/dev/null; then SHA="sha1sum"; else SHA="shasum -a 1"; fi
rm -f output/nhlpa93snes.sfc
$ASAR --fix-checksum=off --symbols=wla --symbols-path=output/nhlpa93snes.sym src/nhlpa93snes.asm output/nhlpa93snes.sfc || { echo "MISMATCH (assembly failed)"; exit 1; }
ref=$($SHA lst/nhlpa93snes.bin | cut -d' ' -f1); out=$($SHA output/nhlpa93snes.sfc | cut -d' ' -f1)
echo "ref $ref"; echo "out $out"
if [ "$ref" = "$out" ]; then echo MATCH; else echo MISMATCH; cmp -l lst/nhlpa93snes.bin output/nhlpa93snes.sfc | head -20; exit 1; fi
