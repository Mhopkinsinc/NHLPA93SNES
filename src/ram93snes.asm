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
farptr		= $0C	; long pointer ($0C-$0E) to a frame set table (addframe, addframe_hi)
sprtileptr	= $0F	; addframe: long pointer to the tiles of the frame set ($0F-$11)
vbactive	= $12	; nonzero while the vbint handler runs (or while main code holds vblank off): VBjsr skips it
vbint		= $14	; address (bank $80) of the vblank handler VBjsr jumps to. 93G vbint
hbint		= $16	; address (bank $80) of the H/V-timer IRQ handler HBjsr jumps to. Default HBdefault
hcount		= $18	; +1 per IRQ that is not a timer IRQ (HBdefault); cleared every vblank
sndptr		= $1A	; long pointer to the SPC upload stream ($1A-$1C, bank in $1C)
sndqin		= $1D	; sound command queue write index (bank $82 sfx queue at sndqueue, 8 words)
sndqout		= $1F	; sound command queue read index
sndlock		= $21	; nonzero while main code changes the sound command queue (bank $82); set by Start during sound init
sndqueue	= $23	; sound command queue (8 words)

; Direct page $33-$72: the 68k registers of the port. Each is 4 bytes (long); word code uses the low word.
a0		= $33	; 68k a0: object index (SCnum*2) or long pointer [a0] (a0+2 = bank)
a1		= $37	; 68k a1
a2		= $3B	; 68k a2: team index, 0 = home (hmtmstruct), 2 = away (awtmstruct)
a3		= $3F	; 68k a3: current object index (SCnum*2); X normally holds the same value
a4		= $43	; 68k a4 (long pointer, e.g. PlList)
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
mulneg		= $98	; muls32: count of negative operands
mulsign		= $81	; divs: count of negative operands
mulcnt		= $87	; divs: bit loop count (16)
DMAListend	= $A3	; byte offset of the end of DMAList (7 bytes per entry); VBlank sends and empties it. 93G DMAListend
sprclock	= $A7	; sprite VRAM tile cache clock: a slot whose sprslottime is older than sprclock-sprslotlife is free
sprpriority	= $BB	; OAM attribute priority bits ORed into every game sprite ($20 at start)
sprflag		= $AB	; addframe parameter: $8000 = attribute bit 0 / the second faceoff sprite (cleared by addframe)
sprframe	= $C3	; addframe parameter: sprite frame number (1-based)
sprsetofs	= $C5	; addframe: first frame number of the frame set that holds sprframe
sprnodraw	= $C7	; addframe: nonzero: draw nothing
sprx		= $C9	; addframe parameter: screen x of the frame
spry		= $CB	; addframe parameter: screen y
sprhflip	= $A5	; addframe parameter: $0800 = x flip (attribute bit 11)
sprvflip	= $CD	; addframe parameter: $1000 = attribute bit 12
sprcount	= $A9	; addframe: next OAM entry (sprite count this frame)
sprpal		= $AD	; addframe: palette bits of the piece
sprpattr	= $AF	; addframe: flip bits of the piece ($C0)
sprbigslot	= $B1	; addframe: VRAM slot rotor for 16x16 sprites
sprbigslotend	= $B3	; addframe: rotor stop: all big slots in use
sprslot		= $B5	; addframe: VRAM slot rotor for 8x8 sprites
sprslotend	= $B7	; addframe: rotor stop: all small slots in use
sprtile		= $B9	; addframe: VRAM tile of the piece
sprox		= $BD	; addframe: OAM x of the piece (bit 8 in $BE)
sproy		= $BF	; addframe: OAM y of the piece
sprslotlife	= $C1	; frames a sprite VRAM slot stays reserved after it was last used ($12 at start)
textdirtylo	= $D0	; lowest changed word of textmap (sent at the next vblank); $D2 = highest
textdirtyhi	= $D2	; highest changed word of textmap
printm		= $D4	; byte offset of the print map in textmap (map number from the print control code). 93G printm
collflag	= $D8	; a player collision happened: checkcoll restores the old position. 93G collflag
crowdcnt	= $DA	; count down to the next crowd animation step. 93G crowdcnt
crowdframe	= $DC	; crowd frame: low byte = random extra frame (loud crowd), high byte ($DD) = frame from cd0. 93G crowdframe
crowdlevel	= $DE	; level of crowd excitement (+$50 per punch, +$258 for a won fight, +$C8 for a faceoff win). 93G crowdlevel
crowdstep	= $E0	; animation step for the crowd (0-$1E). 93G crowdstep
bosgames	= $D6	; 0-6 game of the best of seven series, 7 = single games. 92G bosgames
deltax		= $EA	; avdgoal: x correction around the goal. 93G deltax
deltay		= $EC	; avdgoal: y correction. 93G deltay
impactstep	= $E2	; d7*2: impact decay this game frame (game loop)
velstep		= $E4	; d7*16: velocity to position scale this game frame (93G d4 in updateplayers)
gravstep	= $E6	; d7*96: gravity this game frame (93G 2*d4 + 4*d4)
d7x1024		= $E8	; d7*1024, set with the other time steps (no reader found yet)
ThirdPBonus	= $F0	; setplayer: +2 when tied or trailing late in the 3rd period. 93G ThirdPBonus
evalue		= $F2	; elasticity value of a player collision (0-16). 93G evalue
pausetimer	= $EE	; pause menu: frames left before a demo pause ends by itself (60000)
fobox		= $F4	; nonzero while the faceoff box is on screen (puckfaceoff2 .. Endfaceoff): SetLCmode2 keeps its area. 93G disflags bit 4
ffoattr		= $F6	; 5 words: attribute of the ffo objects (pads 0-3, gloves). 93G ffo attribute

