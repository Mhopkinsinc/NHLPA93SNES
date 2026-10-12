#!/usr/bin/env python3
"""Regenerate docs/file_map.md from src/banks/*.asm and output/nhlpa93snes.sym (run ./build.sh first)."""
import os, re, glob
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'src')
sym = {}
for l in open(os.path.join(ROOT, 'output', 'nhlpa93snes.sym')):
    m = re.match(r'([0-9A-Fa-f]{2}):([0-9A-Fa-f]{4}) ([A-Za-z_]\w*)$', l.strip())
    if m: sym.setdefault(m.group(3), (m.group(1) + m.group(2)).upper())
out = ['# Source file map', '',
       '`src/nhlpa93snes.asm` includes one file per bank (`src/banks/bXX_<name>.asm`). A bank file sets the bank address with one `org`',
       'and includes its routine and data files in exact ROM order. Routines are in `src/routines/<93G module>/<Routine>.asm`',
       '(one routine per file; a routine that falls through into the next keeps both), non-code data in `src/data/<category>/<Name>.asm`.',
       'The SNES internal header and vectors are in `src/header/snes_header.asm` (end of bank $80).',
       'Regenerate this file with `python3 tools/gen_file_map.py` after `./build.sh`.', '']
for b in sorted(glob.glob(os.path.join(SRC, 'banks', '*.asm'))):
    out.append('## src/banks/%s' % os.path.basename(b)); out.append('')
    for l in open(b):
        m = re.match(r'incsrc "\.\./(.*)"', l)
        if not m: continue
        f = m.group(1)
        g = [x for x in re.findall(r'^([A-Za-z_]\w*):', open(os.path.join(SRC, f)).read(), re.M)]
        a = sym.get(g[0], '??????') if g else ('80FFC0' if 'snes_header' in f else '??????')
        out.append('- `$%s` %s%s' % (a, f, (' (also ' + ', '.join(g[1:]) + ')') if len(g) > 1 else ''))
    out.append('')
open(os.path.join(ROOT, 'docs', 'file_map.md'), 'w').write('\n'.join(out))
