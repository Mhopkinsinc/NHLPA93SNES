; $8D8000-$8D900B  ROM $68000-$6900B: maketree (hockey93_09), InitPPU, StartPer (hockey93_01), GetLowestPen (penalty93_1), Bcheck (hockey93_03),
; NewPO93, eraser, DrawTeamBlocks, EASNLogo (penalty93_2), PeriodOver, GetPlayerName, updatesound, asstab, mulu16, puckshadow, setd0player;
; then SpriteSet10 (frame set 10), tiles continue to bank8D_E000.
org $8D8000
maketree:		;93G maketree (hockey93_09): potree from playoffseats (postarts) and WinBits; reset the games of this round (.sett), then FigureJoy
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
	lda.w postarts		; a1 = playoffseats + 16 * postarts
	asl a
	asl a
	asl a
	asl a
	sta.b d1
	lda.w #potree
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	lda.w #playoffseats
	clc
	adc.b d1
	sta.b a1
	lda.w #playoffseats>>16
	sta.b a1+2
	ldy.w #$000E
	sty.b d2
.first:		;first round: 16 teams from the tree
	lda.b [a1],y
	sta.b [a0],y
	dey
	dey
	bpl .first
	lda.w #potree+16		; winners into potree+16..
	sta.b a1
	lda.b a0+2
	sta.b a1+2
	lda.w WinBits
	sta.b d0
.zero:		;93G .0: winbit picks the team of each pair
	lda.b d0
	and.w #$0001
	sta.b d1
	tay
	sep #$20
	lda.b [a0],y
	sta.b [a1]
	rep #$20
	inc.b a1
	inc.b a0
	inc.b a0
	lsr.b d0
	dec.b d2
	bpl .zero
	jsl.l GetShifter		; d1 = games of this round, d2 = first slot
	lda.b d1
	bmi .nogames
	lda.b d2
	asl a
	adc.w #potree
	sta.b a0
	lda.w #$0000
	sta.b a0+2
	stz.b a1
.two:		;93G .2
	ldx.b a1
	stz.w gss1,x
	stz.w gss2,x
	stz.w gsper,x
	lda.w gsflags,x
	and.w #~gsfhl&$FFFF
	sta.w gsflags,x
	jsl.l .sett
	inc.b a1
	inc.b a1
	dec.b d1
	bpl .two
	jsl.l FigureJoy
.nogames:
	stx.b xsave
	ldx.w #$000E
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0012
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl
.sett:		;93G .sett: series games 2, 3, 5 in tree order, the others flipped (gsftf)
	lda.b bosgames		; bosgames 2, 3, 5
	cmp.w #$0002
	beq .flip
	cmp.w #$0003
	beq .flip
	cmp.w #$0005
	beq .flip
	lda.w gsflags,x
	ora.w #gsftf
	sta.w gsflags,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w gst2,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w gst1,x
	rtl
.flip:
	lda.w gsflags,x
	and.w #~gsftf&$FFFF
	sta.w gsflags,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w gst1,x
	lda.b [a0]
	inc.b a0
	and.w #$00FF
	sta.w gst2,x
	rtl
InitPPU:		;SNES: all PPU and CPU I/O registers to their reset values (forced blank, mode 0, no layers, NMI off)
	sep #$20
	lda.b #INIDISP_FBLANK|$0F
	sta.w INIDISP
	stz.w OBSEL
	stz.w OAMADDL
	stz.w OAMADDH
	stz.w BGMODE
	stz.w MOSAIC
	stz.w BG1SC
	stz.w BG2SC
	stz.w BG3SC
	stz.w BG4SC
	stz.w BG12NBA
	stz.w BG34NBA
	stz.w BG1HOFS
	stz.w BG1HOFS
	stz.w BG1VOFS
	stz.w BG1VOFS
	stz.w BG2HOFS
	stz.w BG2HOFS
	stz.w BG2VOFS
	stz.w BG2VOFS
	stz.w BG3HOFS
	stz.w BG3HOFS
	stz.w BG3VOFS
	stz.w BG3VOFS
	stz.w BG4HOFS
	stz.w BG4HOFS
	stz.w BG4VOFS
	stz.w BG4VOFS
	lda.b #VMAIN_INCHI
	sta.w VMAIN
	stz.w VMADDL
	stz.w VMADDH
	stz.w M7SEL
	stz.w M7A
	lda.b #$01
	sta.w M7A
	stz.w M7B
	stz.w M7B
	stz.w M7C
	stz.w M7C
	stz.w M7D
	sta.w M7D
	stz.w M7X
	stz.w M7X
	stz.w M7Y
	stz.w M7Y
	stz.w CGADD
	stz.w W12SEL
	stz.w W34SEL
	stz.w WOBJSEL
	stz.w WH0
	stz.w WH1
	stz.w WH2
	stz.w WH3
	stz.w WBGLOG
	stz.w WOBJLOG
	stz.w TM
	stz.w TS
	stz.w TMW
	stz.w TSW
	lda.b #$30
	sta.w CGWSEL
	stz.w CGADSUB
	lda.b #$E0
	sta.w COLDATA
	stz.w SETINI
	stz.w NMITIMEN
	lda.b #$FF
	sta.w WRIO
	stz.w WRMPYA
	stz.w WRMPYB
	stz.w WRDIVL
	stz.w WRDIVH
	stz.w WRDIVB
	stz.w HTIMEL
	stz.w HTIMEH
	stz.w VTIMEL
	stz.w VTIMEH
	stz.w MDMAEN
	stz.w HDMAEN
	lda.b #$01
	sta.w MEMSEL
	rep #$30
	rtl