; $0100-$1FFF: absolute (DB = $80 mirrors bank $00 WRAM)
ffoframe	= $0100	; 5 words: frame of the objects tied to rink scrolling (pads 0-3, gloves at +8). 93G ffo frame (92 ffo)
ffoxofs		= $010A	; 5 words: ffo x offset of the label sprites (93G ffo 2(a3))
ffox		= $0114	; 5 words: ffo x. 93G ffo Xpos
ffoy		= $011E	; 5 words: ffo y
ffoz		= $0128	; 5 words: ffo z ($FFFF = hidden)
fodir1		= $0132	; pull direction of the home center on the faceoff (dpad, negative = none). 93G fodir1
fodir2		= $0134	; 93G fodir2
fodropx		= $0136	; faceoff box x (pixels). 93G fodropx
fodropy		= $0138	; faceoff box y. 93G fodropy
fofdata2	= $013A	; face off pull frame for the home ($013A) and visiting ($013E) center (assfaceoffp1). 93G fofdata2
fofdata		= $0142	; frame/attribute of the faceoff ref (big faceoff sprites). 93G fofdata
fox		= $0146	; faceoff spot x. 93G fox
foy		= $0148	; faceoff spot y. 93G foy
glovecords	= $014E	; x/y bytes of the dropped gloves (chkhit). 93G glovecords
cheercnt	= $0150	; crowd cheers still to play after a goal (SFXcrowdcheer every 150 frames, Gameloop)
cheervc		= $0152	; vcount of the last crowd cheer
tickerstart	= $0158	; TickerNum at the start of the intermission (IntermissionTick: all shown when it comes round again)
Hpos		= $0154	; ice rink horizontal position. 93G Hpos
Hscroll		= $0156	; horizontal scroll: BG2HOFS = Hscroll+$C0 (VBlank). 93G Hscroll
HmAwBonus	= $015A	; setplayer: home bonus / visitor penalty. 93G HmAwBonus
iflags		= $015C	; icing flags (if* masks); high byte ($015D) = icingPlayer (SCnum). 93G iflags/icingPlayer
joypad1		= $015E	; controller 1 buttons (SNES joypad bits, JOY* masks)
joypad2		= $0160	; controller 2 buttons
joypad3		= $0162	; controller 3 buttons (multitap)
joypad4		= $0164	; controller 4 buttons
padlast1	= $0166	; 4 words: buttons at the last ReadPads (joypad1-4)
padnew1		= $016E	; 4 words: buttons newly pressed at the last ReadPads (joypad1-4)
padvcount	= $0176	; vcount of the last ReadPads (the pads are read once per frame)
jmlvector	= $0178	; RAM jml trampoline: $5C (jml opcode, set by Start), target at +1..+3. sfx returns through it, updateplayers calls the assignment through it
lastsfx		= $017F	; last sound effect requested. 93G lastsfx
carriedy	= $0181	; pucky while the puck is carried: the y a shot was taken from (puckgoalie)
lcplayer	= $0183	; SCnum of the player who opened the line change box ($FFFE = take the next one)
lj1		= $0185	; last controller 1 buttons (debounce). 93G lj1
lj2		= $0187	; 93G lj2
lldisp		= $0189	; count down for the once-a-second screen/game updates ($18 frames). 93G lldisp
ltplayer	= $018B	; last touch player (SCnum). 93G ltplayer
ltx		= $018D	; last touch x. 93G ltx
lty		= $018F	; last touch y. 93G lty
gamelevel	= $014A	; 0-3: depth into the playoff tree (4 = finished). 93G gamelevel
gamenum		= $014C	; index of the user game in the playoff game arrays (-1 = none). 93G gamenum
mesarea		= $0191	; temp area for print strings (length word, then characters). 93G mesarea
lastplayer	= $017D	; SCnum of the last player who touched the puck (doshot). 93G lastplayer
PushWidthBuf	= $01F5	; PushNumberWidth string: length word (digits + 2), then the digits right aligned, spaces before (8 chars to $01FE). 93G PushWidthBuf
Satt		= $01FF	; sprite attribute table (OAM shadow, $220 bytes), sent by VBlank. 93G Satt
SattHi		= $03FF	; OAM high table shadow (x bit 8 and size, 2 bits per sprite)
printx		= $047B	; x cordinate for printing (text map column). 93G printx
printy		= $047D	; y cordinate for printing. 93G printy
PadControlBits	= $0431	; SCnum nibbles of the pad-controlled players ($FFFF = none). 93G PadControlBits
psitem		= $0485	; pause menu item (0-4). 92G psitem
sprpieces	= $0487	; addframe: pieces left in the frame
padcont		= $0433	; 4 words. 93G padcont
nibblebuffer	= $041F	; 4 words: the weights WeightedRandomSelect picks from (SetScore). 93G nibblebuffer
oldvcount	= $0427	; vcount at the last game frame (d7 = vcount - oldvcount). 93G oldvcount
goalcue		= $0429	; nonzero: home team just scored (lead 0-2): assfaceoff plays the goal music cue at the next faceoff
percue		= $042B	; nonzero: period just started: assfaceoff plays the period music cue
p3cue		= $042D	; third period: frames until StartSong3 plays its music cue (set by StartPer, 0 = done)
midpercue	= $042F	; gameclock value (half the period) at which assfaceoff plays the mid-period music cue (0 = done)
passdir		= $043B	; direction for pass/shot 0-7 (8 = none). 93G passdir
passspeed	= $043D	; speed of pass/shot. 93G passspeed
passReceiverPlayerNum	= $043F	; SCnum the last pass was aimed at (negative = none). 93G passReceiverPlayerNum
PKBonus		= $0441	; setplayer: penalty kill bonus (negative). 93G PKBonus
PlList		= $0443	; 12 bytes: wanted roster players (6), then their positions (6). 93G PlList
pojoy		= $044F	; playoff joystick indicator (2+: two players). 92G POJoy (93G playoffroundoffset)
postarts	= $0451	; 0-31: playoff tree layout; negative after DecodePW = bad password. 93G postarts
potree		= $0453	; 32 bytes: team in each playoff tree slot (16+8+4+2+1+1). 93G potree
potreeteam	= $0473	; the user's slot in the first playoff round. 93G potreeteam
PPBonus		= $0475	; setplayer: power play bonus. 93G PPBonus
printa		= $0477	; attribute (palette/priority bits) for print characters. 93G printa
printfont	= $0479	; font number (0-3) from the print control code
puckcross	= $0489	; 2 entries of (x, frames): where/when the puck crosses the top / bottom goal line ($FFFF frames = never). 93G puckcross
repeatdelay	= $0499	; ProcessInputWithRepeat: frames to the next key repeat
ReplayBufferPtr	= $0495	; long pointer to the next replay frame record (bank $7E, wraps at $7EFF41 to $7E8174). 93G ReplayBufferPtr
Oldrow		= $049B	; last rink map row (vertical scrolling of the map data; 999 = redraw all). 93G Oldrow
vramrow		= $049D	; BG2 tile map row (0-31) at the top of the ring buffer: BG2VOFS = vramrow*8 + (Vscroll&7)
rndb1		= $0491	; copy of seed byte 1 after each random (8-bit random for other code)
rndb2		= $0493	; high byte of the new seed after each random
seed		= $04A1	; 32-bit random seed (randomd0). 92 seed, 93G StanleyCupTimer. Its low bits also serve as a quick random
sfxmutetime	= $04A7	; vcount when sound effects were cut off: sfx are dropped for 180 frames after it
shotplayer	= $04A5	; SCnum of the player who shot last. 93G shotplayer
sndsettle	= $049F	; set to 10 after the in-game sample upload: p_music_vblank sends no commands until it counts down
cuetimer	= $04A9	; frames left of a music cue; sfx are dropped while it runs
sprslottime	= $04AB	; 512 words: sprclock value when each 32-byte VRAM sprite tile slot was last used
colorflag1	= $08B7	; cleared by setplayercolors (no reader found)
colorflag2	= $08B9	; cleared by setplayercolors (no reader found)
TickerNum	= $08D7	; playoff game the score ticker shows next. 93G TickerNum
tickervc	= $08D9	; vcount when the ticker box was last shown (Intermission: next one after $150 frames)
ssoattr		= $08AB	; 4 words: attribute of the off-screen arrow objects (93G sso, checksso; field roles by analogy with ffo)
ssoframe	= $08B3	; 4 words: sso frame
ssoz		= $08BB	; 4 words: sso z ($FFFF = hidden)
ssox		= $08C3	; 4 words: sso x
ssoy		= $08CB	; 4 words: sso y
threat		= $08D3	; direction of threat on puck handler (nonzero = threat). 93G threat
demoflag	= $08D5	; nonzero in demo mode (pause ends by itself when no controller has a team). 93G demoflag
PlayerScrollCtr	= $08E9	; scouting text: offset of the next word in the paragraph (negative = next paragraph). 93G PlayerScrollCtr
screentimer	= $08EB	; frames left on the scouting report screen. 93G screentimer
SelectedPlayerIdx	= $08ED	; scouting text: TestList index. 93G SelectedPlayerIdx
ScoutingReportTimer	= $08EF	; frames to the next word ($7FFF = text finished). 93G ScoutingReportTimer
DispAttribCtr	= $08F1	; scouting text column. 93G DispAttribCtr
VertLineScrolling	= $08F3	; scouting text line (0-6). 93G VertLineScrolling
xc1		= $08F5	; scroll lock x (fight). 93G xc1
yc1		= $08F7	; scroll lock y. 93G yc1
yleader		= $08F9	; lead distance on scrolling. 93G yleader
vcountmark	= $08FB	; 32-bit vcount snapshot: elapsed time base (setupice sets it 2*$10000 frames back)
lastframevc	= $08DB	; vcount at the last replay frame shown (ReplayMode, bank $8F); not read
zamx		= $08DD	; cleared by setupice (93G st zamx: zamboni x cord)
Vpos		= $08DF	; ice rink vertical position. 93G Vpos
Vscroll		= $08E1	; vertical scroll (low 3 bits = BG2 fine scroll). 93G Vscroll
wcradiusx	= $08E3	; wall collision radius x. 93G wcradiusx
wcradiusy	= $08E5	; wall collision radius y. 93G wcradiusy
WinBits		= $08E7	; bits of the teams that go on in the playoff tree. 93G WinBits

