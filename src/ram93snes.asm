; NHLPA 93 SNES RAM map (WRAM $7E0000-$7FFFFF, low 8K mirrored at $0000-$1FFF in banks $00-$3F/$80-$BF).
; Not a queue segment: no ROM bytes. Add names freely as segments are transcribed. Define each name once.
; Prefer the 68000 RAM names when the variable plays the same role.
; Format: Name = $xxxx (asar equate). DP names are < $100 and are written with .b; others with .w / .l.
; The constants section at the end holds values (bit masks, animation offsets, sound numbers), not addresses.

; Direct page $00-$18: vblank / irq bookkeeping (from VBjsr, vb2, HBjsr in bank80)
vcount		= $00	; 32-bit frame counter, +1 per vblank in vb2_main. vcount (word there)
brightness	= $04	; INIDISP shadow (0-15 brightness, $80 forced blank), written each vblank by vb2
fadeout		= $06	; nonzero: vb2 steps brightness down every 4 frames until 0. SNES stand-in for cramfade
fadein		= $08	; 1: vb2 steps brightness up every 4 frames to 15; >1: delay count before fading in
xsave		= $0A	; X saved around the movem-style push/pop loops of the 68k port (stx xsave : ldx #0 ...)
farptr		= $0C	; long pointer ($0C-$0E) to a frame set table (addframe, addframe_hi)
sprtileptr	= $0F	; addframe: long pointer to the tiles of the frame set ($0F-$11)
vbactive	= $12	; nonzero while the vbint handler runs (or while main code holds vblank off): VBjsr skips it
vbint		= $14	; address (bank $80) of the vblank handler VBjsr jumps to. vbint
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
d7		= $6F	; 68k d7: frames elapsed this game frame (time step), as in updateplayers
tmp0		= $73	; scratch word (SNES port temporaries in place of extra 68k data registers)
tmp1		= $75	; scratch word; tmp0/tmp1 together form a 32-bit value (or tmp1 = long pointer, tmp1+2 = bank)
tmp2		= $77	; scratch word
mula		= $7D	; multiply/divide operand A (32-bit with mula+2). Helpers: muls16, mulu (bank $8D/$88), muls (bank $82)
mulb		= $83	; multiply/divide operand B (32-bit with mulb+2)
mulres		= $93	; multiply result low word; mulres+2 ($95) = high word (68k swap)
mulneg		= $98	; muls32: count of negative operands
mulsign		= $81	; divs: count of negative operands
mulcnt		= $87	; divs: bit loop count (16)
DMAListend	= $A3	; byte offset of the end of DMAList (7 bytes per entry); VBlank sends and empties it. DMAListend
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
printm		= $D4	; byte offset of the print map in textmap (map number from the print control code). printm
collflag	= $D8	; a player collision happened: checkcoll restores the old position. collflag
crowdcnt	= $DA	; count down to the next crowd animation step. crowdcnt
crowdframe	= $DC	; crowd frame: low byte = random extra frame (loud crowd), high byte ($DD) = frame from cd0. crowdframe
crowdlevel	= $DE	; level of crowd excitement (+$50 per punch, +$258 for a won fight, +$C8 for a faceoff win). crowdlevel
crowdstep	= $E0	; animation step for the crowd (0-$1E). crowdstep
bosgames	= $D6	; 0-6 game of the best of seven series, 7 = single games. bosgames
deltax		= $EA	; avdgoal: x correction around the goal. deltax
deltay		= $EC	; avdgoal: y correction. deltay
impactstep	= $E2	; d7*2: impact decay this game frame (game loop)
velstep		= $E4	; d7*16: velocity to position scale this game frame
gravstep	= $E6	; d7*96: gravity this game frame
d7x1024		= $E8	; d7*1024, set with the other time steps (no reader found yet)
ThirdPBonus	= $F0	; setplayer: +2 when tied or trailing late in the 3rd period. ThirdPBonus
evalue		= $F2	; elasticity value of a player collision (0-16). evalue
pausetimer	= $EE	; pause menu: frames left before a demo pause ends by itself (60000)
fobox		= $F4	; nonzero while the faceoff box is on screen (puckfaceoff2 .. Endfaceoff): SetLCmode2 keeps its area. disflags bit 4
ffoattr		= $F6	; 5 words: attribute of the ffo objects (pads 0-3, gloves). ffo attribute

; $0100-$1FFF: absolute (DB = $80 mirrors bank $00 WRAM)
ffoframe	= $0100	; 5 words: frame of the objects tied to rink scrolling (pads 0-3, gloves at +8). ffo frame (92 ffo)
ffoxofs		= $010A	; 5 words: ffo x offset of the label sprites
ffox		= $0114	; 5 words: ffo x. ffo Xpos
ffoy		= $011E	; 5 words: ffo y
ffoz		= $0128	; 5 words: ffo z ($FFFF = hidden)
fodir1		= $0132	; pull direction of the home center on the faceoff (dpad, negative = none). fodir1
fodir2		= $0134	; fodir2
fodropx		= $0136	; faceoff box x (pixels). fodropx
fodropy		= $0138	; faceoff box y. fodropy
fofdata2	= $013A	; face off pull frame for the home ($013A) and visiting ($013E) center (assfaceoffp1). fofdata2
fofdata		= $0142	; frame/attribute of the faceoff ref (big faceoff sprites). fofdata
fox		= $0146	; faceoff spot x. fox
foy		= $0148	; faceoff spot y. foy
glovecords	= $014E	; x/y bytes of the dropped gloves (chkhit). glovecords
cheercnt	= $0150	; crowd cheers still to play after a goal (SFXcrowdcheer every 150 frames, Gameloop)
cheervc		= $0152	; vcount of the last crowd cheer
tickerstart	= $0158	; TickerNum at the start of the intermission (IntermissionTick: all shown when it comes round again)
Hpos		= $0154	; ice rink horizontal position. Hpos
Hscroll		= $0156	; horizontal scroll: BG2HOFS = Hscroll+$C0 (VBlank). Hscroll
HmAwBonus	= $015A	; setplayer: home bonus / visitor penalty. HmAwBonus
iflags		= $015C	; icing flags (if* masks); high byte ($015D) = icingPlayer (SCnum). iflags/icingPlayer
joypad1		= $015E	; controller 1 buttons (SNES joypad bits, JOY* masks)
joypad2		= $0160	; controller 2 buttons
joypad3		= $0162	; controller 3 buttons (multitap)
joypad4		= $0164	; controller 4 buttons
padlast1	= $0166	; 4 words: buttons at the last ReadPads (joypad1-4)
padnew1		= $016E	; 4 words: buttons newly pressed at the last ReadPads (joypad1-4)
padvcount	= $0176	; vcount of the last ReadPads (the pads are read once per frame)
jmlvector	= $0178	; RAM jml trampoline: $5C (jml opcode, set by Start), target at +1..+3. sfx returns through it, updateplayers calls the assignment through it
lastsfx		= $017F	; last sound effect requested. lastsfx
carriedy	= $0181	; pucky while the puck is carried: the y a shot was taken from (puckgoalie)
lcplayer	= $0183	; SCnum of the player who opened the line change box ($FFFE = take the next one)
lj1		= $0185	; last controller 1 buttons (debounce). lj1
lj2		= $0187	; lj2
lldisp		= $0189	; count down for the once-a-second screen/game updates ($18 frames). lldisp
ltplayer	= $018B	; last touch player (SCnum). ltplayer
ltx		= $018D	; last touch x. ltx
lty		= $018F	; last touch y. lty
gamelevel	= $014A	; 0-3: depth into the playoff tree (4 = finished). gamelevel
gamenum		= $014C	; index of the user game in the playoff game arrays (-1 = none). gamenum
mesarea		= $0191	; temp area for print strings (length word, then characters). mesarea
lastplayer	= $017D	; SCnum of the last player who touched the puck (doshot). lastplayer
PushWidthBuf	= $01F5	; PushNumberWidth string: length word (digits + 2), then the digits right aligned, spaces before (8 chars to $01FE). PushWidthBuf
Satt		= $01FF	; sprite attribute table (OAM shadow, $220 bytes), sent by VBlank. Satt
SattHi		= $03FF	; OAM high table shadow (x bit 8 and size, 2 bits per sprite)
printx		= $047B	; x cordinate for printing (text map column). printx
printy		= $047D	; y cordinate for printing. printy
PadControlBits	= $0431	; SCnum nibbles of the pad-controlled players ($FFFF = none). PadControlBits
psitem		= $0485	; pause menu item (0-4). psitem
sprpieces	= $0487	; addframe: pieces left in the frame
padcont		= $0433	; 4 words. padcont
nibblebuffer	= $041F	; 4 words: the weights WeightedRandomSelect picks from (SetScore). nibblebuffer
oldvcount	= $0427	; vcount at the last game frame (d7 = vcount - oldvcount). oldvcount
goalcue		= $0429	; nonzero: home team just scored (lead 0-2): assfaceoff plays the goal music cue at the next faceoff
percue		= $042B	; nonzero: period just started: assfaceoff plays the period music cue
p3cue		= $042D	; third period: frames until StartSong3 plays its music cue (set by StartPer, 0 = done)
midpercue	= $042F	; gameclock value (half the period) at which assfaceoff plays the mid-period music cue (0 = done)
passdir		= $043B	; direction for pass/shot 0-7 (8 = none). passdir
passspeed	= $043D	; speed of pass/shot. passspeed
passReceiverPlayerNum	= $043F	; SCnum the last pass was aimed at (negative = none). passReceiverPlayerNum
PKBonus		= $0441	; setplayer: penalty kill bonus (negative). PKBonus
PlList		= $0443	; 12 bytes: wanted roster players (6), then their positions (6). PlList
pojoy		= $044F	; playoff joystick indicator (2+: two players). POJoy
postarts	= $0451	; 0-31: playoff tree layout; negative after DecodePW = bad password. postarts
potree		= $0453	; 32 bytes: team in each playoff tree slot (16+8+4+2+1+1). potree
potreeteam	= $0473	; the user's slot in the first playoff round. potreeteam
PPBonus		= $0475	; setplayer: power play bonus. PPBonus
printa		= $0477	; attribute (palette/priority bits) for print characters. printa
printfont	= $0479	; font number (0-3) from the print control code
puckcross	= $0489	; 2 entries of (x, frames): where/when the puck crosses the top / bottom goal line ($FFFF frames = never). puckcross
repeatdelay	= $0499	; ProcessInputWithRepeat: frames to the next key repeat
ReplayBufferPtr	= $0495	; long pointer to the next replay frame record (bank $7E, wraps at $7EFF41 to $7E8174). ReplayBufferPtr
Oldrow		= $049B	; last rink map row (vertical scrolling of the map data; 999 = redraw all). Oldrow
vramrow		= $049D	; BG2 tile map row (0-31) at the top of the ring buffer: BG2VOFS = vramrow*8 + (Vscroll&7)
rndb1		= $0491	; copy of seed byte 1 after each random (8-bit random for other code)
rndb2		= $0493	; high byte of the new seed after each random
seed		= $04A1	; 32-bit random seed (randomd0). 92 seed, StanleyCupTimer. Its low bits also serve as a quick random
sfxmutetime	= $04A7	; vcount when sound effects were cut off: sfx are dropped for 180 frames after it
shotplayer	= $04A5	; SCnum of the player who shot last. shotplayer
sndsettle	= $049F	; set to 10 after the in-game sample upload: p_music_vblank sends no commands until it counts down
cuetimer	= $04A9	; frames left of a music cue; sfx are dropped while it runs
sprslottime	= $04AB	; 512 words: sprclock value when each 32-byte VRAM sprite tile slot was last used
colorflag1	= $08B7	; cleared by setplayercolors (no reader found)
colorflag2	= $08B9	; cleared by setplayercolors (no reader found)
TickerNum	= $08D7	; playoff game the score ticker shows next. TickerNum
tickervc	= $08D9	; vcount when the ticker box was last shown (Intermission: next one after $150 frames)
ssoattr		= $08AB	; 4 words: attribute of the off-screen arrow objects
ssoframe	= $08B3	; 4 words: sso frame
ssoz		= $08BB	; 4 words: sso z ($FFFF = hidden)
ssox		= $08C3	; 4 words: sso x
ssoy		= $08CB	; 4 words: sso y
threat		= $08D3	; direction of threat on puck handler (nonzero = threat). threat
demoflag	= $08D5	; nonzero in demo mode (pause ends by itself when no controller has a team). demoflag
PlayerScrollCtr	= $08E9	; scouting text: offset of the next word in the paragraph (negative = next paragraph). PlayerScrollCtr
screentimer	= $08EB	; frames left on the scouting report screen. screentimer
SelectedPlayerIdx	= $08ED	; scouting text: TestList index. SelectedPlayerIdx
ScoutingReportTimer	= $08EF	; frames to the next word ($7FFF = text finished). ScoutingReportTimer
DispAttribCtr	= $08F1	; scouting text column. DispAttribCtr
VertLineScrolling	= $08F3	; scouting text line (0-6). VertLineScrolling
xc1		= $08F5	; scroll lock x (fight). xc1
yc1		= $08F7	; scroll lock y. yc1
yleader		= $08F9	; lead distance on scrolling. yleader
vcountmark	= $08FB	; 32-bit vcount snapshot: elapsed time base (setupice sets it 2*$10000 frames back)
lastframevc	= $08DB	; vcount at the last replay frame shown (ReplayMode, bank $8F); not read
zamx		= $08DD	; cleared by setupice
Vpos		= $08DF	; ice rink vertical position. Vpos
Vscroll		= $08E1	; vertical scroll (low 3 bits = BG2 fine scroll). Vscroll
wcradiusx	= $08E3	; wall collision radius x. wcradiusx
wcradiusy	= $08E5	; wall collision radius y. wcradiusy
WinBits		= $08E7	; bits of the teams that go on in the playoff tree. WinBits

; Sort objects (SortCords): structure of arrays, one word per object, 16 objects ($20 bytes per field).
; Index with X/Y = SCnum*2. The byte fields (pnum ... handed) are each a word array here.
; Fields from Xvel on are in the struct order; the gaps are fields not met yet.
Xpos		= $08FF	; Xpos (integer part)
Xfrac		= $091F	; fraction of Xpos
frame		= $093F	; sprite frame number. frame
Ypos		= $095F	; Ypos (integer part)
Yfrac		= $097F	; fraction of Ypos
Zpos		= $099F	; Zpos (height)
Zfrac		= $09BF	; fraction of Zpos
attribute	= $09DF	; frame attribute bits (attrxflip, attryflip). attribute
oldframe	= $09FF	; last frame. oldframe
OldXpos		= $0A1F	; OldXpos
OldXfrac	= $0A3F	; OldXpos low word
OldYpos		= $0A5F	; OldYpos
OldYfrac	= $0A7F
OldZpos		= $0A9F	; OldZpos
OldZfrac	= $0ABF
Xvel		= $0ADF	; Xvel
Yvel		= $0AFF	; Yvel
Zvel		= $0B1F	; Zvel
impactp		= $0B3F	; last player to cause impact (SCnum). impactp
limpact		= $0B5F	; last impact value. limpact
impact		= $0B7F	; impact value. impact
position	= $0B9F	; player's position (0=goalie,1=l.def,2=r.def,3=l.wing,4=center,5=r.wing; negative = none). position
assnum		= $0BBF	; index to current assignment (0-7). assnum
asslist		= $0BDF	; list of assignments, 8 bytes per object: asslist+SCnum*8+assnum (index X*4+assnum). asslist
temp1		= $0C5F	; temp1
temp2		= $0C7F	; temp2 (high byte as a byte counter: sub.b d7,temp2)
temp3		= $0C9F	; temp3
temp4		= $0CBF	; temp4
temp5		= $0CDF	; temp5
temp2b		= $0CFF	; temp2+1 (low byte; the port also uses it where uses temp2 as a word: swing time, pass wait)
radiusx		= $0D1F	; width of this graphic (wall collision). radiusx
radiusy		= $0D3F	; radiusy
Wallcos		= $0D5F	; cos of the angle of the last wall collision. Wallcos
Wallsin		= $0D7F	; Wallsin
SCnum		= $0D9F	; index number of this object (X/2). SCnum
facedir		= $0DBF	; direction of facing 0-7. facedir
facefrac	= $0DDF	; turn fraction of facedir: doplayeracc adds the turn rate here and carries into facedir. facedir.l low word
SPA		= $0DFF	; current animation (offset into the animation data). SPA
SPAnum		= $0E1F	; index into animation (4 per frame). SPAnum
SPAcnt		= $0E3F	; count down to the next animation frame (-1 = restart). SPAcnt
nopuck		= $0E5F	; no puck collision until zero. nopuck
nopuckb		= $0E7F	; second count down
newpos		= $0E9F	; requested next position (negative = none). newpos
newpnum		= $0EBF	; requested next roster player (negative = none). newpnum
pflags		= $0EDF	; pflags (bits 0-7) and pflags2 (bit n at bit n+10); some flags have their own arrays below
pnum		= $0F1F	; player's team location number (low byte). pnum
weight		= $0F3F	; weight
legstr		= $0F5F	; legstr
legspd		= $0F7F	; legspd
aioff		= $0F9F	; aioff
aidef		= $0FBF	; aidef
shotspd		= $0FDF	; shotspd
shotacc		= $0FFF	; shotacc
passacc		= $101F	; passacc (goalies: glove save right)
spodds		= $105F	; shot/pass odds. spodds
rostnum		= $103F	; rostnum
stickhand	= $107F	; stickhand
endurance	= $109F	; endurance (goalies: stick save right)
GGSleft		= $10BF	; byte $73: goalie glove save left
fightagg	= $10DF	; fighting aggression
aggress		= $10FF	; aggress ($75)
handed		= $111F	; nonzero: right handed (0 = lefty for the faceoff frames). handed
pfgoal		= $113F	; nonzero: shoots at the top goal. pflags bit pfgoal
pf2fight	= $115F	; nonzero: fighting. pflags2 bit pf2fight
pfalock		= $117F	; nonzero: locked until the animation is done. pflags bit pfalock
pfteam		= $119F	; 0 = home, nonzero = visitors. pflags bit pfteam
pfrev		= $11BF	; nonzero: skating backwards. pflags bit pfrev
pf2aip		= $11DF	; nonzero: animation in progress. pflags2 bit pf2aip
pfnc		= $11FF	; nonzero: no collision mode. pflags bit pfnc
Ylist		= $121F	; y of each sort object. Ylist
OOlistpos	= $123F	; position of each object in OOlist. OOlistpos
OOlist		= $125F	; 16 bytes: object order list, bottom of the screen last. OOlist
pspeed		= $126F	; |Xvel|+|Yvel| after a burst (SNES only, read by the hit code)

; Game state
gmode		= $1288	; game mode flags (gm* masks). gmode
gmclock		= $128A	; nonzero: game clock is stopped. gmode bit gmclock
sflags		= $128C	; sflags (low byte) and sflags2 (high byte) as one word (sf*/sf2* masks)
sfhormode	= $128E	; nonzero: screen in horizontal mode. sflags bit sfhor
sflags3		= $1290	; sflags3 (sf3* masks)
c1playernum	= $1292	; player on controller 1 (negative = none). c1playernum
c2playernum	= $1294	; c2playernum
cont1team	= $1296	; team on controller 1 (0 none, 1 home, 2 away). cont1team
cont2team	= $1298	; cont2team
HomeTeam	= $129A	; home team number (TeamList index). HomeTeam
VisTeam		= $129C	; visiting team number. VisTeam
PenBuf		= $129E	; up to 32 penalties: (penalty number, SCnum) byte pairs, 0 = free. PenBuf
PenaltyBufferEnd	= PenBuf-2	; the word before PenBuf, used as the list base. PenaltyBufferEnd
Pencntdwn	= $12E0	; penalty/fight count down (negative = fight over). Pencntdwn
pentimer	= $12E2	; frames to the next penalty clock second (updatepentime, 24 per second)
PBnum		= $12E4	; players in the penalty boxes: home*16 + visitors. PBnum
InjCntDown	= $12E6	; InjCntDown
penmsgtimer	= $12E8	; count down to reprinting the horizontal penalty message line ($7FFF = never). penmsgtimer
RefCnt		= $12EA	; ref graphics control (negative = idle). RefCnt
RefStep		= $12EC	; step in the ref animation (negative = done). RefStep
RefPen		= $12EE	; penalty number of the ref animation. RefPen
ChkCnt		= $12F8	; checks since the last fight (fight chance). ChkCnt
TempPlOffset	= $12FA	; pnum of the penalized player | $8000 for the visitors (InProgress). TempPlOffset
ScoreSumbytes	= $12FC	; bytes used in ScoreSum (6 per goal, max $B4). ScoreSumbytes
ScoreSum	= $12FE	; goal log: time word, (2+tmap diff | $80 away), scorer, assist, assist. ScoreSum
gsp		= $12F0	; game period. gsp
gameclock	= $12F2	; game clock seconds; gameclock+2 = jiffies (-$AAA per frame). gameclock
PerTimeTotal	= $12F6	; length of this period (seconds). PerTimeTotal

; Team structs (hmtmstruct / awtmstruct): word arrays indexed by a2 (0 home, 2 away)
tmshots		= $13B2	; shots stat. tmshots
tmPwrGoals	= $13B6	; power play goals stat. tmPwrGoals
tmPwrPlays	= $13BA	; power plays stat. tmPwrPlays
tmPenalties	= $13BE	; penalties stat. tmPenalties
tmPenmin	= $13C2	; penalty minutes stat. tmPenmin
tmATOP		= $13CA	; attack zone time stat (seconds). tmATOP
tmdata		= $13CE	; team data address (bank $83). tmdata
tmsort		= $13D2	; first object index of the team. tmsort
tmscore		= $13D6	; score. tmscore
tmfowon		= $13DA	; faceoffs won
tmline		= $13DE	; current line. tmline
tmtouch1	= $13E2	; pnum of the last touch
tmtouch2	= $13E6	; second last touch (93 $1A)
tmtouch3	= $13EA	; third last touch (93 $1C)
tmap		= $13EE	; active players on ice. tmap
tmgoalie	= $13F2	; goalie: low byte = goalie 0/1, $FFxx = pulled (xx = goalie to return, $FF = stays out). tmgoalie
tmteam		= $13F6	; team number (TeamList index) of the team struct
tmnear		= $13FA	; 32-bit (tmnear = low word, +4 = high word): nearest distance^2 to the puck (assnearest). team long $2A
tmchecks	= $1402	; checks stat
tmpasscomp	= $1406	; completed passes
tmflags		= $140A	; team flags. tmflags
tmlcchoice	= $140E	; line change box row chosen (0-2). team word $2E
tmgoals		= $1412	; goals per roster player (bytes, +$1A for team 2; team bytes $B4)
pchecks		= $1446	; checks per roster player (bytes, +$1A for team 2; team bytes $11C)
tmpde		= $147A	; energy of each roster player (word per player, +$34 for team 2). tmpde
tmpdst		= $14E2	; bench/ice/box state of each roster player (+$34 for team 2). tmpdst
tmboxlist	= $154A	; penalty box list of roster players (bytes, +$1A for team 2, negative ends; team bytes $9A)
gst1		= $157F	; playoff games: one word per game (8) for each gstruct field. gst1 (team 1)
gst2		= $158F	; gst2 (team 2)
gspotwins	= $159F	; gspotwins
gspobwins	= $15AF	; gspobwins
gsper		= $15BF	; gsper (period)
gss1		= $15CF	; gss1 (team 1 score)
gss2		= $15DF	; gss2
gsflags		= $15EF	; gsflags (gsf* masks)

; Options
OptPlayMode	= $1600	; play mode (0 regular season, 1 continue playoffs, 2/3 new playoffs). OptPlayMode
OptPlayers	= $1602	; players option
OptTeam1	= $1604	; team 1
OptTeam2	= $1606	; team 2
OptPerlen	= $1608	; period length index. OptPerlen
PassWord	= $1610	; 16 password characters (indexes into PasstoText; bit 7 hides it). PassWord
OptPen		= $160A	; penalties (0 = off). OptPen
asv		= $1644	; scouting text without delays (down pressed). asv
crowdvol	= $1646	; crowd noise volume last sent to the sound driver (updatesound)
cheatpads	= $1648	; 3 words: the last three new pad presses (the unreached Gameloop .cheat)
passbits	= $1624	; password bits: a 128-bit number, 8 words, low word first (SuperDiv, PushBits). PassBits
tpassbits	= $1634	; 8 words: passbits before all games are resolved (EncodePW, sf3alttree). tpassbits
OptLine		= $160C	; line changes (0 = on). OptLine
notdemo		= $160E	; $FFFF once a player set up the game, 0 after the attract demo (FigureJoy: no controller teams). demoflag role

sndbank		= $164F	; sound set loaded into the SPC (1 = the in-game sounds); sfx are queued only for it
cursong		= $1651	; song playing on the SPC (0 = none); set by the song starters in banks $86/$89
DMAList		= $1653	; vram dma list (7-byte entries, see dma* offsets), filled up to DMAListend. DMAList
printfontset	= $1BCB	; tile base of the selected print font (control code). printfontset
charofs		= $1BCD	; added to every text map tile written by the game code ($FF00 at boot, 0 in the game screens)
charofs2	= $1BCF	; second tile offset: cleared with charofs by the screen setups (the team roster screen adds it)
BigFontChars	= $1BD1	; vram tiles for the big font. BigFontChars
unusedchars	= $1BD3	; 14 tiles after the faceoff box; set by setupice, not read
ExtraChars	= $1BD5	; first free vram tile after the text tiles. ExtraChars
smallfontchars	= $1BD7	; vram tiles for the small font (print). smallfontchars
faceoffvrcset	= $1BD9	; vram tiles for the faceoff box. faceoffvrcset
Framercset	= $1BDB	; vram tiles for the Framer box. Framercset
logochars	= $1BDD	; vram tiles for the NHLPA logo (game setup and playoff screens, packed at NHLPALogo)
refcharshor	= $1BDF	; vram tiles for the little ref (horizontal rink)
refchars	= $1BE1	; vram tiles for the little ref (vertical rink)
ronbarrchars	= $1BE3	; vram tiles for the Ron Barr picture (ScoutingReport)
scorechars	= $1BE5	; vram tiles for the scoreboard / team block maps
blankchar	= $1BE7	; vram tile of the blank character

; Bank $7E
sprframetime	= $7E2000	; 4 bytes per sprite frame: sprclock when its tiles were last sent (sprite VRAM tile cache)
palbuffer	= $7E6C74	; CGRAM shadow (256 colors, 512 bytes): VBlank_Cram sends it. palbuffer role
textmap		= $7E6E74	; text layer tile map buffer (32x32 words); textdirtylo/hi mark what to send
backmap		= $7E7674	; second BG map buffer (32x32 words) after textmap: screen backgrounds (GameSetupMap, Title1Map, EASNMap)
hlsavebuf	= $7E7E74	; StartHL2: the game state (gmode-1 .. ScoreSumbytes) while a highlight plays. ReplayStart role
unpackbuf	= $7F0000	; DecompressBytecode output buffer (64K, bank $7F): tiles are copied to vram from here
TestList	= $7F0000	; scouting report paragraph numbers (-1 ends). TestList
textsave	= $7FF800	; copy of textmap while the pause screen is up

ReplayBufferEnd	= $7EFF41	; replay buffer end: adda43 wraps to ReplayBufferStart
ReplayBufferStart	= $7E8174	; first replay frame record
; --- constants (values, not addresses) ---
; team record offsets
Playerdata	= 0	; Playerdata
Palettedata	= 2	; Palettedata
Teamname	= 4	; Teamname
LineSets	= 6	; LineSets
ScoutReport	= 8	; ScoutReport
ScoreOdds	= 10	; ScoreOdds
NumofTeams	= 26	; NumofTeams (24 clubs and the 2 All-Star teams)
gsftf		= $0001	; the teams of the game are flipped
gsfhl		= $0002	; game shown in the score ticker
gsfso		= $0004	; game over
PWrange		= 30	; characters in PasstoText
pwlength	= 16	; password characters
sf3alttree	= $0004	; alt. playoff tree
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
replaysize	= $71	; bytes per replay frame record
puckobj		= $1C	; object index of the puck
JMLOPCODE	= $5C	; jml opcode (sfxretjml)
DPCLEAREND	= $164E	; Start clears DP/RAM $0000 up to here
; DMAList entry offsets
dmasrc		= 0	; word: source address
dmabank		= 2	; byte: source bank
dmalen		= 3	; word: byte count
dmavram		= 5	; word: VRAM word address
dmasize		= 7	; bytes per entry
; gmode bits
gmdir		= $0002	; 0 = home team goes up
gmpen		= $0004	; penalty called, ref in progress
gmpendel	= $0008	; delayed penalty has been called
gmhl		= $0010	; hilight mode
gmoffs		= $0020	; offsides on
gmendper	= $0040	; end the period at the next faceoff
; sflags (low byte = sflags, high byte = sflags2)
sfpz		= $0001	; pause mode
sfpj		= $0002	; pause started by controller 2
sfspdir		= $0004	; set pass dir mode
sfssdir		= $0008	; set shot dir mode
sfwrap		= $0010	; replay has wrapped around
sfscrl		= $0020	; replay scrolled by hand: Hpos/Vpos not from the frames
sfslock		= $0040	; scroll lock to xc1/yc1
sf2faceoff	= $0100	; face off in progress
sf2refref	= $0200	; ref needs refresh
sf2drec		= $0400	; disable replay record
sf2replay	= $0800	; replay in progress
sf2shot		= $1000	; shot was taken
sf2pwrplay	= $2000	; power play in progress
sf2pwrtm	= $4000	; 0 for team 1 in power play
sf2offsig	= $8000	; offsides little ref on
; pflags bits (pflags2 bit n is bit n+10)
pfdoff		= $0001	; deceleration off
pfna		= $0002	; new assignment
pfjoycon	= $0008	; joystick controlled
pf2unav		= $1000	; unavailable
pf2lcm		= $2000	; line change mode
pf2pen		= $4000	; caused a penalty
pf2npc		= $8000	; no player collision
pf2inj		= $0004	; injured
; sflags3 bits
sf3llcs		= $0001	; lower line change box on screen
sf3rmplay	= $0002	; replay play mode on
sf3sbut		= $0008	; Start pressed during the highlights: skip the rest
sf3fo		= $0010	; face off just ended: the next puck pickup wins it
sf3icetime	= $0020	; count frames on ice per player
; iflags bits
ifcgl		= $0001	; puck crossed the goal line
ifdir		= $0002	; icing toward the top goal
ifok		= $0004	; icing possible
; attribute bits
attrxflip	= $0800	; x flip
attryflip	= $1000	; y flip
; tmflags bits
tmfmid		= $0002	; nearest player takes the spot between puck and own goal
tmflcc		= $0001	; line change box needs redrawing
tmflast		= $0004	; next touch overwrites the last touch only
tmflc		= $0008	; team in line change mode
tmfoffside	= $0010	; team offsides
; joypad
cbut		= $0080	; shoot / check button in d2
; rink
blueline	= $58	; blueline
goalline	= $B0	; blueline+goalline = $108
; assignments
abench			= $0B	; abench
apuckc			= $10	; apuckc
anearest	= $11	; anearest
ashoot			= $12	; ashoot
adefd		= $02	; adefd
awingd		= $03	; awingd
acenterd	= $05	; acenterd
aeben		= $09	; aeben (from the bench)
aepen		= $0A	; aepen (from the penalty box)
apenalty	= $0C	; apenalty
ascore		= $07	; ascore (assignment 7)
afight		= $14	; afight
afwatch		= $15	; afwatch
pnothing	= $1A	; pnothing
pfaceoff	= $1B	; pfaceoff
agoalie		= $0E	; agoalie
agoalietopuck	= $0F	; assgoalietopuck (asstab $F)
apassrec	= $13	; apassrec
afaceoff	= $16	; afaceoff
afaceoffpl	= $17	; afaceoffpl (assfaceoffp1)
pnorm		= $18	; pnorm (pucknorm)
pfaceoff2	= $1C	; pfaceoff2
; penalties
PenOOP		= $06	; face off / out of play (penalty 6): puck still too long, puck over the glass
PenGhold	= $08	; goalie held the puck / bump
PenWhistle	= $0A	; whistle
PenIcing	= $0C	; PenIcing
PenGoal		= $0E	; goal
PenOffsides	= $10	; PenOffsides
PenRough2	= $12	; roughing with slow down time $A
PenInjury	= $14	; injury stop, no text
PenCharge	= $16	; charging
PenSlash	= $18	; slashing
PenRough	= $1A	; roughing
PenCross	= $1C	; cross check
PenHook		= $1E	; hooking
PenTrip		= $20	; tripping
PenInt		= $22	; interference
PenHold		= $24	; holding
PenFight	= $26	; fighting, also the penalty byte of a fight in the list (93 $26)
PenFighting	= $28	; fighting *
PenInst		= $2A	; fight instigator
PenDelay	= $2C	; delayed penalty ref (93 $2C)
; animations (offsets into the animation data; value in the comment)
; SPA values: offsets of the SPAList tables (bank82_C000 asserts each one). named and ordered like the 68000 frame tables
SPAgready	= $0002	; SPAgready $2: goalie ready (loops)
SPAgready2	= $0134	; SPAgready2 $134
SPAgglover	= $0166	; SPAgglover $166: glove save (GoalieSaveList 0)
SPAgglovel	= $0198	; SPAgglovel $198: glove save (GoalieSaveList 1)
SPAgstickr	= $01CA	; SPAgstickr $20C: stick save (GoalieSaveList 4)
SPAgstickl	= $01FC	; SPAgstickl $23E: stick save (GoalieSaveList 5)
SPAgstackr	= $022E	; SPAgstackr $270: stack pad save (GoalieSaveList 2)
SPAgstackl	= $0280	; SPAgstackl $2C2: stack pad save (GoalieSaveList 3)
SPAgswing	= $02D2	; SPAgswing $386
SPAgskate	= $0344	; SPAgskate $3F8: goalie skating
SPApflip	= $03D6	; SPApflip $48A: puck spin
SPAglide	= $0478	; SPAglide $52C: glide
SPAskatewp	= $04AA	; SPAskatewp $55E
SPAskate	= $055C	; SPAskate $5F0
SPAturnl	= $060E	; SPAturnl $682
SPAturnr	= $0640	; SPAturnr $6B4
SPAstop		= $0672	; SPAstop $6E6: stop
SPApassf	= $06C4	; SPApassf $738
SPApassb	= $0736	; SPApassb $7AA
SPAshotf	= $07A8	; SPAshotf $81C: forehand shot
SPAshotb	= $08BA	; SPAshotb $94E: backhand shot
SPAglideback	= $09CC	; SPAglideback $A80
SPAskateback	= $09FE	; SPAskateback $AB2
SPAsweepchk	= $0A90	; SPAsweepchk $B44: sweep check
SPAshoulderchkl	= $0B02	; SPAshoulderchkl $BB6
SPAshoulderchkr	= $0B34	; SPAshoulderchkr $BE8
SPAhipchkl	= $0B66	; SPAhipchkl $C1A
SPAhipchkr	= $0B98	; SPAhipchkr $C4C
SPAburst	= $0BCA	; SPAburst $C7E: check button burst
SPAHold		= $0BFC	; SPAHold $CB0: hold
SPAHold2	= $0C2E	; SPAHold2 $CE2
SPAflail	= $0C60	; SPAflail $D14
SPAfallfwd	= $0C92	; SPAfallfwd $D46
SPAfallback	= $0D44	; SPAfallback $DF8
SPAcelebrate	= $0DF6	; SPAcelebrate $EAA
SPApump		= $0E68	; SPApump $F1C
SPAfight	= $0EDA	; SPAfight $F8E: fight
SPAfgrab	= $0F0C	; SPAfgrab $FC0
SPAfheld	= $0F2E	; SPAfheld $FE2
SPAfhigh	= $0F50	; SPAfhigh $1004
SPAflow		= $0F82	; SPAflow $1036
SPAfhith	= $0FB4	; SPAfhith $1068
SPAfhitl	= $0FD6	; SPAfhitl $108A
SPAffall	= $0FF8	; SPAffall $10AC
SPAwallright	= $101A	; SPAwallright $1128
SPAwallleft	= $1058	; SPAwallleft $1166
SPAfaceoff	= $1096	; SPAfaceoff $11A4: faceoff pull
SPAfaceoffr	= $10C0	; SPAfaceoffr $11CE: faceoff ready
SPAsiren	= $10DA	; SPAsiren $11E8: goal siren on the puck shadow
SPAstanley	= $1124	; SPAstanley $1258
SPAfinjury	= $1156	; SPAfinjury $10CE: fight injury (fight loser down)
SPAflip		= $11B0	; SPAflip $1524: third fall animation (flip)
SPAstumble	= $12A2	; SPAstumble $13A0: stumble instead of a fall
SPAhook		= $1354	; SPAhook $12DC: hold/hook (holdplayer, Acheck)
SPAhook2	= $1386	; SPAhook2 $130E
SPAcatch	= $1418	; SPAcatch $128A: player hit by a slow puck
SPAbglass	= $146A	; SPAbglass $1232: the puck shadow over the glass
SPAgdive	= $1490	; SPAgdive $314: goalie dive (temp5 = 5 after a save)
SPAinjury1	= $1502	; SPAinjury1 $1616: injured: no movement, no bounce (SNES frames differ from )
; sprite frame bases (SPF): first frame of each group in the SNES sprite set. named like the 68000 frame tables; frames from SPFpuck on
; are one lower than (no SPFreplay frame) and the goalie and 93-only groups are laid out differently
SPFskatewp	= 1	; 1
SPFskate	= 41	; 41
SPFturnl	= 81	; 81
SPFturnr	= 89	; 89
SPFswing	= 97	; 97
SPFstop		= 145	; 145
SPFskateb	= 161	; 161
SPFcelebrate	= 185	; 185
SPFpump		= 201	; 201
SPFcup		= 217	; 217
SPFhipl		= 225	; 225
SPFhipr		= 233	; 233
SPFshoulderl	= 241	; 241
SPFshoulderr	= 249	; 249
SPFsweep	= 257	; 257
SPFfallback	= 273	; 273
SPFfallfwd	= 305	; 305
SPFduck		= 337	; 337
SPFhold		= 345	; 345
SPFgloves	= 353	; 353
SPFfight	= 354	; 354
SPFfinjury	= 371	; 371
SPFPen		= 377	; 377
SPFarrow	= 384	; 384
SPFpad		= 390	; 390
SPFpuck		= 393	; 394
SPFgoal		= 404	; 405
SPFGoalie	= 406	; 407
SPFgdive	= 643	; 519
SPFgready	= 627	; 539
SPFSiren	= 518	; 555
SPFcatch	= 606	; 569
SPFhook		= 590	; 585
SPFstumble	= 566	; 601
SPFflip		= 558	; 625
SPFbglass	= 622	; 645
; sounds (sfx numbers)
SFXstop		= $9C	; +0/1: skate stop (dostop, controlled player)
SFXshotwiff	= $98	; +0-3: missed shot (doshot)
SFXshotfh	= $8D	; forehand shot (93 $18)
SFXshotbh	= $8E	; backhand shot (93 $14)
SFXshothard	= $8F	; shot with passspeed >= $32
SFXcrowdcheer	= $8A	; home player won the fight (93 song $B)
SFXcrowdboo	= $8B	; visitor won the fight (93 song $C)
SFXhithigh	= $92	; SFXhithigh 9
SFXhitlow	= $93	; SFXhitlow $A
SFXpuckbody	= $90	; +0/1: puck hits a body (93 $24)
SFXsavehome	= $8A	; hard shot saved by the home goalie (93 song $B)
SFXsaveaway	= $8C	; hard shot saved by the visiting goalie (93 song $D)
SFXoverglass	= $8C	; puck over the glass (93 $E)
SFXpuckwall1	= $95	; +0-2: puck off the boards by speed (93 $28-$2B)
SFXpuckpost		= $94	; puck off the post
SFXsiren	= $A0	; goal siren
SFXwhistle	= $89	; whistle
SFXcheck	= $90	; +0/1: check (93 $1C-$1F)
SFXplayerwall	= $9E	; +0/1: player hits the boards (93 $20)
; joypad bits (SNES)
JOYSTART	= $1000	; Start
JOYR		= $0010	; R shoulder
JOYL		= $0020	; L shoulder
JOYRIGHT	= $0100	; dpad right
JOYLEFT		= $0200	; dpad left
JOYDOWN		= $0400	; dpad down
JOYUP		= $0800	; dpad up
JOYA		= $0080	; A button
bbut		= $8000	; B: pass / switch player
abut		= $4000	; Y: hold / line change
; injury
INJfight	= $112C	; tmpdst value for a player injured in a fight (93 $112C)
; tmpdst values
TMPDICE		= $FFFF	; on the ice
TMPDBENCH	= $FFFE	; on the bench
TMPDOUT		= $FFFD	; out of the game
TMPDINJ		= $1000	; injured: box time with this bit has no penalty

OFFSCREEN	= $4E20	; projxy: d1 for a point off the screen (20000)
; --- addresses: puck fields (need puckobj above) ---
puckx		= Xpos+puckobj	; puckx
pucky		= Ypos+puckobj	; pucky
puckvx		= Xvel+puckobj	; puckvx
puckvy		= Yvel+puckobj	; puckvy
puckvz		= Zvel+puckobj	; puckvz
puckc		= newpos+puckobj	; SCnum of the puck carrier, negative = loose. puckc (puck newpos)