StartPer:		;93G StartPer (hockey93_01): reset the stack, rink and clock, faceoff at centre ice, music cue timers, replay reset; then the game loop ($8E8000)
	lda.w #$1FFF		; reset the stack
	tcs
	jsl.l Readjoy1
	jsl.l Readjoy2
	jsl.l Readjoy1
	jsl.l Readjoy2
	jsl.l Readjoy1
	jsl.l Readjoy2
	jsl.l Readjoy1
	jsl.l Readjoy2
	stz.b a2
	jsl.l reenergizeteam
	lda.w #$0002
	sta.b a2
	jsl.l reenergizeteam
	jsl.l sndqreset
	stz.b sprclock		; sprite VRAM slots
	jsl.l setupice
	jsl.l ResetClock
	lda.w #$F000
	tsb.w PadControlBits
	lda.w #$FFFF		; no controlled players
	sta.w c1playernum
	sta.w c2playernum
	sta.w lcplayer
	ldx.w #puckobj		; puck: puckfaceoff at centre ice
	stx.b a3
	stz.w fox
	stz.w foy
	lda.w #$1B
	sta.b d0
	jsl.l assreplace
	lda.w gsp		; third period: p3cue = random time
	cmp.w #$0002
	bne .p3
	lda.w gameclock
	sta.b mula
	lda.w #12
	sta.b mulb
	jsl.l mulu16
	jsl.l randoma
	inc a
	sta.w p3cue
.p3:
	lda.w gsp		; periods 1 and 2: mid-period cue at half time
	cmp.w #$0002
	bcs .blank
	lda.w gameclock
	lsr a
	sta.w midpercue
.blank:
	lda.w blankchar
	clc
	adc.w charofs
	ldx.w #$07FE
.clr:
	sta.l textmap,x
	dex
	dex
	bpl .clr
	lda.w #sf2drec		; sf2drec: no replay record
	tsb.w sflags
	lda.w #sfwrap		; sfwrap off
	trb.w sflags
	stz.w lastsfx
	lda.w #ReplayBufferStart		; replay buffer start
	sta.w ReplayBufferPtr
	lda.w #ReplayBufferStart>>16
	sta.w ReplayBufferPtr+2
	lda.w #$FFFF
	sta.b textdirtylo
	stz.b textdirtyhi
	inc.w percue		; period start music cue
	stz.b vcount
	stz.b vcount+2
	stz.w lastframevc
	stz.w oldvcount
	jml.l Gameloop		; the game loop (bank $8E)
GetLowestPen:		;93G GetLowestPen (penalty93_1): a2 = team on the power play, a3 = the other. d0 = power play time left from the penalty box times
	stz.b d0
	stz.b d3
	lda.b a2
	beq .a
	lda.w #$001A
.a:
	sta.b a0
.loop:
	ldy.b a0		; penalty box list of the power play team ($80 ends)
	inc.b a0
	lda.w tmboxlist,y
	and.w #$00FF
	sta.b d2
	bit.w #$0080
	bne .other
	lda.b a2
	beq .h0
	lda.w #$0034
.h0:
	clc
	adc.b d2
	tay
	lda.w tmpdst,y
	sta.b d2
	bit.w #$4000		; tmpdst bit 14: not timed
	bne .loop
	lda.b d2
	sec
	sbc.b d3
	sta.b d2
	clc
	adc.b d0
	sta.b d0
	lda.b d2
	sta.b d3
	bra .loop
