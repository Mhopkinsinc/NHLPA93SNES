StartHL2:		;Play the highlight of playoff game a0 with its score; Start or A ends it, and a tie gets a random winner
	lda.w sflags3		; Start pressed before: no more highlights
	bit.w #sf3sbut
	beq .go
	jmp.w .nhl0
.go:
	jsl.l .sv		; save the game state
	lda.b d1
	sta.b d3
	jsl.l NewTicker3		; the score of the highlight game, bank $8F
	lda.w sflags3
	bit.w #sf3sbut
	beq .show
	jmp.w .nhl1
.show:
	lda.w #$0004		; Framer 24 x 3
	sta.w printx
	lda.w printy
	sec
	sbc.w #$0006
	sta.w printy
	lda.w #24
	sta.b d0
	lda.w #3
	sta.b d1
	jsl.l Framer		; d0 x d1
	inc.w printx
	dec.w printy
	dec.w printy
	jsl.l printz
	dw $0016		; printz inline string: length (counts itself), then control bytes / text
	db "Highlight from game:"
	lda.w #180		; 180 frames, Start skips
	sta.b d0
	jsl.l waitxsr		; wait d0 frames or a button
	lda.b d1
	bit.w #JOYSTART
	beq .play
	jmp.w .nhl1
.play:
	jsl.l forceblack
	jsl.l sndqreset
	lda.w sndbank
	cmp.w #$0001
	beq .snd
	jsl.l SPCGameUpload
.snd:
	ldy.b a0		; HomeTeam/VisTeam of game a0
	lda.w gst1,y
	sta.w HomeTeam
	lda.w gst2,y
	sta.w VisTeam
	stx.b xsave
	ldx.w #$0000
.pushg:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pushg
	ldx.b xsave
	jsl.l ClearTeamStats
	jsl.l restoreteams
	stz.b a2
	jsl.l reenergizeteam
	lda.w #$0002
	sta.b a2
	jsl.l reenergizeteam
	lda.w #$FFFF
	sta.w c1playernum
	sta.w c2playernum
	stz.w cont1team
	stz.w cont2team
	lda.w #120		; gameclock = 120 + random 120
	jsl.l randoma
	adc.w #120
	sta.w gameclock
	stx.b xsave
	ldx.w #$0002
.popg:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popg
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pushg2:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pushg2
	ldx.b xsave
	ldy.b a0		; gsp, scores from the game
	lda.w gsper,y
	dec a
	sta.w gsp
	lda.w gss1,y
	sta.w tmscore
	lda.w gss2,y
	sta.w tmscore+2
	lda.w #gmhl		; gmode = gmhl
	sta.w gmode
	stz.w gmclock
	lda.w gsp		; odd period: gmdir
	lsr a
	bcc .ndi
	lda.w #gmdir
	tsb.w gmode
.ndi:
	stz.w sflags3
	lda.w #sf2drec		; sflags = sf2drec
	sta.w sflags
	stz.w sfhormode
	stz.w glovecords
	stz.w iflags
	lda.w #$FFFF		; RefCnt, puckcross times -1
	sta.w RefCnt
	sta.w puckcross+2
	sta.w puckcross+6
	jsl.l setupice
	jsl.l ClrHor
	stz.w Vpos
	stz.w Hpos
	jsl.l ResetBench
	stz.b a2
	jsl.l .setteam
	lda.w #$0002
	sta.b a2
	jsl.l .setteam
	jsl.l resetplstuff
	lda.w #11		; 12 players to their .postab spots
	sta.b d0
	lda.w #.postab
	sta.b a0
	lda.w #.postab>>16
	sta.b a0+2
	stz.b a1
.ploop:
	ldx.b a1
	lda.w position,x
	sta.b d1
	lda.w pfgoal,x
	bne .pl0
	lda.b d1
	clc
	adc.w #6
	sta.b d1
.pl0:
	asl.b d1
	asl.b d1
	ldy.b d1
	lda.b [a0],y
	sta.w Xpos,x
	iny
	iny
	lda.b [a0],y
	sta.w Ypos,x
	stz.w Xvel,x
	stz.w Yvel,x
	inc.b a1
	inc.b a1
	dec.b d0
	bpl .ploop
	jsl.l SprSort
	lda.w #180		; 180 frames after the clock stops
	pha
	lda.b vcount
	sta.w oldvcount
.0:		;wait for the next frame
	lda.b vcount		; the frame time steps as the game loop
	cmp.w oldvcount
	beq .0
	tax
	sec
	sbc.w oldvcount
	sta.b d7
	asl a
	sta.b impactstep
	asl a
	asl a
	asl a
	sta.b velstep
	asl a
	sta.b gravstep
	asl a
	adc.b gravstep
	sta.b gravstep
	lda.b velstep
	asl a
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b d7x1024
	stx.w lastframevc
	stx.w oldvcount
	jsl.l ReadPads
	lda.w sflags
	bit.w #sfpz
	bne .frame
	lda.w gmclock
	bne .frame
	ldx.b d7
