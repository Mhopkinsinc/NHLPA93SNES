; NHLPA 93 SNES RAM map (WRAM $7E0000-$7FFFFF, low 8K mirrored at $0000-$1FFF in banks $00-$3F/$80-$BF).
; Not a queue segment: no ROM bytes. Add names freely as segments are transcribed. Define each name once.
; Prefer NHL92 Genesis / NHLPA93 Genesis RAM names when the variable plays the same role.
; Format:  Name = $xxxx   (asar equate). DP names are < $100 and are written with .b; others with .w / .l.
; The constants section at the end holds values (bit masks, animation offsets, sound numbers), not addresses.

; Direct page $00-$18: vblank / irq bookkeeping (from VBjsr, vb2, HBjsr in bank80)
vcount		= $00	; 32-bit frame counter, +1 per vblank in vb2_main. 93G vcount (word there)
brightness	= $04	; INIDISP shadow (0-15 brightness, $80 forced blank), written each vblank by vb2
fadeout		= $06	; nonzero: vb2 steps brightness down every 4 frames until 0. SNES stand-in for 93G cramfade
fadein		= $08	; 1: vb2 steps brightness up every 4 frames to 15; >1: delay count before fading in
xsave		= $0A	; X saved around the movem-style push/pop loops of the 68k port (stx xsave : ldx #0 ...)
vbactive	= $12	; nonzero while the vbint handler runs (or while main code holds vblank off): VBjsr skips it
vbint		= $14	; address (bank $80) of the vblank handler VBjsr jumps to. 93G vbint
hbint		= $16	; address (bank $80) of the H/V-timer IRQ handler HBjsr jumps to. Default HBdefault
hcount		= $18	; +1 per IRQ that is not a timer IRQ (HBdefault); cleared every vblank
sndlock		= $21	; nonzero while main code changes the sound command queue (bank $82); set by Start during sound init

; Direct page $33-$72: the 68k registers of the port. Each is 4 bytes (long); word code uses the low word.
a0		= $33	; 68k a0: object index (SCnum*2) or long pointer [a0] (a0+2 = bank)
a1		= $37	; 68k a1
a2		= $3B	; 68k a2: team index, 0 = home (hmtmstruct), 2 = away (awtmstruct)
a3		= $3F	; 68k a3: current object index (SCnum*2); X normally holds the same value
d0		= $53	; 68k d0
d1		= $57	; 68k d1
d2		= $5B	; 68k d2
d3		= $5F	; 68k d3
d4		= $63	; 68k d4
d5		= $67	; 68k d5
d6		= $6B	; 68k d6
d7		= $6F	; 68k d7: frames elapsed this game frame (time step), as in 93G updateplayers
tmp0		= $73	; scratch word (SNES port temporaries in place of extra 68k data registers)
tmp1		= $75	; scratch word; tmp0/tmp1 together form a 32-bit value (or tmp1 = long pointer, tmp1+2 = bank)
mula		= $7D	; multiply/divide operand A (32-bit with mula+2). Helpers: muls16, mulu (bank $8D/$88), muls (bank $82)
mulb		= $83	; multiply/divide operand B (32-bit with mulb+2)
mulres		= $93	; multiply result low word; mulres+2 ($95) = high word (68k swap)
DMAListend	= $A3	; byte offset of the end of DMAList (7 bytes per entry); VBlank sends and empties it. 93G DMAListend
sprclock	= $A7	; sprite VRAM tile cache clock: a slot whose sprslottime is older than sprclock-sprslotlife is free
sprpriority	= $BB	; OAM attribute priority bits ORed into every game sprite ($20 at start)
sprslotlife	= $C1	; frames a sprite VRAM slot stays reserved after it was last used ($12 at start)

; $0100-$1FFF: absolute (DB = $80 mirrors bank $00 WRAM)
Hpos		= $0156	; ice rink horizontal position: BG2HOFS = Hpos+$C0 (VBlank). 93G Hpos
sfxretjml	= $0178	; RAM trampoline: $5C (jml opcode, set by Start); sfx writes its return address at +1..+3 and jumps here
lastplayer	= $017D	; SCnum of the last player who touched the puck (doshot). 93G lastplayer
Satt		= $01FF	; sprite attribute table (OAM shadow, $220 bytes), sent by VBlank. 93G Satt
passdir		= $043B	; direction for pass/shot 0-7 (8 = none). 93G passdir
passspeed	= $043D	; speed of pass/shot. 93G passspeed
Oldrow		= $049D	; rink map row of the BG2 ring buffer (BG2VOFS = Oldrow*8 + (Vpos&7)). 93G Oldrow
seed		= $04A1	; 32-bit random seed (randomd0). 92 seed, 93G StanleyCupTimer. Its low bits also serve as a quick random
shotplayer	= $04A5	; SCnum of the player who shot last. 93G shotplayer
sprslottime	= $04AB	; 512 words: sprclock value when each 32-byte VRAM sprite tile slot was last used
threat		= $08D3	; direction of threat on puck handler (nonzero = threat). 93G threat
Vpos		= $08E1	; ice rink vertical position (low 3 bits = BG2 fine scroll). 93G Vpos

; Sort objects (93G SortCords): structure of arrays, one word per object, 16 objects ($20 bytes per field).
; Index with X/Y = SCnum*2. The 93G byte fields (pnum ... handed) are each a word array here.
; Fields from Xvel on are in the 93G struct order; the gaps are fields not met yet.
Xpos		= $08FF	; 93G Xpos (integer part)
Ypos		= $095F	; 93G Ypos (integer part)
Xvel		= $0ADF	; 93G Xvel
Yvel		= $0AFF	; 93G Yvel
Zvel		= $0B1F	; 93G Zvel
position	= $0B9F	; player's position (0=goalie,1=l.def,2=r.def,3=l.wing,4=center,5=r.wing; negative = none). 93G position
assnum		= $0BBF	; index to current assignment (0-7). 93G assnum
asslist		= $0BDF	; list of assignments, 8 bytes per object: asslist+SCnum*8+assnum (index X*4+assnum). 93G asslist
temp1		= $0C5F	; 93G temp1
temp2		= $0C7F	; 93G temp2 (high byte as a byte counter: sub.b d7,temp2)
temp3		= $0C9F	; 93G temp3
temp2b		= $0CFF	; 93G temp2+1 (low byte; the port also uses it where 93G uses temp2 as a word: swing time, pass wait)
facedir		= $0DBF	; direction of facing 0-7. 93G facedir
SPA		= $0DFF	; current animation (offset into the animation data). 93G SPA
SPAnum		= $0E1F	; index into animation (4 per frame). 93G SPAnum
nopuck		= $0E5F	; no puck collision until zero. 93G nopuck
newpos		= $0E9F	; requested next position (negative = none). 93G newpos
newpnum		= $0EBF	; requested next roster player (negative = none). 93G newpnum
pflags		= $0EDF	; 93G pflags (bits 0-7) and pflags2 (bit n at bit n+10); some flags have their own arrays below
pnum		= $0F1F	; player's team location number (low byte). 93G pnum
aioff		= $0F9F	; 93G aioff
shotspd		= $0FDF	; 93G shotspd
shotacc		= $0FFF	; 93G shotacc
spodds		= $105F	; shot/pass odds. 93G spodds
aggress		= $10FF	; 93G aggress ($75)
pfgoal		= $113F	; nonzero: shoots at the top goal. 93G pflags bit pfgoal
pf2fight	= $115F	; nonzero: fighting. 93G pflags2 bit pf2fight
pfalock		= $117F	; nonzero: locked until the animation is done. 93G pflags bit pfalock
pfteam		= $119F	; 0 = home, nonzero = visitors. 93G pflags bit pfteam
pfrev		= $11BF	; nonzero: skating backwards. 93G pflags bit pfrev
pf2aip		= $11DF	; nonzero: animation in progress. 93G pflags2 bit pf2aip
pfnc		= $11FF	; nonzero: no collision mode. 93G pflags bit pfnc
pspeed		= $126F	; |Xvel|+|Yvel| after a burst (SNES only, read by the hit code)

; Game state
gmode		= $1288	; game mode flags (gm* masks). 93G gmode
gmclock		= $128A	; nonzero: game clock is stopped. 93G gmode bit gmclock
sflags		= $128C	; 93G sflags (low byte) and sflags2 (high byte) as one word (sf*/sf2* masks)
RefCnt		= $12EA	; ref graphics control (negative = idle). 93G RefCnt

; Team structs (93G hmtmstruct / awtmstruct): word arrays indexed by a2 (0 home, 2 away)
tmsort		= $13D2	; first object index of the team. 93G tmsort
tmnear		= $13FA	; 32-bit (tmnear = low word, +4 = high word): nearest distance^2 to the puck (assnearest). 93G team long $2A
tmflags		= $140A	; team flags. 93G tmflags
tmpde		= $147A	; energy of each roster player (word per player, +$34 for team 2). 93G tmpde

; Options
OptPen		= $160A	; penalties (0 = off). 93G OptPen
OptLine		= $160C	; line changes (0 = on). 93G OptLine

DMAList		= $1653	; vram dma list (7-byte entries, see dma* offsets), filled up to DMAListend. 93G DMAList

; Bank $7E
sprframetime	= $7E2000	; 4 bytes per sprite frame: sprclock when its tiles were last sent (sprite VRAM tile cache)
palbuffer	= $7E6C74	; CGRAM shadow (256 colors, 512 bytes): VBlank_Cram sends it. 93G palbuffer role

; --- constants (values, not addresses) ---
puckobj		= $1C	; object index of the puck (93G puckscnum 14 * 2)
JMLOPCODE	= $5C	; jml opcode (sfxretjml)
DPCLEAREND	= $164E	; Start clears DP/RAM $0000 up to here
; DMAList entry offsets
dmasrc		= 0	; word: source address
dmabank		= 2	; byte: source bank
dmalen		= 3	; word: byte count
dmavram		= 5	; word: VRAM word address
dmasize		= 7	; bytes per entry
; gmode bits (93G gmode bit numbers in the comments)
gmhl		= $0010	; hilight mode (93G gmhl 4)
gmoffs		= $0020	; offsides on (93G gmoffs 5)
; sflags (low byte = 93G sflags, high byte = 93G sflags2)
sfssdir		= $0008	; set shot dir mode (93G sfssdir 3)
sf2shot		= $1000	; shot was taken (93G sf2shot 4)
sf2pwrplay	= $2000	; power play in progress (93G sf2pwrplay 5)
sf2pwrtm	= $4000	; 0 for team 1 in power play (93G sf2pwrtm 6)
sf2offsig	= $8000	; offsides little ref on (93G sf2offsig 7)
; pflags bits (pflags2 bit n is bit n+10)
pfdoff		= $0001	; deceleration off (93G pfdoff 0)
pfna		= $0002	; new assignment (93G pfna 1)
pfjoycon	= $0008	; joystick controlled (93G pfjoycon 3)
pf2unav		= $1000	; unavailable (93G pflags2 bit 2)
pf2lcm		= $2000	; line change mode (93G pflags2 bit 3)
pf2pen		= $4000	; caused a penalty (93G pflags2 bit 4)
; tmflags bits
tmfmid		= $0002	; nearest player takes the spot between puck and own goal (93G tmflags bit 2)
; joypad (93G button bits)
cbut		= $0080	; shoot / check button in d2 (93G cbut, bit 5)
; rink
blueline	= $58	; 93G blueline
goalline	= $B0	; blueline+goalline = $108
; assignments (93G asstab numbers)
abench			= $0B	; 93G abench
apuckc			= $10	; 93G apuckc
anearest	= $11	; 93G anearest
ashoot			= $12	; 93G ashoot
apassrec	= $13	; 93G apassrec
; animations (offsets into the animation data; 93G value in the comment)
SPAgready	= $0002	; 93G SPAgready 2
SPAgskate	= $0344	; 93G SPAgskate $3F8
SPAglide	= $0478	; 93G SPAglide $52C
SPAstop		= $0672	; 93G SPAstop $6E6
SPAshotf	= $07A8	; 93G SPAshotf $81C
SPAshotb	= $08BA	; 93G SPAshotb $94E
SPAsweepchk	= $0A90	; 93G SPAsweepchk $B44
SPAburst	= $0BCA	; 93G SPAburst $C7E
; sounds (sfx numbers)
SFXstop		= $9C	; +0/1: skate stop (dostop, controlled player)
SFXshotwiff	= $98	; +0-3: missed shot (doshot)
SFXshotfh	= $8D	; forehand shot (93G $18)
SFXshotbh	= $8E	; backhand shot (93G $14)
SFXshothard	= $8F	; shot with passspeed >= $32

; --- addresses: puck fields (need puckobj above) ---
puckx		= Xpos+puckobj	; 93G puckx
pucky		= Ypos+puckobj	; 93G pucky
puckvx		= Xvel+puckobj	; 93G puckvx
puckvy		= Yvel+puckobj	; 93G puckvy
puckvz		= Zvel+puckobj	; 93G puckvz
puckc		= newpos+puckobj	; SCnum of the puck carrier, negative = loose. 93G puckc (puck newpos)
