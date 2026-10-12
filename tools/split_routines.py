#!/usr/bin/env python3
"""Split the old module files (src/<module>_bXX.asm, src/gfx/*.asm) into the bank/routine/data layout.

Mechanical: lines are moved, never edited (except incbin paths, rewritten for the new file depth).
Usage: python3 tools/split_routines.py analyze
       python3 tools/split_routines.py migrate <bank hex, e.g. 8C> <bank file name, e.g. b8C_logo>
Migrate writes src/banks/<name>.asm, src/routines/<module>/*.asm, src/data/<cat>/*.asm, deletes the old block text
for that bank from the old files (deleting a file once it is empty), and switches src/nhlpa93snes.asm over.
"""
import os, re, sys, glob

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, 'src')
SKIP = {'nhlpa93snes.asm', 'ram93snes.asm'}
GLOBAL = re.compile(r'^([A-Za-z_][A-Za-z0-9_]*):')
ORG = re.compile(r'^org \$([0-9A-Fa-f]{6})\s*$')
MNEM = set('''adc and asl bcc bcs beq bit bmi bne bpl bra brk brl bvc bvs clc cld cli clv cmp cop cpx cpy dec dex dey eor inc inx iny
jml jmp jsl jsr lda ldx ldy lsr mvn mvp nop ora pea pei per pha phb phd phk php phx phy pla plb pld plp plx ply rep rol ror rti rtl rts
sbc sec sed sei sep sta stp stx sty stz tax tay tcd tcs tdc trb tsb tsc tsx txa txs txy tya tyx wai wdm xba xce'''.split())
TERM = {'rts', 'rtl', 'rti', 'jmp', 'jml', 'bra', 'brl', 'stp'}

def old_files():
    fs = [f for f in glob.glob(os.path.join(SRC, '*.asm')) if os.path.basename(f) not in SKIP]
    return sorted(fs + glob.glob(os.path.join(SRC, 'gfx', '*.asm')))

def module_of(path):
    b = os.path.relpath(path, SRC).replace('\\', '/')
    if b.startswith('gfx/'): return 'gfx'
    return re.sub(r'_b[0-9A-F]{2}$', '', b[:-4])

def mnem(line):
    s = GLOBAL.sub('', line)
    s = re.sub(r'^\.[A-Za-z0-9_]+:', '', s).split(';')[0].strip()
    if not s: return None
    w = s.split()[0].lower().split('.')[0]
    return w if w in MNEM else ('data' if w else None)

def parse(path):
    """-> (preamble lines, [blocks]); block = dict(addr, lines(list incl. org line), start, end line idx)"""
    L = open(path).read().split('\n')
    blocks, pre, cur = [], [], None
    for i, l in enumerate(L):
        m = ORG.match(l)
        if m:
            cur = dict(addr=int(m.group(1), 16), start=i, lines=[]); blocks.append(cur)
        elif cur is None: pre.append(l)
        else: cur['lines'].append(l)
    for b in blocks:
        while b['lines'] and b['lines'][0].strip() == '': b['lines'].pop(0)
        while b['lines'] and b['lines'][-1].strip() == '': b['lines'].pop()
    return L, pre, blocks

def segments(block):
    """split block lines at global labels; comment lines right before a label go with it"""
    segs, cur = [], None
    pend = []
    for l in block['lines']:
        m = GLOBAL.match(l)
        if m:
            cur = dict(name=m.group(1), lines=pend + [l]); pend = []; segs.append(cur)
        elif l.lstrip().startswith(';') and cur is not None:
            pend.append(l)
        else:
            if cur is None: cur = dict(name=None, lines=[]); segs.append(cur)
            cur['lines'] += pend + [l]; pend = []
    if pend: cur['lines'] += pend
    for s in segs:
        ms = [mnem(l) for l in s['lines']]; ms = [m for m in ms if m]
        s['code'] = any(m != 'data' for m in ms)
        s['last'] = ms[-1] if ms else None
    return segs

def merged(segs):
    out = []
    for s in segs:
        if out and (s['name'] is None or s['name'].endswith('End') or (s['name'].startswith('unused') and not s['code'])
                    or (out[-1]['code'] and out[-1]['last'] not in TERM and out[-1]['last'] != 'data')):
            p = out[-1]; p['lines'] += s['lines']; p['code'] |= s['code']; p['last'] = s['last'] or p['last']
            p.setdefault('also', []).append(s['name'])
        else:
            out.append(dict(s))
    return out

