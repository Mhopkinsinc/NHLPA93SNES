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
sndqin		= $1D	; sound command queue write index (bank $82 sfx queue at sndqueue, 8 words)
sndqout		= $1F	; sound command queue read index
sndlock		= $21	; nonzero while main code changes the sound command queue (bank $82); set by Start during sound init
sndqueue	= $23	; sound command queue (8 words)

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
tmp2		= $77	; scratch word
mula		= $7D	; multiply/divide operand A (32-bit with mula+2). Helpers: muls16, mulu (bank $8D/$88), muls (bank $82)
mulb		= $83	; multiply/divide operand B (32-bit with mulb+2)
mulres		= $93	; multiply result low word; mulres+2 ($95) = high word (68k swap)
mulsign		= $81	; divs: count of negative operands
mulcnt		= $87	; divs: bit loop count (16)
DMAListend	= $A3	; byte offset of the end of DMAList (7 bytes per entry); VBlank sends and empties it. 93G DMAListend
sprclock	= $A7	; sprite VRAM tile cache clock: a slot whose sprslottime is older than sprclock-sprslotlife is free
sprpriority	= $BB	; OAM attribute priority bits ORed into every game sprite ($20 at start)
sprslotlife	= $C1	; frames a sprite VRAM slot stays reserved after it was last used ($12 at start)
textdirtylo	= $D0	; lowest changed word of textmap (sent at the next vblank); $D2 = highest
textdirtyhi	= $D2	; highest changed word of textmap
crowdlevel	= $DE	; level of crowd excitement (+$50 per punch, +$258 for a won fight, +$C8 for a faceoff win). 93G crowdlevel
fobox		= $F4	; nonzero while the faceoff box is on screen (puckfaceoff2 .. Endfaceoff): SetLCmode2 keeps its area. 93G disflags bit 4

