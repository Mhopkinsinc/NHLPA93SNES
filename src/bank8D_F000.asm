; $8DF00C-$8DFFFF  ROM $6F00C-$6FFFF: the rest of BigFontTiles, StartHL2 (92G penalty.asm: play the highlight of another playoff game), asspenalty
; and clrplayer (logic93_2, asstab $C), avdgoal (logic93_5), zero fill.
org $8DF00C
	incbin "../data/BigFont.chr.pak":$144..$9C0		; $8DF00C-$8DF887
BigFontTilesEnd:
	assert BigFontTilesEnd-BigFontTiles == $9C0
StartHL2:		;auto: CODE_8DF888 (from $82FCB9 with d0-d7/a0-a6 saved). 92G StartHL2: play the highlight of playoff game a0: "Highlight from game:", then 1-3 minutes of that game with its score; Start
		;   or A ends it, a tie gets a random winner
	lda.w sflags3		; Start pressed before: no more highlights
	bit.w #sf3sbut
	beq .go
	jmp.w .nhl0
.go:
	jsl.l .sv		; save the game state
	lda.b d1
	sta.b d3
	jsl.l NewTicker3		; 93G NewTicker3: the score of the highlight game, bank $8F: 93G NewTicker3
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
	jsl.l Framer		; bank $8F: 93G Framer (d0 x d1)
	inc.w printx
	dec.w printy
	dec.w printy
	jsl.l printz
	dw $0016		; printz inline string: length (counts itself), then control bytes / text
	db "Highlight from game:"
	lda.w #180		; 180 frames, Start skips
	sta.b d0
	jsl.l waitxsr		; bank $8F: wait d0 frames or a button (92G waitxsr)
	lda.b d1
	bit.w #JOYSTART
	beq .play
	jmp.w .nhl1
.play:
	jsl.l forceblack		; bank $8F: 93G forceblack
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
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha
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
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha2:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha2
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
	jsl.l .team
	lda.w #$0002
	sta.b a2
	jsl.l .team
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
.zero:		;92G .0: wait for the next frame
	lda.b vcount		; the frame time steps as the game loop
	cmp.w oldvcount
	beq .zero
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
	beq .one
	pla
	sec
	sbc.b d7
	pha
	bmi .endhl
.one:		;92G .1
	jsl.l Readjoy12		; Start or A ends it
	lda.b d1
	bit.w #JOYSTART|JOYA
	beq .zero
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
.popa3:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa3
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha4:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha4
	ldx.b xsave
	jsl.l KillCrowd		; $8F87C0, bank $8F
	jsl.l sndqreset
	stx.b xsave
	ldx.w #$0002
.popa4:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa4
	ldx.b xsave
	stx.b xsave
	ldx.w #$0002
.popd:
	pla
	sta.b d1,x
	dex
	dex
	bpl .popd
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
	jsl.l forceblack		; bank $8F: 93G forceblack
	jsl.l .lo		; restore the game state
	jsl.l setplayercolors
	jsl.l SetHor		; bank $8F: 93G SetHor
	jsl.l setvideo
	jsl.l printz		; DisplayStats box
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0C
	lda.w #22
	sta.b d0
	lda.w #7
	sta.b d1
	jsl.l Framer		; bank $8F: 93G Framer (d0 x d1)
	jsl.l printscores1
	jsl.l Pmenu		; bank $8F: 93G DisplayStats
	stx.b xsave
	ldx.w #$001A
.popa5:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa5
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.popd5:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd5
	ldx.b xsave
	ldx.b a3
	stx.b xsave
	ldx.w #$0000
.pushd6:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .pushd6
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha6:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .pusha6
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
	jsl.l NewTicker3		; bank $8F: 93G NewTicker3
	lda.w #180
	sta.b d0
	jsl.l waitxsr		; bank $8F: wait d0 frames or a button (92G waitxsr)
	lda.b d1
	bit.w #JOYSTART
	beq .exit
.exit2:
	lda.w #sf3sbut		; sf3sbut
	tsb.w sflags3
.exit:
	stx.b xsave
	ldx.w #$001A
.popa7:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa7
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.popd7:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd7
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
.team:		;SNES: team a2 for the highlight: energy, setpersonel, forcepldata, no last touches
	jsl.l reenergizeteam
	jsl.l setpersonel
	jsl.l forcepldata
	ldy.b a2
	lda.w #$FFFF
	sta.w tmtouch1,y
	sta.w tmtouch2,y
	sta.w tmtouch3,y
	rtl
.ranres:		;92G .ranres: a tie gets a random one-goal winner; gsper 5 (final)
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
.sv:		;92G .sv: save the game state (gmode-1 .. ScoreSumbytes) to hlsavebuf
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
.lo:		;92G .lo: restore the game state from hlsavebuf
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
.postab:		;92G .postab: x, y start spot by position (0-5 attacking up, 6-11 down)
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
asspenalty:		;auto: CODE_8DFCC7 (asstab $C). 93G asspenalty (logic93_2): player X skates to the penalty box (temp3/temp4 by PBnum), glides in, faces the ice (SPAwallright), then adopen
	lda.w pfalock,x
	beq .go
	jmp.w .rtl
