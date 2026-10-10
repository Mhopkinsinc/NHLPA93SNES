#!/usr/bin/env python3
"""Count what the source cleanup still has to do in src/ (raw addresses, generic labels, noise comments).

Usage: python3 tools/scan_cleanup.py [-v] [src_dir]
Needs output/nhlpa93snes.sym (run ./build.sh first) for the pointer-immediate check.
  -v  list every hit, not just the counts
"""
import glob, os, re, sys

verbose = '-v' in sys.argv
args = [a for a in sys.argv[1:] if a != '-v']
SRC = args[0] if args else os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'src')
SYM = os.path.join(SRC, '..', 'output', 'nhlpa93snes.sym')

rom_labels = set()
if os.path.exists(SYM):
    for line in open(SYM):
        m = re.match(r'([0-9A-F]{2}):([0-9A-F]{4}) ([A-Za-z_]\w*)$', line.strip())
        if m and 0x80 <= int(m[1], 16) <= 0x8F and int(m[2], 16) >= 0x8000:
            rom_labels.add((int(m[1], 16), int(m[2], 16)))

OPS = r'(?:adc|and|asl|bit|cmp|cpx|cpy|dec|eor|inc|jml|jmp|jsl|jsr|lda|ldx|ldy|lsr|ora|rol|ror|sbc|sta|stx|sty|stz|tsb|trb|pei|pea)'
RAW_OPERAND = re.compile(r'^\s+' + OPS + r'(?:\.[bwl])?\s+[(\[]?\$[0-9A-Fa-f]+(?![0-9A-Fa-f]*\s*,\s*s\b)')
IMM16 = re.compile(r'^\s+(?:lda|ldx|ldy|cmp|pea)\.w\s+#\$([89A-F][0-9A-F]{3})\b')
BANKIMM = re.compile(r'^\s+lda\.[bw]\s+#\$(?:00)?(8[0-9A-F]|7[EF])\b')
PTRHI = re.compile(r'^\s+sta\.b\s+(?:a[0-4]\+2|tmp1|sndptr\+2|farptr\+2)\s*(?:;|$)')
PTRLO = re.compile(r'^\s+(?:sta\.b\s+(?:a[0-4]|tmp0|vbint|hbint|sndptr|farptr|fobox)|beq|bne)\s*(?:;|$|\.)')
NOISE = re.compile(r';\s*\$[0-9A-F]{6}:(?: [0-9A-F]{2})+')
GENERIC = re.compile(r'\b(?:CODE|DATA|sub|loc|unk|byte|word|off)_[0-9A-Fa-f]{4,6}\b')
AUTOLOCAL = re.compile(r'(?<![\w.])\.l\d+\b')
AUTOTRACE = re.compile(r';\s*auto(?::| \()')
GLOBAL = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*):(.*)$')

counts = {k: 0 for k in ('raw_operand', 'pointer_imm', 'bank_imm', 'noise', 'generic_label', 'auto_local',
                         'auto_trace', 'global_no_comment')}
hits = {k: [] for k in counts}

def hit(kind, f, n, line):
    counts[kind] += 1
    if verbose:
        hits[kind].append(f'{os.path.basename(f)}:{n}: {line.strip()[:100]}')

files = sorted(glob.glob(os.path.join(SRC, '**', '*.asm'), recursive=True))
for f in files:
    if os.path.basename(f) in ('snes_regs.asm', 'ram93snes.asm'):
        continue
    bank = None
    lines = open(f).read().split('\n')
    for n, line in enumerate(lines, 1):
        m = re.match(r'\s*org\s+\$([0-9A-F]{2})', line)
        if m:
            bank = int(m[1], 16)
        code = line.split(';')[0]
        if NOISE.search(line):
            hit('noise', f, n, line)
        if RAW_OPERAND.match(code):
            hit('raw_operand', f, n, line)
        m = IMM16.match(code)
        vb = n < len(lines) and re.search(r'\b(?:vbint|hbint)\b', lines[n])
        if m and bank is not None and ((bank, int(m[1], 16)) in rom_labels or (vb and (0x80, int(m[1], 16)) in rom_labels)) \
                and n < len(lines) and PTRLO.match(lines[n]):
            hit('pointer_imm', f, n, line)
        if BANKIMM.match(code) and n < len(lines) and PTRHI.match(lines[n]):
            hit('bank_imm', f, n, line)
        if GENERIC.search(code):
            hit('generic_label', f, n, line)
        if AUTOLOCAL.search(code):
            hit('auto_local', f, n, line)
        if AUTOTRACE.search(line):
            hit('auto_trace', f, n, line)
        m = GLOBAL.match(line)
        if m and not m[1].endswith('End') and not m[2].strip().startswith(('db', 'dw', 'dl', 'dd', 'incbin')) and ';' not in m[2]:
            nxt = lines[n] if n < len(lines) else ''
            if not nxt.strip().startswith(';'):
                hit('global_no_comment', f, n, line)

print(f'files scanned: {len(files)}')
for k, v in counts.items():
    print(f'{k:18} {v}')
if verbose:
    for k, v in hits.items():
        if v:
            print(f'\n[{k}]')
            print('\n'.join(v))