; $0100-$1FFF: absolute (DB = $80 mirrors bank $00 WRAM)
fodir1		= $0132	; pull direction of the home center on the faceoff (dpad, negative = none). 93G fodir1
fodir2		= $0134	; 93G fodir2
fodropx		= $0136	; faceoff box x (pixels). 93G fodropx
fodropy		= $0138	; faceoff box y. 93G fodropy
fofdata2	= $013A	; face off pull frame for the home ($013A) and visiting ($013E) center (assfaceoffp1). 93G fofdata2
fofdata		= $0142	; frame/attribute of the faceoff ref (big faceoff sprites). 93G fofdata
fox		= $0146	; faceoff spot x. 93G fox
foy		= $0148	; faceoff spot y. 93G foy
glovecords	= $014E	; x/y bytes of the dropped gloves (chkhit). 93G glovecords
Hpos		= $0154	; ice rink horizontal position. 93G Hpos
Hscroll		= $0156	; horizontal scroll: BG2HOFS = Hscroll+$C0 (VBlank). 93G Hscroll
iflags		= $015C	; icing flags (if* masks); high byte ($015D) = icingPlayer (SCnum). 93G iflags/icingPlayer
sfxretjml	= $0178	; RAM trampoline: $5C (jml opcode, set by Start); sfx writes its return address at +1..+3 and jumps here
carriedy	= $0181	; pucky while the puck is carried: the y a shot was taken from (puckgoalie)
lcplayer	= $0183	; SCnum of the player who opened the line change box ($FFFE = take the next one)
ltplayer	= $018B	; last touch player (SCnum). 93G ltplayer
ltx		= $018D	; last touch x. 93G ltx
lty		= $018F	; last touch y. 93G lty
mesarea		= $0191	; temp area for print strings (length word, then characters). 93G mesarea
lastplayer	= $017D	; SCnum of the last player who touched the puck (doshot). 93G lastplayer
Satt		= $01FF	; sprite attribute table (OAM shadow, $220 bytes), sent by VBlank. 93G Satt
printx		= $047B	; x cordinate for printing (text map column). 93G printx
printy		= $047D	; y cordinate for printing. 93G printy
goalcue		= $0429	; nonzero: home team just scored (lead 0-2): assfaceoff plays the goal music cue at the next faceoff
percue		= $042B	; nonzero: period just started: assfaceoff plays the period music cue
midpercue	= $042F	; gameclock value (half the period) at which assfaceoff plays the mid-period music cue (0 = done)
passdir		= $043B	; direction for pass/shot 0-7 (8 = none). 93G passdir
passspeed	= $043D	; speed of pass/shot. 93G passspeed
passReceiverPlayerNum	= $043F	; SCnum the last pass was aimed at (negative = none). 93G passReceiverPlayerNum
puckcross	= $0489	; 2 entries of (x, frames): where/when the puck crosses the top / bottom goal line ($FFFF frames = never). 93G puckcross
Oldrow		= $049B	; last rink map row (vertical scrolling of the map data; 999 = redraw all). 93G Oldrow
vramrow		= $049D	; BG2 tile map row (0-31) at the top of the ring buffer: BG2VOFS = vramrow*8 + (Vscroll&7)
rndb1		= $0491	; copy of seed byte 1 after each random (8-bit random for other code)
rndb2		= $0493	; high byte of the new seed after each random
seed		= $04A1	; 32-bit random seed (randomd0). 92 seed, 93G StanleyCupTimer. Its low bits also serve as a quick random
shotplayer	= $04A5	; SCnum of the player who shot last. 93G shotplayer
cuetimer	= $04A9	; frames left of a music cue; sfx are dropped while it runs
sprslottime	= $04AB	; 512 words: sprclock value when each 32-byte VRAM sprite tile slot was last used
threat		= $08D3	; direction of threat on puck handler (nonzero = threat). 93G threat
xc1		= $08F5	; scroll lock x (fight). 93G xc1
yc1		= $08F7	; scroll lock y. 93G yc1
yleader		= $08F9	; lead distance on scrolling. 93G yleader
Vpos		= $08DF	; ice rink vertical position. 93G Vpos
Vscroll		= $08E1	; vertical scroll (low 3 bits = BG2 fine scroll). 93G Vscroll