; Sort objects (93G SortCords): structure of arrays, one word per object, 16 objects ($20 bytes per field).
; Index with X/Y = SCnum*2. The 93G byte fields (pnum ... handed) are each a word array here.
; Fields from Xvel on are in the 93G struct order; the gaps are fields not met yet.
Xpos		= $08FF	; 93G Xpos (integer part)
Xfrac		= $091F	; fraction of Xpos (93G Xpos low word)
frame		= $093F	; sprite frame number. 93G frame
Ypos		= $095F	; 93G Ypos (integer part)
Yfrac		= $097F	; fraction of Ypos
Zpos		= $099F	; 93G Zpos (height)
Zfrac		= $09BF	; fraction of Zpos
attribute	= $09DF	; frame attribute bits (attrxflip, attryflip). 93G attribute
oldframe	= $09FF	; last frame. 93G oldframe
OldXpos		= $0A1F	; 93G OldXpos
OldXfrac	= $0A3F	; 93G OldXpos low word
OldYpos		= $0A5F	; 93G OldYpos
OldYfrac	= $0A7F
OldZpos		= $0A9F	; 93G OldZpos
OldZfrac	= $0ABF
Xvel		= $0ADF	; 93G Xvel
Yvel		= $0AFF	; 93G Yvel
Zvel		= $0B1F	; 93G Zvel
impactp		= $0B3F	; last player to cause impact (SCnum). 93G impactp
limpact		= $0B5F	; last impact value. 93G limpact
impact		= $0B7F	; impact value. 93G impact
position	= $0B9F	; player's position (0=goalie,1=l.def,2=r.def,3=l.wing,4=center,5=r.wing; negative = none). 93G position
assnum		= $0BBF	; index to current assignment (0-7). 93G assnum
asslist		= $0BDF	; list of assignments, 8 bytes per object: asslist+SCnum*8+assnum (index X*4+assnum). 93G asslist
temp1		= $0C5F	; 93G temp1
temp2		= $0C7F	; 93G temp2 (high byte as a byte counter: sub.b d7,temp2)
temp3		= $0C9F	; 93G temp3
temp4		= $0CBF	; 93G temp4
temp5		= $0CDF	; 93G temp5
temp2b		= $0CFF	; 93G temp2+1 (low byte; the port also uses it where 93G uses temp2 as a word: swing time, pass wait)
radiusx		= $0D1F	; width of this graphic (wall collision). 93G radiusx
radiusy		= $0D3F	; 93G radiusy
Wallcos		= $0D5F	; cos of the angle of the last wall collision. 93G Wallcos
Wallsin		= $0D7F	; 93G Wallsin
SCnum		= $0D9F	; index number of this object (X/2). 93G SCnum
facedir		= $0DBF	; direction of facing 0-7. 93G facedir
facefrac	= $0DDF	; turn fraction of facedir: doplayeracc adds the turn rate here and carries into facedir. 93G facedir.l low word
SPA		= $0DFF	; current animation (offset into the animation data). 93G SPA
SPAnum		= $0E1F	; index into animation (4 per frame). 93G SPAnum
SPAcnt		= $0E3F	; count down to the next animation frame (-1 = restart). 93G SPAcnt
nopuck		= $0E5F	; no puck collision until zero. 93G nopuck
nopuckb		= $0E7F	; second count down (93G byte $5F)
newpos		= $0E9F	; requested next position (negative = none). 93G newpos
newpnum		= $0EBF	; requested next roster player (negative = none). 93G newpnum
pflags		= $0EDF	; 93G pflags (bits 0-7) and pflags2 (bit n at bit n+10); some flags have their own arrays below
pnum		= $0F1F	; player's team location number (low byte). 93G pnum
weight		= $0F3F	; 93G weight
legstr		= $0F5F	; 93G legstr
legspd		= $0F7F	; 93G legspd
aioff		= $0F9F	; 93G aioff
aidef		= $0FBF	; 93G aidef
shotspd		= $0FDF	; 93G shotspd
shotacc		= $0FFF	; 93G shotacc
passacc		= $101F	; 93G passacc (goalies: glove save right, 92 GGSright)
spodds		= $105F	; shot/pass odds. 93G spodds
rostnum		= $103F	; 93G rostnum
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
HomeTeam	= $129A	; home team number (TeamList index). 93G HomeTeam
VisTeam		= $129C	; visiting team number. 93G VisTeam
PenBuf		= $129E	; up to 32 penalties: (penalty number, SCnum) byte pairs, 0 = free. 93G PenBuf
PenaltyBufferEnd	= PenBuf-2	; the word before PenBuf, used as the list base. 93G PenaltyBufferEnd
Pencntdwn	= $12E0	; penalty/fight count down (negative = fight over). 93G Pencntdwn
pentimer	= $12E2	; frames to the next penalty clock second (updatepentime, 24 per second)
PBnum		= $12E4	; players in the penalty boxes: home*16 + visitors. 93G PBnum
InjCntDown	= $12E6	; 93G InjCntDown
penmsgtimer	= $12E8	; count down to reprinting the horizontal penalty message line ($7FFF = never). 93G penmsgtimer
RefCnt		= $12EA	; ref graphics control (negative = idle). 93G RefCnt
RefStep		= $12EC	; step in the ref animation (negative = done). 93G RefStep
RefPen		= $12EE	; penalty number of the ref animation. 93G RefPen
ChkCnt		= $12F8	; checks since the last fight (fight chance). 93G ChkCnt
TempPlOffset	= $12FA	; pnum of the penalized player | $8000 for the visitors (InProgress). 93G TempPlOffset
ScoreSumbytes	= $12FC	; bytes used in ScoreSum (6 per goal, max $B4). 93G ScoreSumbytes
ScoreSum	= $12FE	; goal log: time word, (2+tmap diff | $80 away), scorer, assist, assist. 93G ScoreSum
gsp		= $12F0	; game period. 93G gsp
gameclock	= $12F2	; game clock seconds; gameclock+2 = jiffies (-$AAA per frame). 93G gameclock
PerTimeTotal	= $12F6	; length of this period (seconds). 93G PerTimeTotal

