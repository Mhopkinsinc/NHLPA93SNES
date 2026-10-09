#!/usr/bin/env python3
"""Quick recursive-descent 65816 disassembler for NHLPA Hockey 93 SNES (LoROM, banks $80-$8F).
Tracks M/X through REP/SEP (and PLP/RTI heuristically: state after PLP = state at matching PHP if known).
Emits asar asm, one file per bank, under src/. Unreached bytes become db (TODO for segment agents).
Usage: python3 tools/disasm65816.py rom.bin outdir
"""
import sys, os, collections
M = {}
def op(codes, mn, mode):
    for c in codes: M[c] = (mn, mode)
# mode names: imp, immM, immX, imm8, dp, dpx, dpy, idp, idx, idy, idl, idly, sr, sry, abs, abx, aby, abl, alx, ind, iax, ial, rel, rell, bm, acc
grp = {'ora':0x00,'and':0x20,'eor':0x40,'adc':0x60,'sta':0x80,'lda':0xA0,'cmp':0xC0,'sbc':0xE0}
for mn,b in grp.items():
    for off,mode in [(1,'idx'),(3,'sr'),(5,'dp'),(7,'idl'),(9,'immM'),(0xD,'abs'),(0xF,'abl'),(0x11,'idy'),(0x12,'idp'),(0x13,'sry'),(0x15,'dpx'),(0x17,'idly'),(0x19,'aby'),(0x1D,'abx'),(0x1F,'alx')]:
        if mn=='sta' and off==9: continue
        M[b+off]=(mn,mode)
for mn,b in {'asl':0x00,'rol':0x20,'lsr':0x40,'ror':0x60}.items():
    M[b+6]=(mn,'dp');M[b+0xA]=(mn,'acc');M[b+0xE]=(mn,'abs');M[b+0x16]=(mn,'dpx');M[b+0x1E]=(mn,'abx')