; Sort objects (93G SortCords): structure of arrays, one word per object, 16 objects ($20 bytes per field).
; Index with X/Y = SCnum*2. The 93G byte fields (pnum ... handed) are each a word array here.
; Fields from Xvel on are in the 93G struct order; the gaps are fields not met yet.
Xpos		= $08FF	; 93G Xpos (integer part)
frame		= $093F	; sprite frame number. 93G frame
Ypos		= $095F	; 93G Ypos (integer part)
Zpos		= $099F	; 93G Zpos (height)
attribute	= $09DF	; frame attribute bits (attrxflip, attryflip). 93G attribute
oldframe	= $09FF	; last frame. 93G oldframe
OldXpos		= $0A1F	; 93G OldXpos
OldYpos		= $0A5F	; 93G OldYpos
Xvel		= $0ADF	; 93G Xvel
Yvel		= $0AFF	; 93G Yvel
Zvel		= $0B1F	; 93G Zvel
impactp		= $0B3F	; last player to cause impact (SCnum). 93G impactp
position	= $0B9F	; player's position (0=goalie,1=l.def,2=r.def,3=l.wing,4=center,5=r.wing; negative = none). 93G position
assnum		= $0BBF	; index to current assignment (0-7). 93G assnum
asslist		= $0BDF	; list of assignments, 8 bytes per object: asslist+SCnum*8+assnum (index X*4+assnum). 93G asslist
temp1		= $0C5F	; 93G temp1
temp2		= $0C7F	; 93G temp2 (high byte as a byte counter: sub.b d7,temp2)
temp3		= $0C9F	; 93G temp3
temp4		= $0CBF	; 93G temp4
temp5		= $0CDF	; 93G temp5
temp2b		= $0CFF	; 93G temp2+1 (low byte; the port also uses it where 93G uses temp2 as a word: swing time, pass wait)
SCnum		= $0D9F	; index number of this object (X/2). 93G SCnum
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
passacc		= $101F	; 93G passacc (goalies: glove save right, 92 GGSright)
spodds		= $105F	; shot/pass odds. 93G spodds
stickhand	= $107F	; 93G stickhand
endurance	= $109F	; 93G endurance (goalies: stick save right, 92 GSSright)
GGSleft		= $10BF	; 93G byte $73: goalie glove save left (92 GGSleft)
fightagg	= $10DF	; fighting aggression (93G byte $74)
aggress		= $10FF	; 93G aggress ($75)
handed		= $111F	; nonzero: right handed (0 = lefty for the faceoff frames). 93G handed
pfgoal		= $113F	; nonzero: shoots at the top goal. 93G pflags bit pfgoal
pf2fight	= $115F	; nonzero: fighting. 93G pflags2 bit pf2fight
pfalock		= $117F	; nonzero: locked until the animation is done. 93G pflags bit pfalock
pfteam		= $119F	; 0 = home, nonzero = visitors. 93G pflags bit pfteam
pfrev		= $11BF	; nonzero: skating backwards. 93G pflags bit pfrev
pf2aip		= $11DF	; nonzero: animation in progress. 93G pflags2 bit pf2aip
pfnc		= $11FF	; nonzero: no collision mode. 93G pflags bit pfnc
Ylist		= $121F	; y of each sort object. 93G Ylist
OOlistpos	= $123F	; position of each object in OOlist. 93G OOlistpos
OOlist		= $125F	; 16 bytes: object order list, bottom of the screen last. 93G OOlist
pspeed		= $126F	; |Xvel|+|Yvel| after a burst (SNES only, read by the hit code)

; Game state
gmode		= $1288	; game mode flags (gm* masks). 93G gmode
gmclock		= $128A	; nonzero: game clock is stopped. 93G gmode bit gmclock
sflags		= $128C	; 93G sflags (low byte) and sflags2 (high byte) as one word (sf*/sf2* masks)
sfhormode	= $128E	; nonzero: screen in horizontal mode. 93G sflags bit sfhor
sflags3		= $1290	; 93G sflags3 (sf3* masks)
c1playernum	= $1292	; player on controller 1 (negative = none). 93G c1playernum
c2playernum	= $1294	; 93G c2playernum
cont1team	= $1296	; team on controller 1 (0 none, 1 home, 2 away). 93G cont1team
cont2team	= $1298	; 93G cont2team
PenaltyBufferEnd	= $129C	; penalty list base: entries (penalty byte, player byte) start at +2. 93G PenaltyBufferEnd
Pencntdwn	= $12E0	; penalty/fight count down (negative = fight over). 93G Pencntdwn
InjCntDown	= $12E6	; 93G InjCntDown
RefCnt		= $12EA	; ref graphics control (negative = idle). 93G RefCnt
gsp		= $12F0	; game period. 93G gsp
gameclock	= $12F2	; game clock seconds; gameclock+2 = jiffies (-$AAA per frame). 93G gameclock

; Team structs (93G hmtmstruct / awtmstruct): word arrays indexed by a2 (0 home, 2 away)
tmdata		= $13CE	; team data address (bank $83). 93G tmdata
tmsort		= $13D2	; first object index of the team. 93G tmsort
tmscore		= $13D6	; score. 93G tmscore
tmfowon		= $13DA	; faceoffs won (93G team word $E)
tmline		= $13DE	; current line. 93G tmline
tmtouch1	= $13E2	; pnum of the last touch (93G team word $18)
tmtouch2	= $13E6	; second last touch (93G $1A)
tmtouch3	= $13EA	; third last touch (93G $1C)
tmap		= $13EE	; active players on ice. 93G tmap
tmnear		= $13FA	; 32-bit (tmnear = low word, +4 = high word): nearest distance^2 to the puck (assnearest). 93G team long $2A
tmpasscomp	= $1406	; completed passes (93G team word $14)
tmflags		= $140A	; team flags. 93G tmflags
tmlcchoice	= $140E	; line change box row chosen (0-2). 93G team word $2E
tmpde		= $147A	; energy of each roster player (word per player, +$34 for team 2). 93G tmpde
tmpdst		= $14E2	; bench/ice/box state of each roster player (+$34 for team 2). 93G tmpdst