.go:
	lda.w pflags,x		; new assignment
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	ora.w #pf2unav
	sta.w pflags,x
	jsl.l clrplayer
	lda.w #-2		; setpads -2: number on the leaving player
	sta.b d4
	jsl.l setpads
	stz.w temp2,x
	lda.w #8
	sta.w temp2b,x
	lda.w #11		; temp4 = 11 * (n + 3), n = players in the box (0-2)
	sta.b d0
	lda.w PBnum
	sta.b d1
	lda.w pfteam,x
	bne .zero
	lda.b d1
	lsr a
	lsr a
	lsr a
	lsr a
	sta.b d1
	lda.w #-11
	sta.b d0
.zero:		;93G .0
	lda.b d1
	and.w #$000F
	sta.b d1
	cmp.w #3
	bcc .one
	lda.w #2
	sta.b d1
.one:		;93G .1
	inc.b d1
	inc.b d1
	inc.b d1
	lda.b d0
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls16
	sta.b d1
	sta.w temp4,x
	lda.w #$0088		; temp3 = $88: the sideline
	sta.w temp3,x
	stz.w temp1,x
	lda.w pflags,x		; pf2npc: no player collision
	ora.w #pf2npc
	sta.w pflags,x
	stz.w Wallcos,x
	stz.w Wallsin,x
.nna:
	lda.w Ypos,x
	sec
	sbc.w temp4,x
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #13
	bcc .in
	jmp.w .st
.in:
	lda.w Xpos,x
	sec
	sbc.w temp3,x
	sta.b d0
	sec
	sbc.w #-24
	bmi .lt
	bvc .near
.st0:
	jmp.w .st
.lt:
	bvc .st0
.near:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .step
	jmp.w .rtl
.step:
	adc.w #8
	sta.w temp1,x
	lda.w #SPAglide		; SPAglide, pfnc
	sta.b d1
	sta.w pfnc,x
	jsl.l SetSPA
	lda.w #6		; face 6 (2 for the other hand)
	sta.b d2
	lda.w handed,x
	beq .left
	lda.w #2
	sta.b d2
.left:
	lda.w facedir,x
	cmp.b d2
	beq .ok
	inc a
	and.w #$0007
	sta.w facedir,x
.ok:
	stz.w Yvel,x
	lda.w #$1000
	sta.w Xvel,x
	lda.b d0
	sec
	sbc.w #-8
	bmi .lt2
	bvc .stop
	bra .rtl
.lt2:
	bvc .rtl
.stop:
	stz.w Xvel,x
	lda.w facedir,x
	cmp.b d2
	bne .rtl
	lda.w #2
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #SPAwallright		; SPAwallright
	sta.b d1
	jsl.l SetSPA
	lda.w pflags,x
	and.w #~pf2pen&$FFFF		; pf2pen off
	sta.w pflags,x
	lda.w #$0D		; adopen
	sta.b d0
	jml.l assreplace
.rtl:
	rtl
.st:		;skate to the box
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #rtss		; a0 = rtss: no avoidance
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	jml.l skateto
clrplayer:		;auto: CODE_8DFE1B. 93G clrplayer: take the joystick off player X (changeplayer)
	lda.w pflags,x
	bit.w #pfjoycon
	beq asspenalty_rtl
	stz.b d4
	txa
	lsr a
	sta.b d0
	cmp.w c1playernum
	beq .ch
	inc.b d4
	inc.b d4
.ch:
	jml.l changeplayer
avdgoal:		;auto: CODE_8DFE36 (from skateto, $808C45). 93G avdgoal (logic93_5, SNES form): if the path d0/d1 crosses a goal line (y +-254) within 40 of the net, aim beside the net (x +-60) instead
	stz.b tmp2
	lda.w #-258		; goal line at y -258 ($FEFE) and 258 ($102)
	jsl.l .ch1
	lda.w #258
	jsl.l .ch1
	lda.b tmp2
	bne .rtl
	lda.w Xpos,x		; not crossing: is the player in front of a net?
	eor.b d0
	bpl .rtl
	lda.w Ypos,x
	sec
	sbc.w #258
	bit.w #$8000
	beq .b
	eor.w #$FFFF
	inc a
.b:
	cmp.w #32
	bcc .x
	lda.w Ypos,x
	sec
	sbc.w #-258
	bit.w #$8000
	beq .c
	eor.w #$FFFF
	inc a
.c:
	cmp.w #32
	bcs .rtl
.x:
	stz.b d1
	rtl
.ch1:		;goal line A: crossed within 40 of the net: d1 = line, d0 = +-60 by Xvel, tmp2 = 1
	sta.b tmp0
	lda.b d1
	sec
	sbc.b tmp0
	sta.b tmp1
	lda.w Ypos,x
	sec
	sbc.b tmp0
	eor.b tmp1
	bpl .rtl
	lda.w Xpos,x
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #40
	bcs .rtl
	inc.b tmp2
	lda.b tmp0
	sta.b d1
	lda.w #60
	sta.b d0
	lda.w Xvel,x
	bpl .rtl
	lda.w #-60
	sta.b d0
.rtl:
	rtl
unused008D:		;unused, zero fill to the end of the bank
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	db $00,$00,$00,$00,$00,$00,$00,$00