.other:
	ldy.b a3		; shorthanded team
	lda.w tmap,y
	cmp.w #6
	beq .rtl
	lda.b d0
	sec
	sbc.b d3
	sta.b d0
	lda.b a3
	beq .b
	lda.w #$001A
.b:
	sta.b a0
.loop2:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d2
	bit.w #$0080
	bne .rtl
	lda.b a3
	beq .h1
	lda.w #$0034
.h1:
	clc
	adc.b d2
	tay
	lda.w tmpdst,y
	bit.w #$4000
	bne .loop2
	lda.b d0
	sec
	sbc.w tmpdst,y
	bmi .lt
	bvc .add
	bra .rtl
.lt:
	bvc .rtl
.add:
	lda.b d0
	clc
	adc.b d3
	sta.b d0
.rtl:
	rtl
Bcheck:		;93G Bcheck (hockey93_03): a2 checks a3 with SPA $B44: if a3 is in front (within one direction) he falls; checkagr may call a penalty $20 (charging) on
		;   a2
	ldy.b a2
	lda.w pfalock,x
	beq .pos
	jmp.w .rtl
.pos:
	lda.w position,x
	bne .fight
	jmp.w .rtl
.fight:
	lda.w pf2fight,x
	bne .rtl
	lda.w OptPen		; penalties off: a2 needs randomd0($10 + aggression - a3 legstr) >= 12
	bne .dir
	lda.w pflags,y
	bit.w #pfjoycon
	beq .dir
	lda.w #16
	clc
	adc.w aggress,y
	sec
	sbc.w legstr,x
	jsl.l randoma
	cmp.w #12
	bcc .rtl
.dir:
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	jsl.l vtoa
	ldy.b a2
	lda.b d0		; within one direction of a2 facing
	sec
	sbc.w facedir,y
	inc a
	and.w #$0007
	cmp.w #$0003
	bcs .rtl
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l FallDown		; a3 falls
	jsl.l checkagr		; 93G checkagr
	lda.b d0
	cmp.w #$0005
	bcs .swap
	lda.w #$20		; penalty $20
	sta.b d0
	jsl.l AddPenalty
.swap:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w #$FFFF
	sta.b collflag
.rtl:
	rtl
NewPO93:		;93G NewPO (hockey93_09): continue the playoffs from passbits (ReadPassBits, maketree, OptPlayers = 7 - pojoy); no caller found (92G NewPO is at $8B8000)
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
	ldx.b xsave
	lda.w #passbits		; a3 = passbits
	sta.b a3
	lda.w #$0000
	sta.b a3+2
	jsl.l ReadPassBits
	lda.w gamelevel
	ora.b bosgames
	sta.b d0
	beq .ex
	jsl.l maketree
	lda.w #$0007		; menu value from pojoy
	sec
	sbc.w pojoy
	sta.w OptPlayers
.ex:
	stx.b xsave
	ldx.w #$000E
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl
eraser:		;92G eraser: fill d0 x d1 textmap words at printx/printy (print map printm) with tile d2 (+ printfontset)
	phx
	lda.b d2
	clc
	adc.w printfontset
	sta.b d2
	stz.b d1+2
.row:
	lda.w printy
	clc
	adc.b d1+2
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.b printm
	tax
	ldy.b d0
	lda.b d2
.col:
	sta.l textmap,x
	inx
	inx
	dey
	bne .col
	inc.b d1+2
	lda.b d1+2
	cmp.b d1
	bne .row
	plx
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	cmp.b textdirtylo
	bcs .hi
	sta.b textdirtylo
.hi:
	lda.w printy
	clc
	adc.b d1
	and.w #$001F
	sta.w printy
	dec a
	and.w #$001F
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	adc.b d0
	dec a
	cmp.b textdirtyhi
	bcc .rtl
	sta.b textdirtyhi
.rtl:
	rtl
DrawTeamBlocks:		;93G DrawTeamBlocks (hockey93_06): the 9 x 2 TeamBlocksMap block of team d1 into textmap at printx/printy (scorechars, printa)
	lda.b a2
	pha
	phx
	lda.b d1		; 36 bytes per team
	sta.b mula
	lda.w #36
	sta.b mulb
	jsl.l mulu16
	tay
	lda.w #TeamBlocksMap
	sta.b a2
	lda.w #TeamBlocksMap>>16
	sta.b a2+2
	lda.w printy
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w printx
	asl a
	adc.b printm
	tax
	lda.w #9
	sta.b tmp0
	sta.b tmp1
