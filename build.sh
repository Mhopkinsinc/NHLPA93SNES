#!/bin/sh
# Assemble src/nhlpa93snes.asm with asar and verify byte-identical to lst/nhlpa93snes.bin.
set -e
cd "$(dirname "$0")"
mkdir -p output
rm -f output/nhlpa93snes.sfc
asar --fix-checksum=off --symbols=wla --symbols-path=output/nhlpa93snes.sym src/nhlpa93snes.asm output/nhlpa93snes.sfc
ref=$(sha1sum lst/nhlpa93snes.bin | cut -d' ' -f1); out=$(sha1sum output/nhlpa93snes.sfc | cut -d' ' -f1)
echo "ref $ref"; echo "out $out"
if [ "$ref" = "$out" ]; then echo MATCH; else echo MISMATCH; cmp -l lst/nhlpa93snes.bin output/nhlpa93snes.sfc | head -20; exit 1; fi