.clk:
	lda.w gameclock		; run the clock
	beq .clk1
	lda.w gameclock+2
	sec
	sbc.w #$0AAA
	sta.w gameclock+2
	bcs .clk1
	dec.w gameclock
.clk1:
	dex
	bne .clk
.frame:
	lda.b d7
	pha
	jsl.l DoGameFrame
	pla
	sta.b d7
	lda.w gmclock
	beq .1
	pla
	sec
	sbc.b d7
	pha
	bmi .endhl
.1:
	jsl.l Readjoy12		; Start or A ends it
	lda.b d1
	bit.w #JOYSTART|JOYA
	beq .0
	lda.w tmscore		; tied: random goal
	cmp.w tmscore+2
	bne .endhl
	jsl.l random
	and.w #$0002
	tax
	inc.w tmscore,x
.endhl:
	pla
	stx.b xsave
	ldx.w #$0002
.popg2:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popg2
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pushd1:
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pushd1
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha0:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha0
	ldx.b xsave
	jsl.l KillCrowd
	jsl.l sndqreset
	stx.b xsave
	ldx.w #$0002
.popa0:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa0
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.popd1:
	pla
	sta.b d1,x
	dex
	dex
	bpl .popd1
	ldx.b xsave
	ldy.b a0		; back into the game record
	lda.w tmscore
	sta.w gss1,y
	lda.w tmscore+2
	sta.w gss2,y
	lda.b d1		; Start: skip
	bit.w #JOYSTART
	beq .stats
	jmp.w .nhl1
.stats:
	jsl.l forceblack
	jsl.l .lo		; restore the game state
	jsl.l setplayercolors
	jsl.l SetHor
	jsl.l setvideo
	jsl.l printz		; DisplayStats box
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0C
	lda.w #22
	sta.b d0
	lda.w #7
	sta.b d1
	jsl.l Framer		; d0 x d1
	jsl.l printscores1
	jsl.l Pmenu		; DisplayStats
	stx.b xsave
	ldx.w #$001A
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
	cpx.w #$001C
	bne .savea
	ldx.b xsave
	ldy.b a0
	lda.w #4		; gsper 4: tied after the highlight: again
	sta.w gsper,y
	lda.w gss1,y
	cmp.w gss2,y
	bne .won
	jmp.w StartHL2
.won:
	lda.w #5		; gsper 5: final
	sta.w gsper,y
	lda.b d1
	sta.b d3
	jsl.l NewTicker3
	lda.w #180
	sta.b d0
	jsl.l waitxsr		; wait d0 frames or a button
	lda.b d1
	bit.w #JOYSTART
	beq .exit
.exit2:
	lda.w #sf3sbut
	tsb.w sflags3
.exit:
	stx.b xsave
	ldx.w #$001A
.resta2:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta2
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.restore2:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore2
	ldx.b xsave
	ldx.b a3
	rtl
.nhl1:
	jsl.l .lo
	jsl.l .ranres
	bra .exit2
.nhl0:
	jsl.l .ranres
	bra .exit
.setteam:		;SNES: team a2 for the highlight: energy, setpersonel, forcepldata, no last touches
	jsl.l reenergizeteam
	jsl.l setpersonel
	jsl.l forcepldata
	ldy.b a2
	lda.w #$FFFF
	sta.w tmtouch1,y
	sta.w tmtouch2,y
	sta.w tmtouch3,y
	rtl
.ranres:		;a tie gets a random one-goal winner; gsper 5 (final)
	ldy.b a0
	lda.w gss1,y
	cmp.w gss2,y
	bne .rr0
	lda.w #2
	jsl.l randoma
	ldy.b a0
	pha
	clc
	adc.w gss1,y
	sta.w gss1,y
	pla
	eor.w #$0001
	adc.w gss2,y
	sta.w gss2,y
.rr0:
	lda.w #5
	sta.w gsper,y
	rtl
.sv:		;save the game state (gmode-1 .. ScoreSumbytes) to hlsavebuf
	ldx.w #$0000
.sv1:
	lda.w gmode-1,x
	sta.l hlsavebuf,x
	inx
	inx
	cpx.w #$02F7
	bcc .sv1
	lda.w ScoreSumbytes
	sta.l hlsavebuf,x
	inx
	inx
	stz.w tmgoalie
	stz.w tmgoalie+2
	rtl
.lo:		;restore the game state from hlsavebuf
	ldx.w #$0000
.lo1:
	lda.l hlsavebuf,x
	sta.w gmode-1,x
	inx
	inx
	cpx.w #$02F7
	bcc .lo1
	lda.l hlsavebuf,x
	inx
	inx
	sta.w ScoreSumbytes
	rtl
.postab:		;x, y start spot by position (0-5 attacking up, 6-11 down)
	dw 0,-240
	dw -70,-140
	dw 20,-110
	dw -100,-60
	dw 25,-40
	dw 70,-80
	dw 0,240
	dw 34,90
	dw -55,80
	dw 100,40
	dw -10,10
	dw -50,0