T=[(0x00,'brk','imm8'),(0x02,'cop','imm8'),(0x04,'tsb','dp'),(0x0C,'tsb','abs'),(0x08,'php','imp'),(0x0B,'phd','imp'),
(0x10,'bpl','rel'),(0x14,'trb','dp'),(0x1C,'trb','abs'),(0x18,'clc','imp'),(0x1A,'inc','acc'),(0x1B,'tcs','imp'),
(0x20,'jsr','abs'),(0x22,'jsl','abl'),(0x24,'bit','dp'),(0x2C,'bit','abs'),(0x28,'plp','imp'),(0x2B,'pld','imp'),
(0x30,'bmi','rel'),(0x34,'bit','dpx'),(0x3C,'bit','abx'),(0x38,'sec','imp'),(0x3A,'dec','acc'),(0x3B,'tsc','imp'),
(0x40,'rti','imp'),(0x42,'wdm','imm8'),(0x44,'mvp','bm'),(0x48,'pha','imp'),(0x4B,'phk','imp'),(0x4C,'jmp','abs'),
(0x50,'bvc','rel'),(0x54,'mvn','bm'),(0x58,'cli','imp'),(0x5A,'phy','imp'),(0x5B,'tcd','imp'),(0x5C,'jml','abl'),
(0x60,'rts','imp'),(0x62,'per','rell'),(0x64,'stz','dp'),(0x68,'pla','imp'),(0x6B,'rtl','imp'),(0x6C,'jmp','ind'),
(0x70,'bvs','rel'),(0x74,'stz','dpx'),(0x78,'sei','imp'),(0x7A,'ply','imp'),(0x7B,'tdc','imp'),(0x7C,'jmp','iax'),
(0x80,'bra','rel'),(0x82,'brl','rell'),(0x84,'sty','dp'),(0x86,'stx','dp'),(0x88,'dey','imp'),(0x89,'bit','immM'),(0x8A,'txa','imp'),(0x8B,'phb','imp'),
(0x8C,'sty','abs'),(0x8E,'stx','abs'),(0x90,'bcc','rel'),(0x94,'sty','dpx'),(0x96,'stx','dpy'),(0x98,'tya','imp'),(0x9A,'txs','imp'),(0x9B,'txy','imp'),
(0x9C,'stz','abs'),(0x9E,'stz','abx'),(0xA0,'ldy','immX'),(0xA2,'ldx','immX'),(0xA4,'ldy','dp'),(0xA6,'ldx','dp'),(0xA8,'tay','imp'),(0xAA,'tax','imp'),(0xAB,'plb','imp'),
(0xAC,'ldy','abs'),(0xAE,'ldx','abs'),(0xB0,'bcs','rel'),(0xB4,'ldy','dpx'),(0xB6,'ldx','dpy'),(0xB8,'clv','imp'),(0xBA,'tsx','imp'),(0xBB,'tyx','imp'),
(0xBC,'ldy','abx'),(0xBE,'ldx','aby'),(0xC0,'cpy','immX'),(0xC2,'rep','imm8'),(0xC4,'cpy','dp'),(0xC6,'dec','dp'),(0xC8,'iny','imp'),(0xCA,'dex','imp'),(0xCB,'wai','imp'),
(0xCC,'cpy','abs'),(0xCE,'dec','abs'),(0xD0,'bne','rel'),(0xD4,'pei','dp'),(0xD6,'dec','dpx'),(0xD8,'cld','imp'),(0xDA,'phx','imp'),(0xDB,'stp','imp'),(0xDC,'jml','ial'),(0xDE,'dec','abx'),
(0xE0,'cpx','immX'),(0xE2,'sep','imm8'),(0xE4,'cpx','dp'),(0xE6,'inc','dp'),(0xE8,'inx','imp'),(0xEA,'nop','imp'),(0xEB,'xba','imp'),(0xEC,'cpx','abs'),(0xEE,'inc','abs'),
(0xF0,'beq','rel'),(0xF4,'pea','abs'),(0xF6,'inc','dpx'),(0xF8,'sed','imp'),(0xFA,'plx','imp'),(0xFB,'xce','imp'),(0xFC,'jsr','iax'),(0xFE,'inc','abx')]
for c,mn,mode in T: M[c]=(mn,mode)
assert len(M)==256, len(M)
SZ={'imp':0,'acc':0,'imm8':1,'dp':1,'dpx':1,'dpy':1,'idp':1,'idx':1,'idy':1,'idl':1,'idly':1,'sr':1,'sry':1,'rel':1,
    'abs':2,'abx':2,'aby':2,'ind':2,'iax':2,'ial':2,'rell':2,'bm':2,'abl':3,'alx':3}
FMT={'imp':'{m}','acc':'{m} a','imm8':'{m} #${v:02X}','dp':'{m}.b ${v:02X}','dpx':'{m}.b ${v:02X},x','dpy':'{m}.b ${v:02X},y',
 'idp':'{m}.b (${v:02X})','idx':'{m}.b (${v:02X},x)','idy':'{m}.b (${v:02X}),y','idl':'{m}.b [${v:02X}]','idly':'{m}.b [${v:02X}],y',
 'sr':'{m}.b ${v:02X},s','sry':'{m}.b (${v:02X},s),y','abs':'{m}.w ${v:04X}','abx':'{m}.w ${v:04X},x','aby':'{m}.w ${v:04X},y',
 'ind':'{m} (${v:04X})','iax':'{m} (${v:04X},x)','ial':'{m} [${v:04X}]','abl':'{m}.l ${v:06X}','alx':'{m}.l ${v:06X},x'}
STOP={'rts','rtl','rti','jmp','jml','bra','brl','stp','brk','cop'}
BR={'bpl','bmi','bvc','bvs','bra','bcc','bcs','bne','beq','brl'}
rom=open(sys.argv[1],'rb').read(); out=sys.argv[2]; NB=len(rom)//0x8000
def off(addr):  # LoROM
    b=(addr>>16)&0x7F; a=addr&0xFFFF
    if a<0x8000 or b>=NB: return None
    return b*0x8000+(a-0x8000)