TEXTY = re.compile(r'Text|Credits|Msg|Message|String', re.I)
def dest(module, s):
    n = s['name']
    if s['code']:
        return 'routines/%s' % ('video' if module == 'gfx' else module)
    if module in ('gfx',): return 'data/gfx'
    if module == 'frames': return 'data/frames'
    if module == 'teamdata': return 'data/teams'
    if n is None: raise SystemExit('unnamed segment in %s: %r' % (module, s['lines'][:4]))
    if TEXTY.search(n): return 'data/text'
    if module == 'sound': return 'data/sound'
    return 'routines/%s' % module   # small tables of a code module stay with the module

def fix_incbin(l, depth_from_src):
    m = re.search(r'incbin "((?:\.\./)+)data/', l)
    if not m: return l
    return l.replace(m.group(1) + 'data/', '../' * (depth_from_src + 1) + 'data/', 1)

def collect(bank):
    items = []   # (addr, order, file, module, segs)
    for f in old_files():
        L, pre, blocks = parse(f)
        for bi, b in enumerate(blocks):
            if b['addr'] >> 16 == bank:
                items.append((b['addr'], f, bi, merged(segments(b))))
    items.sort()
    return items

def analyze():
    tot = {}
    for bank in range(0x80, 0x90):
        items = collect(bank)
        n = sum(len(i[3]) for i in items)
        print('$%02X blocks %d files %d first %s' % (bank, len(items), n, '%06X' % items[0][0] if items else '-'))
        for a, f, bi, segs in items:
            for s in segs:
                d = dest(module_of(f), s); tot[d] = tot.get(d, 0) + 1
    for k in sorted(tot): print(k, tot[k])

def migrate(bank, name):
    items = collect(bank)
    taken = {}
    for p in glob.glob(os.path.join(SRC, '**', '*.asm'), recursive=True):
        taken[os.path.relpath(p, SRC).lower()] = 1
    incs = []
    first = items[0][0]
    for a, f, bi, segs in items:
        mod = module_of(f)
        for s in segs:
            d = dest(mod, s)
            if s['name'] == 'unusedFF' or 'NHLPA Hockey' in ''.join(s['lines']): pass
            lines = s['lines']
            # the internal header/vectors get their own file
            hi = next((i for i, l in enumerate(lines) if l.startswith('\tdb "NHLPA Hockey')), None)
            parts = [(d, s['name'], lines)] if hi is None else [(d, s['name'], lines[:hi]), ('header', 'snes_header', lines[hi:])]
            for d2, nm, ls in parts:
                rel = '%s/%s.asm' % (d2, nm)
                k = 2
                while rel.lower() in taken: rel = '%s/%s_%d.asm' % (d2, nm, k); k += 1
                taken[rel.lower()] = 1
                depth = rel.count('/')
                os.makedirs(os.path.join(SRC, d2), exist_ok=True)
                body = [fix_incbin(l, depth) for l in ls]
                open(os.path.join(SRC, rel), 'w').write('\n'.join(body) + '\n')
                incs.append(rel)
    bf = 'banks/%s.asm' % name
    os.makedirs(os.path.join(SRC, 'banks'), exist_ok=True)
    out = ['; Bank $%02X: %s. Files in ROM order (docs/file_map.md).' % (bank, name.split('_', 1)[1].replace('_', ' ')),
           '', 'org $%06X' % first] + ['incsrc "../%s"' % r for r in incs]
    open(os.path.join(SRC, bf), 'w').write('\n'.join(out) + '\n')
    # remove the blocks from the old files
    touched = sorted(set(i[1] for i in items))
    for f in touched:
        L, pre, blocks = parse(f)
        keep = list(pre)
        for b in blocks:
            if b['addr'] >> 16 != bank:
                keep += ['org $%06X' % b['addr']] + b['lines'] + ['']
        if any(ORG.match(l) for l in keep):
            open(f, 'w').write('\n'.join(keep).rstrip('\n') + '\n')
        else:
            os.remove(f)
    # master
    mp = os.path.join(SRC, 'nhlpa93snes.asm')
    M = open(mp).read().split('\n')
    gone = {os.path.relpath(f, SRC).replace('\\', '/') for f in touched if not os.path.exists(f)}
    M = [l for l in M if not any(l == 'incsrc "%s"' % g for g in gone)]
    # bank includes go in bank order before the remaining old module files
    bl = [i for i, l in enumerate(M) if l.startswith('incsrc "banks/')]
    newl = 'incsrc "%s"' % bf
    allb = sorted([M[i] for i in bl] + [newl], key=lambda s: s.lower())
    for i in reversed(bl): del M[i]
    at = max(i for i, l in enumerate(M) if l.startswith('incsrc "ram93snes')) + 1
    M[at:at] = allb
    open(mp, 'w').write('\n'.join(M))
    print('\n'.join(incs)); print(len(incs), 'files ->', bf)

if __name__ == '__main__':
    if sys.argv[1] == 'analyze': analyze()
    else: migrate(int(sys.argv[2], 16), sys.argv[3])
