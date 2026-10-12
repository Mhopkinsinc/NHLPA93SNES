; The game, screens, menus, password, playoffs.
; Bank $8D. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8D8000
maketree:		;make playoff tree (potree) from playoffseats/winbits.
		;   SNES: potree from playoffseats (postarts) and WinBits; reset the games of this round (.sett), then FigureJoy
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0014
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
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
.0:		;winbit picks the team of each pair
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
	bpl .0
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
.2:
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
	bpl .2
	jsl.l FigureJoy
.nogames:
	stx.b xsave
	ldx.w #$000E
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0012
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
.sett:		;series games 2, 3, 5 in tree order, the others flipped (gsftf)
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

org $8D8217
StartPer:		;start a period: reset stack, rink and clock, face off, run the game loop
		;   SNES: reset the stack, rink and clock, faceoff at centre ice, music cue timers, replay reset; then Gameloop
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

org $8D8389
Bcheck:		;player a2 is in SPA $B44 and a3 is the other player. Entered from checkcheck .cc. If OptPen is 0 and a2 is joystick controlled, a2 needs randomd0($10 + a2 checking rating - a3
		;   legstr) >= $C. If a3 is within 1 direction of where a2 faces, a3 falls and checkagr may call penalty $20 on a2. Sets collflag to -1
		;   SNES: a2 checks a3 with SPA $B44: if a3 is in front (within one direction) he falls; checkagr may call a penalty $20 (charging) on
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
	jsl.l checkagr
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
ContinuePlayoffs:		;continue playoffs: read the playoff state back from the password bits, rebuild the tree.
		;   SNES: no caller found
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
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
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl

org $8D84E2
DrawTeamBlocks:		;draw team block d1 (team*2) from TeamBlocks.map at printx/printy
		;   SNES: the 9 x 2 TeamBlocksMap block of team d1 into textmap at printx/printy (scorechars, printa)
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

org $8D85A9
PeriodOver:		;what to do if period over. Branched to from puckfaceoff when the clock runs out.
		;   SNES: next period (gmdir flips); overtime only for a tied playoff game; gsp 4 = game over (GameOver), else StartPer
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
	jsl.l Intermission
	lda.w gsp
	cmp.w #$0004
	bne .per
	jml.l GameOver
.per:
	jmp.w StartPer
GetPlayerName:		;a1 = mesarea "NN First Last" (getname) for player TempPlOffset (bit 15 set: away team)
		;   SNES: mesarea = number and name of player TempPlOffset (bit 15: away team) via PlayerNumName
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea2:
	lda.b a2,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea2
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
.resta2:
	pla
	sta.b a2,x
	dex
	dex
	bpl .resta2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl

org $8D86A8
asstab:		;SNES: the assignment routines (29 long pointers) that updateplayers calls through jmlvector; numbers as asstab
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

org $8D87FB
setd0player:		;give control of player d0 to a controller if his team is controlled
		;   SNES: give player d0 to the controller of his team (setc1player/setc2player) unless a controller has him already
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