; Team structs (93G hmtmstruct / awtmstruct): word arrays indexed by a2 (0 home, 2 away)
tmshots		= $13B2	; shots stat. 93G tmshots
tmPwrGoals	= $13B6	; power play goals stat. 93G tmPwrGoals
tmPwrPlays	= $13BA	; power plays stat. 93G tmPwrPlays
tmPenalties	= $13BE	; penalties stat. 93G tmPenalties
tmPenmin	= $13C2	; penalty minutes stat. 93G tmPenmin
tmATOP		= $13CA	; attack zone time stat (seconds). 93G tmATOP
tmdata		= $13CE	; team data address (bank $83). 93G tmdata
tmsort		= $13D2	; first object index of the team. 93G tmsort
tmscore		= $13D6	; score. 93G tmscore
tmfowon		= $13DA	; faceoffs won (93G team word $E)
tmline		= $13DE	; current line. 93G tmline
tmtouch1	= $13E2	; pnum of the last touch (93G team word $18)
tmtouch2	= $13E6	; second last touch (93G $1A)
tmtouch3	= $13EA	; third last touch (93G $1C)
tmap		= $13EE	; active players on ice. 93G tmap
tmgoalie	= $13F2	; goalie: low byte = goalie 0/1, $FFxx = pulled (xx = goalie to return, $FF = stays out). 93G tmgoalie
tmteam		= $13F6	; team number (TeamList index) of the team struct (93G team struct byte $28, set by setteams)
tmnear		= $13FA	; 32-bit (tmnear = low word, +4 = high word): nearest distance^2 to the puck (assnearest). 93G team long $2A
tmchecks	= $1402	; checks stat (93G team word $10)
tmpasscomp	= $1406	; completed passes (93G team word $14)
tmflags		= $140A	; team flags. 93G tmflags
tmlcchoice	= $140E	; line change box row chosen (0-2). 93G team word $2E
tmgoals		= $1412	; goals per roster player (bytes, +$1A for team 2; 93G team bytes $B4)
pchecks		= $1446	; checks per roster player (bytes, +$1A for team 2; 93G team bytes $11C)
tmpde		= $147A	; energy of each roster player (word per player, +$34 for team 2). 93G tmpde
tmpdst		= $14E2	; bench/ice/box state of each roster player (+$34 for team 2). 93G tmpdst
tmboxlist	= $154A	; penalty box list of roster players (bytes, +$1A for team 2, negative ends; 93G team bytes $9A)
gst1		= $157F	; playoff games: one word per game (8) for each 93G gstruct field. 93G gst1 (team 1)
gst2		= $158F	; 93G gst2 (team 2)
gspotwins	= $159F	; 93G gspotwins
gspobwins	= $15AF	; 93G gspobwins
gsper		= $15BF	; 93G gsper (period)
gss1		= $15CF	; 93G gss1 (team 1 score)
gss2		= $15DF	; 93G gss2
gsflags		= $15EF	; 93G gsflags (gsf* masks)