def addr(o): return 0x800000|((o//0x8000)<<16)|(0x8000+o%0x8000)
ins={}; cov=set(); flags={}; entries=set(); q=collections.deque()
def push(a,m,x,why):
    o=off(a)
    if o is None: return
    entries.add(o)
    if o in ins: return
    q.append((o,m,x))
w=lambda o:rom[o]|rom[o+1]<<8
v=rom[0x7FE0:0x8000]
for i in (4,6,0xA,0xE,0x1C,0x1E):
    a=w(0x7FE0+i)
    if a>=0x8000: push(0x800000|a,1,1,'vec')
while q:
    o,m,x=q.popleft(); phps=[]
    while True:
        if o in ins or o in cov or o>=len(rom): break
        c=rom[o]; mn,mode=M[c]
        n=1+(SZ[mode] if mode not in('immM','immX') else (1 if (m if mode=='immM' else x) else 2))
        if (o%0x8000)+n>0x8000: break
        if any(p in cov for p in range(o,o+n)): break
        if c in (0x00,0x02,0xDB,0x42) : break  # brk/cop/stp/wdm: treat as data
        ins[o]=(n,m,x); cov.update(range(o,o+n)); a=addr(o); bank=a&0xFF0000
        val=int.from_bytes(rom[o+1:o+n],'little') if n>1 else 0
        if mn=='rep': m=m and not(val&0x20); x=x and not(val&0x10)
        elif mn=='sep': m=m or bool(val&0x20); x=x or bool(val&0x10)
        elif mn=='php': phps.append((m,x))
        elif mn=='plp' and phps: m,x=phps.pop()
        if mode=='rel': push(bank|((a+2+(val-256 if val>127 else val))&0xFFFF),m,x,'br')
        elif mode=='rell' and mn=='brl': push(bank|((a+3+(val-65536 if val>32767 else val))&0xFFFF),m,x,'br')
        elif mn in('jsr','jmp') and mode=='abs': push(bank|val,m,x,'j')
        elif mn in('jsl','jml') and mode=='abl': push(val,m,x,'j')
        if mn in STOP: break
        o+=n
# emit
os.makedirs(out,exist_ok=True); stats=[0,0]
for b in range(NB):
    L=[f'; Bank ${0x80+b:02X}  ROM ${b*0x8000:05X}-${b*0x8000+0x7FFF:05X}  (auto-generated quick pass; TODO: segment agents refine)',f'org ${0x80+b:02X}8000','']
    o=b*0x8000; end=o+0x8000; data=[]
    def flush():
        global data
        for i in range(0,len(data),16):
            ch=data[i:i+16]; L.append('\tdb '+','.join(f'${c:02X}' for c,_ in ch)+f'\t; ${addr(ch[0][1]):06X}')
        data=[]
    while o<end:
        if o==0x7FC0 and b==0:
            flush(); L.append('; Internal header $FFC0-$FFFF follows as data (see header.asm notes)')
        if o in ins and not(b==0 and 0x7FB0<=o):
            flush(); n,m,x=ins[o]; c=rom[o]; mn,mode=M[c]; a=addr(o); val=int.from_bytes(rom[o+1:o+n],'little')
            if o in entries: L.append(f'CODE_{a:06X}:\t\t; M={8 if m else 16} X={8 if x else 16}')
            if mode in('immM','immX'): s=f'{mn}.{"b" if n==2 else "w"} #${val:0{2*(n-1)}X}'
            elif mode in('rel','rell'):
                t=(a&0xFF0000)|((a+n+(val-(256 if n==2 else 65536) if val>(127 if n==2 else 32767) else val))&0xFFFF)
                to=off(t)
                s=f'{mn} CODE_{t:06X}' if to in ins and to in entries and not(b==0 and to>=0x7FB0) else 'db '+','.join(f'${c:02X}' for c in rom[o:o+n])+f' ; {mn} ${t:06X}'
            elif mode=='bm': s=f'{mn} ${rom[o+2]:02X},${rom[o+1]:02X}'
            else: s=FMT[mode].format(m=mn,v=val)
            L.append(f'\t{s}\t\t; ${a:06X}: '+' '.join(f'{c:02X}' for c in rom[o:o+n])); o+=n; stats[0]+=n
        else:
            data.append((rom[o],o)); o+=1; stats[1]+=1
    flush()
    open(f'{out}/bank{0x80+b:02X}.asm','w').write('\n'.join(L)+'\n')
print(f'code bytes {stats[0]} ({100*stats[0]/len(rom):.1f}%), data/unresolved {stats[1]}; entries {len(entries)}')