.row1:
	lda.b [a2],y
	clc
	adc.w scorechars
	adc.w printfontset
	ora.w printa
	sta.l textmap,x
	iny
	iny
	inx
	inx
	dec.b tmp0
	bne .row1
.row2:
	lda.b [a2],y
	clc
	adc.w scorechars
	adc.w printfontset
	ora.w printa
	sta.l textmap+$2E,x
	iny
	iny
	inx
	inx
	dec.b tmp1
	bne .row2
	plx
	pla
	sta.b a2
	rtl
EASNLogo:		;93G EASNLogo (penalty93_2): the EASN logo (7 x 2 words, $8F824D) at x 1, y $19 of the rink map unless a power play is on
	lda.w sflags
	bit.w #sf2pwrplay
	bne .rtl
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19
	stz.b tmp0
	stz.b tmp1
	lda.w #$0002
	sta.b tmp2
.row:
	lda.w #$0007
	sta.b tmp2+2
.col:
	ldx.b tmp0
	lda.l EASNLogoMap,x
	clc
	adc.w unusedchars
	adc.w charofs
	ldx.b tmp1
	ora.w #$2000
	sta.l textmap+$642,x
	inc.b tmp0
	inc.b tmp0
	inc.b tmp1
	inc.b tmp1
	dec.b tmp2+2
	bne .col
	lda.b tmp1
	clc
	adc.w #$0032
	sta.b tmp1
	dec.b tmp2
	bne .row
	lda.w #$0321		; dirty range of the rink map rows
	cmp.b textdirtylo
	bcs .hi
	sta.b textdirtylo
.hi:
	lda.w #$0347
	cmp.b textdirtyhi
	bcc .rtl
	sta.b textdirtyhi
.rtl:
	rtl
PeriodOver:		;93G PeriodOver (hockey93_06): next period (gmdir flips); overtime only for a tied playoff game; gsp 4 = game over (ContinuePlayoffs), else StartPer
	jsl.l forceblack
	inc.w gsp		; next period
	lda.w gmode
	eor.w #gmdir
	sta.w gmode
	lda.w gsp
	cmp.w #$0003		; after overtime (period 4+)
	beq .ot
	bcc .next
	lda.w #$0003
	sta.w gsp
	lda.w OptPlayMode
	bne .ot
	lda.w #$0004
	sta.w gsp
.ot:
	lda.w tmscore		; tied: overtime
	cmp.w tmscore+2
	beq .next
	lda.w #$0004
	sta.w gsp
.next:
	jsl.l ResetClock
	jsl.l SetHor
	jsl.l setvideo
	jsl.l UpdateScores
	jsl.l Intermission		; 93G Intermission
	lda.w gsp
	cmp.w #$0004
	bne .per
	jml.l ContinuePlayoffs
.per:
	jmp.w StartPer
GetPlayerName:		;SNES: mesarea = number and name of player TempPlOffset (bit 15: away team) via PlayerNumName
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a2,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha
	ldx.b xsave
	stz.b a2
	lda.w TempPlOffset		; bit 15: away team
	sta.b d0
	bpl .name
	and.w #$00FF
	sta.b d0
	inc.b a2
	inc.b a2
.name:
	jsl.l PlayerNumName
	stx.b xsave
	ldx.w #$0002
.popa:
	pla
	sta.b a2,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
updatesound:		;93G updatesound: move the crowd volume (asv) toward crowdlevel; send it to the sound driver when it changes (crowdvol)
	ldy.b d7
	lda.b crowdlevel		; target volume crowdlevel * 8 + $200 (max $CFF)
	asl a
	asl a
	asl a
	adc.w #$0200
	cmp.w #$0CFF
	bcc .ip
	lda.w #$0CFF
.ip:
	sta.b tmp0
.step:
	lda.b tmp0
	sec
	sbc.w asv
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .pos
	ora.w #$F000
.pos:
	clc
	adc.w asv
	sta.w asv
	dey
	bne .step
	sta.b mula
	lda.w #$009D		; scale to 0-$9D, + $80
	sta.b mulb
	jsl.l mulu
	lda.b mulres+2
	adc.w #$0080
	cmp.w crowdvol
	beq .rtl
	sta.w crowdvol
	pha
	jsl.l sfx8F		; send it
.rtl:
	rtl