; Options
OptPlayMode	= $1600	; play mode (0 regular season, 1 continue playoffs, 2/3 new playoffs). 93G OptPlayMode
OptPlayers	= $1602	; 93G players option
OptTeam1	= $1604	; 93G team 1
OptTeam2	= $1606	; 93G team 2
OptPerlen	= $1608	; period length index. 93G OptPerlen
PassWord	= $1610	; 16 password characters (indexes into PasstoText; bit 7 hides it). 92G PassWord
OptPen		= $160A	; penalties (0 = off). 93G OptPen
asv		= $1644	; scouting text without delays (down pressed). 93G asv
crowdvol	= $1646	; crowd noise volume last sent to the sound driver (updatesound)
cheatpads	= $1648	; 3 words: the last three new pad presses (the unreached Gameloop .cheat)
passbits	= $1624	; password bits: a 128-bit number, 8 words, low word first (SuperDiv, PushBits). 92G PassBits
tpassbits	= $1634	; 8 words: passbits before all games are resolved (EncodePW, sf3alttree). 92G tpassbits
OptLine		= $160C	; line changes (0 = on). 93G OptLine
notdemo		= $160E	; $FFFF once a player set up the game, 0 after the attract demo (FigureJoy: no controller teams). 92G demoflag role

sndbank		= $164F	; sound set loaded into the SPC (1 = the in-game sounds); sfx are queued only for it
cursong		= $1651	; song playing on the SPC (0 = none); set by the song starters in banks $86/$89
DMAList		= $1653	; vram dma list (7-byte entries, see dma* offsets), filled up to DMAListend. 93G DMAList
printfontset	= $1BCB	; tile base of the selected print font (control code). 93G printfontset
charofs		= $1BCD	; added to every text map tile written by the game code ($FF00 at boot, 0 in the game screens)
charofs2	= $1BCF	; second tile offset: cleared with charofs by the screen setups (bank $8F adds it at $8FE904)
BigFontChars	= $1BD1	; vram tiles for the big font. 93G BigFontChars
unusedchars	= $1BD3	; 14 tiles after the faceoff box; set by setupice, not read
ExtraChars	= $1BD5	; first free vram tile after the text tiles. 93G ExtraChars
smallfontchars	= $1BD7	; vram tiles for the small font (print). 93G smallfontchars
faceoffvrcset	= $1BD9	; vram tiles for the faceoff box. 93G faceoffvrcset
Framercset	= $1BDB	; vram tiles for the Framer box. 93G Framercset
logochars	= $1BDD	; vram tiles for the NHLPA logo (game setup and playoff screens, packed at $8C8000)
refcharshor	= $1BDF	; vram tiles for the little ref (horizontal rink)
refchars	= $1BE1	; vram tiles for the little ref (vertical rink)
ronbarrchars	= $1BE3	; vram tiles for the Ron Barr picture (ScoutingReport)
scorechars	= $1BE5	; vram tiles for the scoreboard / team block maps
blankchar	= $1BE7	; vram tile of the blank character (93G uses tile $7FF)