; Options
OptPen		= $160A	; penalties (0 = off). 93G OptPen
OptLine		= $160C	; line changes (0 = on). 93G OptLine

DMAList		= $1653	; vram dma list (7-byte entries, see dma* offsets), filled up to DMAListend. 93G DMAList
charofs		= $1BCD	; added to every text map tile written by the game code ($FF00 at boot, 0 in the game screens)
faceoffvrcset	= $1BD9	; vram tiles for the faceoff box. 93G faceoffvrcset
blankchar	= $1BE7	; vram tile of the blank character (93G uses tile $7FF)

; Bank $7E
sprframetime	= $7E2000	; 4 bytes per sprite frame: sprclock when its tiles were last sent (sprite VRAM tile cache)
palbuffer	= $7E6C74	; CGRAM shadow (256 colors, 512 bytes): VBlank_Cram sends it. 93G palbuffer role
textmap		= $7E6E74	; text layer tile map buffer (32x32 words); textdirtylo/hi mark what to send

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
gmdir		= $0002	; 0 = home team goes up (93G gmdir 1)
gmpendel	= $0008	; delayed penalty has been called (93G gmpendel 3)
gmhl		= $0010	; hilight mode (93G gmhl 4)
gmoffs		= $0020	; offsides on (93G gmoffs 5)
gmendper	= $0040	; end the period at the next faceoff (93G gmode bit 6)
; sflags (low byte = 93G sflags, high byte = 93G sflags2)
sfpz		= $0001	; pause mode (93G sfpz 0)
sfspdir		= $0004	; set pass dir mode (93G sfspdir 2)
sfssdir		= $0008	; set shot dir mode (93G sfssdir 3)
sfslock		= $0040	; scroll lock to xc1/yc1 (93G sfslock 6)
sf2faceoff	= $0100	; face off in progress (93G sf2faceoff 0)
sf2refref	= $0200	; ref needs refresh (93G sf2refref 1)
sf2drec		= $0400	; disable replay record (93G sf2drec 2)
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
pf2npc		= $8000	; no player collision (93G pflags2 bit 5)
pf2inj		= $0004	; injured (93G pflags2 bit 6, kept in pflags bit 2 here)
; sflags3 bits
sf3llcs		= $0001	; lower line change box on screen (93G sf3llcs 0)
sf3fo		= $0010	; face off just ended: the next puck pickup wins it (93G sflags3 bit 4)
; iflags bits
ifcgl		= $0001	; puck crossed the goal line (93G ifcgl 0)
ifdir		= $0002	; icing toward the top goal (93G ifdir 1)
ifok		= $0004	; icing possible (93G ifok 2)
; attribute bits
attrxflip	= $0800	; x flip (93G attribute bit 3)
attryflip	= $1000	; y flip (93G attribute bit 4)
; tmflags bits
tmfmid		= $0002	; nearest player takes the spot between puck and own goal (93G tmflags bit 2)
tmflast		= $0004	; next touch overwrites the last touch only (93G tmflags bit 3)
tmflc		= $0008	; team in line change mode (93G tmflags bit 1)
tmfoffside	= $0010	; team offsides (93G tmflags bit 4)
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
afaceoff	= $16	; 93G afaceoff
afaceoffpl	= $17	; 93G afaceoffpl (assfaceoffp1)
pnorm		= $18	; 93G pnorm (pucknorm)
pfaceoff2	= $1C	; 93G pfaceoff2
; penalties (93G PenaltyList numbers)
PenHold6	= $06	; loose puck not moving for 120 calls (93G AddPenalty2 d0 = 6)
PenIcing	= $0C	; 93G PenIcing
PenOffsides	= $10	; 93G PenOffsides
PenFight	= $26	; penalty byte of a fight in the penalty list (93G $26)
PenFighting	= $28	; fighting (93G PenFighting $28)
; animations (offsets into the animation data; 93G value in the comment)
SPAgready	= $0002	; 93G SPAgready 2
SPAgskate	= $0344	; 93G SPAgskate $3F8
SPAglide	= $0478	; 93G SPAglide $52C
SPAstop		= $0672	; 93G SPAstop $6E6
SPAshotf	= $07A8	; 93G SPAshotf $81C
SPAshotb	= $08BA	; 93G SPAshotb $94E
SPAsweepchk	= $0A90	; 93G SPAsweepchk $B44
SPAburst	= $0BCA	; 93G SPAburst $C7E
SPAfight	= $0EDA	; 93G SPAfight $F8E
SPAfgrab	= $0F0C	; 93G SPAfgrab $FC0
SPAfheld	= $0F2E	; 93G SPAfheld $FE2
SPAfhigh	= $0F50	; 93G SPAfhigh $1004
SPAflow		= $0F82	; 93G SPAflow $1036
SPAfhith	= $0FB4	; 93G SPAfhith $1068
SPAfhitl	= $0FD6	; 93G SPAfhitl $108A
SPAbfall	= $0FF8	; 93G SPAbfall $10AC
SPAfaceoff	= $1096	; 93G SPAfaceoff $11A4
SPAfaceoffr	= $10C0	; 93G SPAfaceoffr $11CE
SPAffall	= $1156	; 93G SPAffall $10CE
SPAg314		= $1490	; goalie animation (93G SPA $314: temp5 = 5 instead of 140 after a save)
SPAslowhit	= $1418	; player hit by a slow puck (93G SPA $128A)
; sprite frames (93G SPF numbers, same values)
SPFfight	= $0162	; first fight frame (93G SPFfight)
SPFpuck		= $0189	; puck frame (93G SPFpuck $18A)
SPFgoalie	= $0283	; first goalie frame (93G SPFgoalie $197)
; sounds (sfx numbers)
SFXstop		= $9C	; +0/1: skate stop (dostop, controlled player)
SFXshotwiff	= $98	; +0-3: missed shot (doshot)
SFXshotfh	= $8D	; forehand shot (93G $18)
SFXshotbh	= $8E	; backhand shot (93G $14)
SFXshothard	= $8F	; shot with passspeed >= $32
SFXcrowdcheer	= $8A	; home player won the fight (93G song $B)
SFXcrowdboo	= $8B	; visitor won the fight (93G song $C)
SFXhithigh	= $92	; 93G SFXhithigh 9
SFXhitlow	= $93	; 93G SFXhitlow $A
SFXpuckbody	= $90	; +0/1: puck hits a body (93G $24)
SFXsavehome	= $8A	; hard shot saved by the home goalie (93G song $B)
SFXsaveaway	= $8C	; hard shot saved by the visiting goalie (93G song $D)
; injury
INJfight	= $112C	; tmpdst value for a player injured in a fight (93G $112C)

; --- addresses: puck fields (need puckobj above) ---
puckx		= Xpos+puckobj	; 93G puckx
pucky		= Ypos+puckobj	; 93G pucky
puckvx		= Xvel+puckobj	; 93G puckvx
puckvy		= Yvel+puckobj	; 93G puckvy
puckvz		= Zvel+puckobj	; 93G puckvz
puckc		= newpos+puckobj	; SCnum of the puck carrier, negative = loose. 93G puckc (puck newpos)