asstab:		;SNES: the assignment routines (29 long pointers) that updateplayers calls through jmlvector; numbers as 93G asstab
	dd rtss		; 0
	dd assdefo		; 1
	dd assdefd		; 2
	dd asswingd		; 3
	dd asswingo		; 4
	dd asscenterd		; 5
	dd asscentero		; 6
	dd assscore		; 7
	dd assstanley		; 8
	dd asseben		; 9
	dd assepen		; A
	dd assbench		; B
	dd asspenalty		; C
	dd assdopen		; D
	dd assgoalie		; E
	dd assgoalietopuck		; F
	dd asspuckc		; 10
	dd assnearest		; 11
	dd assshoot		; 12
	dd asspassrec		; 13
	dd assfight		; 14
	dd assfwatch		; 15
	dd assfaceoff		; 16
	dd assfaceoffp1		; 17
	dd pucknorm		; 18
	dd puckshadow		; 19
	dd pucknothing		; 1A
	dd puckfaceoff		; 1B
	dd puckfaceoff2		; 1C
mulu16:		;SNES: 16-bit multiply: A = mula = mulb = mulres = low word of mula * mulb (mode 7 multiplier for a byte factor)
	lda.b mula
	bmi .full
	cmp.w #$0080
	bcc .byteb
	lda.b mulb
	bmi .full
	cmp.w #$0080
	bcs .full
	sep #$20
	sta.w M7B
	lda.b mula
	sta.w M7A
	lda.b mula+1
	sta.w M7A
	rep #$30
	lda.w MPYL
	sta.b mula
	sta.b mulb
	sta.b mulres
	rtl
.byteb:
	lda.b mulb
	bmi .full
	sep #$20
	sta.w M7A
	xba
	sta.w M7A
	lda.b mula
	sta.w M7B
	rep #$30
	lda.w MPYL
	sta.b mula
	sta.b mulb
	sta.b mulres
	rtl
.full:
	sep #$20
	lda.b mula
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	sta.b mulres
	lda.w RDMPYH
	sta.b mulres+1
	lda.b mulb+1
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	lda.b mula+1
	sta.w WRMPYA
	lda.b mulb
	sta.w WRMPYB
	clc
	clc
	clc
	clc
	lda.w RDMPYL
	adc.b mulres+1
	sta.b mulres+1
	rep #$30
	lda.b mulres
	sta.b mula
	sta.b mulb
	clc
	rtl
puckshadow:		;asstab $19. 93G puckshadow: the shadow object follows the puck (frame $189); else parks it behind the goal
	lda.w frame,x
	cmp.w #$0189		; puck frame: shadow under the puck
	bne .none
	lda.w puckx
	sta.w Xpos,x
	lda.w pucky
	sta.w Ypos,x
	stz.w Zpos,x
	lda.w sfhormode
	beq .v
	inc.w Xpos,x
	rtl
.v:
	inc.w Ypos,x
	rtl
.none:
	tay
	beq .rtl
	stz.w Xpos,x
	lda.w #300		; behind the goal
	sta.w Ypos,x
	lda.w #14
	sta.w Zpos,x
	lda.w pucky
	bpl .rtl
	lda.w #$8000
	sta.w attribute,x
	lda.w #-300
	sta.w Ypos,x
	dec.w Zpos,x
.rtl:
	rtl
setd0player:		;93G setd0player: give player d0 to the controller of his team (setc1player/setc2player) unless a controller has him already
	lda.b d0
	cmp.w c1playernum
	beq .rtl
	cmp.w c2playernum
	beq .rtl
	stz.b d1
	cmp.w #$0006
	bcs .away
	dec.b d1
.away:
	inc.b d1
	inc.b d1
	lda.w lastplayer
	cmp.w c2playernum
	beq .c2
	lda.b d1
	cmp.w cont1team
	bne .c2
	jml.l setc1player
.c2:
	lda.b d1
	cmp.w cont2team
	bne .c1
	jml.l setc2player
.c1:
	cmp.w cont1team
	bne .rtl
	jml.l setc1player
.rtl:
	rtl
SpriteSet10:		;frame set 10 (frames 462-517): frames 462-517
	dw 56		; frames
	dw 388		; pieces
	dw 768		; tiles
	dw .pieces-SpriteSet10
	dw .tiles-SpriteSet10
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,9,18,26,33,42,49,57
	dw 64,72,80,83,91,99,104,112
	dw 120,130,135,143,152,158,164,171
	dw 176,180,184,192,196,202,208,216
	dw 224,230,236,244,251,258,264,270
	dw 275,283,292,298,305,311,316,327
	dw 339,345,349,355,360,367,373,380
	dw 388
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set10.pieces"		; $8D88B8-$8D8EC7
	assert .tiles-.pieces == 4*388
.tiles:		;768 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set10.chr":0..$144		; $8D8EC8-$8D900B