; Bank $7E
sprframetime	= $7E2000	; 4 bytes per sprite frame: sprclock when its tiles were last sent (sprite VRAM tile cache)
palbuffer	= $7E6C74	; CGRAM shadow (256 colors, 512 bytes): VBlank_Cram sends it. 93G palbuffer role
textmap		= $7E6E74	; text layer tile map buffer (32x32 words); textdirtylo/hi mark what to send
backmap		= $7E7674	; second BG map buffer (32x32 words) after textmap: screen backgrounds (GameSetupMap, Title1Map, EASNMap)
hlsavebuf	= $7E7E74	; StartHL2: the game state (gmode-1 .. ScoreSumbytes) while a highlight plays. 92G ReplayStart role
TestList	= $7F0000	; scouting report paragraph numbers (-1 ends). 93G TestList
textsave	= $7FF800	; copy of textmap while the pause screen is up

ReplayBufferEnd	= $7EFF41	; replay buffer end: adda43 wraps to ReplayBufferStart
ReplayBufferStart	= $7E8174	; first replay frame record
; --- constants (values, not addresses) ---
; team record offsets (93G teamdata93.asm)
Playerdata	= 0	; 93G Playerdata
Palettedata	= 2	; 93G Palettedata
Teamname	= 4	; 93G Teamname
LineSets	= 6	; 93G LineSets
ScoutReport	= 8	; 93G ScoutReport
ScoreOdds	= 10	; 93G ScoreOdds
NumofTeams	= 26	; 93G NumofTeams (24 clubs and the 2 All-Star teams)
gsftf		= $0001	; the teams of the game are flipped (92G gsftf 0)
gsfhl		= $0002	; game shown in the score ticker (93G gsfhl 1)
gsfso		= $0004	; game over (93G gsfso 2)
PWrange		= 30	; characters in PasstoText (92G PWrange)
pwlength	= 16	; password characters (92G pwlength)
sf3alttree	= $0004	; alt. playoff tree (93G sf3alttree 2)
; SPC700 (APU RAM) addresses used by the sound uploads
SPCSAMPLEDIR	= $2C00	; DSP sample directory (DIR = $2C)
SPCDRIVER	= $0400	; SPC700 sound driver code (boot upload); the boot upload starts it here
SPCINSTR	= $2B00	; instrument table of the boot set (6 bytes per instrument)
SPCBOOTSAMPLES	= $2C30	; first BRR sample of the boot set
SPCSAMPLES	= $2C50	; first BRR sample of the in-game set
SPCRESUME	= $0800	; driver entry after the in-game sample upload (the boot upload starts the driver at $0400)
SPCDRIVERSIZE	= $26E7	; bytes of data/spc/driver.spc700
BOOTSAMPLESIZE	= $5271	; bytes of data/bootsamples.brr
GAMESAMPLESIZE	= $B814	; bytes of data/gamesamples.brr
replaysize	= $71	; bytes per replay frame record (93G replaysize)
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
gmpen		= $0004	; penalty called, ref in progress (93G gmpen 2)
gmpendel	= $0008	; delayed penalty has been called (93G gmpendel 3)
gmhl		= $0010	; hilight mode (93G gmhl 4)
gmoffs		= $0020	; offsides on (93G gmoffs 5)
gmendper	= $0040	; end the period at the next faceoff (93G gmode bit 6)
; sflags (low byte = 93G sflags, high byte = 93G sflags2)
sfpz		= $0001	; pause mode (93G sfpz 0)
sfpj		= $0002	; pause started by controller 2 (93G sfpj 1)
sfspdir		= $0004	; set pass dir mode (93G sfspdir 2)
sfssdir		= $0008	; set shot dir mode (93G sfssdir 3)
sfwrap		= $0010	; replay has wrapped around (93G sfwrap 4)
sfscrl		= $0020	; replay scrolled by hand: Hpos/Vpos not from the frames (93G sfscrl 5)
sfslock		= $0040	; scroll lock to xc1/yc1 (93G sfslock 6)
sf2faceoff	= $0100	; face off in progress (93G sf2faceoff 0)
sf2refref	= $0200	; ref needs refresh (93G sf2refref 1)
sf2drec		= $0400	; disable replay record (93G sf2drec 2)
sf2replay	= $0800	; replay in progress (93G sf2replay 3)
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
sf3rmplay	= $0002	; replay play mode on (93G sf3rmplay 1)
sf3sbut		= $0008	; Start pressed during the highlights: skip the rest (92G sf3sbut 3)
sf3fo		= $0010	; face off just ended: the next puck pickup wins it (93G sflags3 bit 4)
sf3icetime	= $0020	; count frames on ice per player (93G sflags3 bit 6)
; iflags bits
ifcgl		= $0001	; puck crossed the goal line (93G ifcgl 0)
ifdir		= $0002	; icing toward the top goal (93G ifdir 1)
ifok		= $0004	; icing possible (93G ifok 2)
; attribute bits
attrxflip	= $0800	; x flip (93G attribute bit 3)
attryflip	= $1000	; y flip (93G attribute bit 4)
; tmflags bits
tmfmid		= $0002	; nearest player takes the spot between puck and own goal (93G tmflags bit 2)
tmflcc		= $0001	; line change box needs redrawing (93G tmflcc 0)
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
adefd		= $02	; 93G adefd
awingd		= $03	; 93G awingd
acenterd	= $05	; 93G acenterd
aeben		= $09	; 93G aeben (from the bench)
aepen		= $0A	; 93G aepen (from the penalty box)
apenalty	= $0C	; 93G apenalty
ascore		= $07	; 93G ascore (assignment 7)
afight		= $14	; 93G afight
afwatch		= $15	; 93G afwatch
pnothing	= $1A	; 93G pnothing
pfaceoff	= $1B	; 93G pfaceoff
agoalie		= $0E	; 93G agoalie
agoalietopuck	= $0F	; 93G assgoalietopuck (asstab $F)
apassrec	= $13	; 93G apassrec
afaceoff	= $16	; 93G afaceoff
afaceoffpl	= $17	; 93G afaceoffpl (assfaceoffp1)
pnorm		= $18	; 93G pnorm (pucknorm)
pfaceoff2	= $1C	; 93G pfaceoff2
; penalties (93G PenaltyList numbers)
PenOOP		= $06	; face off / out of play (93G penalty 6, 92 PenOOP): puck still too long, puck over the glass
PenGhold	= $08	; goalie held the puck / bump (93G penalty 8)
PenWhistle	= $0A	; 93G whistle
PenIcing	= $0C	; 93G PenIcing
PenGoal		= $0E	; 93G goal
PenOffsides	= $10	; 93G PenOffsides
PenRough2	= $12	; roughing with slow down time $A (93G .rough2)
PenInjury	= $14	; injury stop, no text (93G .p14)
PenCharge	= $16	; 93G charging
PenSlash	= $18	; 93G slashing
PenRough	= $1A	; 93G roughing
PenCross	= $1C	; 93G cross check
PenHook		= $1E	; 93G hooking
PenTrip		= $20	; 93G tripping
PenInt		= $22	; 93G interference
PenHold		= $24	; 93G holding
PenFight	= $26	; fighting, also the penalty byte of a fight in the list (93G $26)
PenFighting	= $28	; fighting * (93G PenFighting $28)
PenInst		= $2A	; fight instigator (93G .inst)
PenDelay	= $2C	; delayed penalty ref (93G $2C, 92 PenDelay)
; animations (offsets into the animation data; 93G value in the comment)
; SPA values: offsets of the SPAList tables (bank82_C000 asserts each one). 93G frames93.asm names and order
SPAgready	= $0002	; 93G SPAgready $2: goalie ready (loops)
SPAgready2	= $0134	; 93G SPAgready2 $134
SPAgglover	= $0166	; 93G SPAgglover $166: glove save (GoalieSaveList 0)
SPAgglovel	= $0198	; 93G SPAgglovel $198: glove save (GoalieSaveList 1)
SPAgstickr	= $01CA	; 93G SPAgstickr $20C: stick save (GoalieSaveList 4)
SPAgstickl	= $01FC	; 93G SPAgstickl $23E: stick save (GoalieSaveList 5)
SPAgstackr	= $022E	; 93G SPAgstackr $270: stack pad save (GoalieSaveList 2)
SPAgstackl	= $0280	; 93G SPAgstackl $2C2: stack pad save (GoalieSaveList 3)
SPAgswing	= $02D2	; 93G SPAgswing $386
SPAgskate	= $0344	; 93G SPAgskate $3F8: goalie skating
SPApflip	= $03D6	; 93G SPApflip $48A: puck spin
SPAglide	= $0478	; 93G SPAglide $52C: glide
SPAskatewp	= $04AA	; 93G SPAskatewp $55E
SPAskate	= $055C	; 93G SPAskate $5F0
SPAturnl	= $060E	; 93G SPAturnl $682
SPAturnr	= $0640	; 93G SPAturnr $6B4
SPAstop		= $0672	; 93G SPAstop $6E6: stop
SPApassf	= $06C4	; 93G SPApassf $738
SPApassb	= $0736	; 93G SPApassb $7AA
SPAshotf	= $07A8	; 93G SPAshotf $81C: forehand shot
SPAshotb	= $08BA	; 93G SPAshotb $94E: backhand shot
SPAglideback	= $09CC	; 93G SPAglideback $A80
SPAskateback	= $09FE	; 93G SPAskateback $AB2
SPAsweepchk	= $0A90	; 93G SPAsweepchk $B44: sweep check
SPAshoulderchkl	= $0B02	; 93G SPAshoulderchkl $BB6
SPAshoulderchkr	= $0B34	; 93G SPAshoulderchkr $BE8
SPAhipchkl	= $0B66	; 93G SPAhipchkl $C1A
SPAhipchkr	= $0B98	; 93G SPAhipchkr $C4C
SPAburst	= $0BCA	; 93G SPAburst $C7E: check button burst
SPAHold		= $0BFC	; 93G SPAHold $CB0: hold
SPAHold2	= $0C2E	; 93G SPAHold2 $CE2
SPAflail	= $0C60	; 93G SPAflail $D14
SPAfallfwd	= $0C92	; 93G SPAfallfwd $D46
SPAfallback	= $0D44	; 93G SPAfallback $DF8
SPAcelebrate	= $0DF6	; 93G SPAcelebrate $EAA
SPApump		= $0E68	; 93G SPApump $F1C
SPAfight	= $0EDA	; 93G SPAfight $F8E: fight
SPAfgrab	= $0F0C	; 93G SPAfgrab $FC0
SPAfheld	= $0F2E	; 93G SPAfheld $FE2
SPAfhigh	= $0F50	; 93G SPAfhigh $1004
SPAflow		= $0F82	; 93G SPAflow $1036
SPAfhith	= $0FB4	; 93G SPAfhith $1068
SPAfhitl	= $0FD6	; 93G SPAfhitl $108A
SPAffall	= $0FF8	; 93G SPAffall $10AC
SPAwallright	= $101A	; 93G SPAwallright $1128
SPAwallleft	= $1058	; 93G SPAwallleft $1166
SPAfaceoff	= $1096	; 93G SPAfaceoff $11A4: faceoff pull
SPAfaceoffr	= $10C0	; 93G SPAfaceoffr $11CE: faceoff ready
SPAsiren	= $10DA	; 93G SPAsiren $11E8: goal siren on the puck shadow
SPAstanley	= $1124	; 93G SPAstanley $1258
SPAfinjury	= $1156	; 93G SPAfinjury $10CE: fight injury (fight loser down)
SPAflip		= $11B0	; 93G SPAflip $1524: third fall animation (flip)
SPAstumble	= $12A2	; 93G SPAstumble $13A0: stumble instead of a fall
SPAhook		= $1354	; 93G SPAhook $12DC: hold/hook (holdplayer, Acheck)
SPAhook2	= $1386	; 93G SPAhook2 $130E
SPAcatch	= $1418	; 93G SPAcatch $128A: player hit by a slow puck
SPAbglass	= $146A	; 93G SPAbglass $1232: the puck shadow over the glass
SPAgdive	= $1490	; 93G SPAgdive $314: goalie dive (temp5 = 5 after a save)
SPAinjury1	= $1502	; 93G SPAinjury1 $1616: injured: no movement, no bounce (SNES frames differ from 93G)
; sprite frame bases (SPF): first frame of each group in the SNES sprite set. 93G frames93.asm names; frames from SPFpuck on
; are one lower than 93G (no SPFreplay frame) and the goalie and 93-only groups are laid out differently
SPFskatewp	= 1	; 93G 1
SPFskate	= 41	; 93G 41
SPFturnl	= 81	; 93G 81
SPFturnr	= 89	; 93G 89
SPFswing	= 97	; 93G 97
SPFstop		= 145	; 93G 145
SPFskateb	= 161	; 93G 161
SPFcelebrate	= 185	; 93G 185
SPFpump		= 201	; 93G 201
SPFcup		= 217	; 93G 217
SPFhipl		= 225	; 93G 225
SPFhipr		= 233	; 93G 233
SPFshoulderl	= 241	; 93G 241
SPFshoulderr	= 249	; 93G 249
SPFsweep	= 257	; 93G 257
SPFfallback	= 273	; 93G 273
SPFfallfwd	= 305	; 93G 305
SPFduck		= 337	; 93G 337
SPFhold		= 345	; 93G 345
SPFgloves	= 353	; 93G 353
SPFfight	= 354	; 93G 354
SPFfinjury	= 371	; 93G 371
SPFPen		= 377	; 93G 377
SPFarrow	= 384	; 93G 384
SPFpad		= 390	; 93G 390
SPFpuck		= 393	; 93G 394
SPFgoal		= 404	; 93G 405
SPFGoalie	= 406	; 93G 407
SPFgdive	= 643	; 93G 519
SPFgready	= 627	; 93G 539
SPFSiren	= 518	; 93G 555
SPFcatch	= 606	; 93G 569
SPFhook		= 590	; 93G 585
SPFstumble	= 566	; 93G 601
SPFflip		= 558	; 93G 625
SPFbglass	= 622	; 93G 645
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
SFXoverglass	= $8C	; puck over the glass (93G $E)
SFXpuckwall	= $95	; +0-2: puck off the boards by speed (93G $28-$2B)
SFXpost		= $94	; puck off the post (93G 8 / $25)
SFXsiren	= $A0	; goal siren (93G 0)
SFXwhistle	= $89	; whistle (93G 3)
SFXcheck	= $90	; +0/1: check (93G $1C-$1F)
SFXplayerwall	= $9E	; +0/1: player hits the boards (93G $20)
; joypad bits (SNES)
JOYSTART	= $1000	; Start (93G sbut)
JOYR		= $0010	; R shoulder
JOYL		= $0020	; L shoulder
JOYRIGHT	= $0100	; dpad right (93G rbut)
JOYLEFT		= $0200	; dpad left (93G lbut)
JOYDOWN		= $0400	; dpad down (93G dbut)
JOYUP		= $0800	; dpad up (93G ubut)
JOYA		= $0080	; A button (92G cbut on the password screen)
bbut		= $8000	; B: pass / switch player (93G bbut)
abut		= $4000	; Y: hold / line change (93G abut)
; injury
INJfight	= $112C	; tmpdst value for a player injured in a fight (93G $112C)
; tmpdst values
TMPDICE		= $FFFF	; on the ice (93G -1)
TMPDBENCH	= $FFFE	; on the bench (93G -2)
TMPDOUT		= $FFFD	; out of the game (93G -3)
TMPDINJ		= $1000	; injured: box time with this bit has no penalty (93G tmpdst bit 12)

OFFSCREEN	= $4E20	; projxy: d1 for a point off the screen (20000)
; --- addresses: puck fields (need puckobj above) ---
puckx		= Xpos+puckobj	; 93G puckx
pucky		= Ypos+puckobj	; 93G pucky
puckvx		= Xvel+puckobj	; 93G puckvx
puckvy		= Yvel+puckobj	; 93G puckvy
puckvz		= Zvel+puckobj	; 93G puckvz
puckc		= newpos+puckobj	; SCnum of the puck carrier, negative = loose. 93G puckc (puck newpos)
