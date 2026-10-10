#!/usr/bin/env python3
"""Remove the quick-pass address/byte comments from src/*.asm, keeping any real comment on the line.

  ; $808000: 78  interrupts off   ->  ; interrupts off
  ; $808018: E8                   ->  (comment removed)
  ; $8090EB  0: straight, high    ->  ; 0: straight, high
  ; $80FFD5 map mode              ->  ; map mode
Address ranges ("; $80ED38-$80F36D") and comments that do not start with an address are left alone.
Line endings are preserved. Usage: python tools/strip_noise.py [files...]  (default: src/*.asm)
"""
import re, sys, glob

ADDR_BYTES = re.compile(r'^;\s*\$[0-9A-F]{6}:(?: [0-9A-F]{2})+(?:  +(.*))?$')
ADDR_ONLY = re.compile(r'^;\s*\$[0-9A-F]{6}(?![-:0-9A-F])\s*(.*)$')

def first_comment(line):
    """Index of the first ';' that is outside a double-quoted string, or -1."""
    inq = False
    for i, c in enumerate(line):
        if c == '"':
            inq = not inq
        elif c == ';' and not inq:
            return i
    return -1

def fix(line):
    body = line.rstrip('\r\n')
    eol = line[len(body):]
    i = first_comment(body)
    if i < 0:
        return line, False
    code, comment = body[:i], body[i:]
    m = ADDR_BYTES.match(comment) or ADDR_ONLY.match(comment)
    if not m:
        return line, False
    rest = (m.group(1) or "").strip()
    if rest:
        new = code + '; ' + rest
    else:
        new = code.rstrip()
    return new + eol, True

def main(files):
    total = 0
    for f in files:
        with open(f, newline='') as fh:
            lines = fh.readlines()
        out, n = [], 0
        for ln in lines:
            new, changed = fix(ln)
            n += changed
            out.append(new)
        if n:
            with open(f, 'w', newline='') as fh:
                fh.writelines(out)
        total += n
        if n:
            print(f'{f}: {n}')
    print(f'total lines changed: {total}')

if __name__ == '__main__':
    main(sys.argv[1:] or sorted(glob.glob('src/*.asm')))
