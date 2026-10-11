; The game, screens, menus, password, playoffs.
; Bank $8E. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8E8000
Gameloop:		;main loop for game
		;   SNES: wait for a new frame, time steps from d7, clock, music cue timers, crowd cheers, DoGameFrame, demoread, goalie
		;   puck-handling penalty, line change end, Pausemode
	lda.b vcount		; wait for the next frame
	cmp.w oldvcount
	beq Gameloop
	tax		; d7 = frames elapsed; the time steps
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
	lda.w sflags		; clock stops in pause and when stopped
	bit.w #sfpz
	bne .cue
	lda.w gmclock
	bne .cue
	ldx.b d7
.clk:
	lda.w gameclock
	beq .clk1
	lda.w gameclock+2
	sec
	sbc.w #$0AAA		; clock fraction: one second per $10000
	sta.w gameclock+2
	bcs .clk1
	dec.w gameclock
.clk1:
	dex
	bne .clk
.cue:
	lda.w cuetimer		; music cue: sounds back near its end
	beq .p3
	ldx.b d7
.cue1:
	dec.w cuetimer
	lda.w cuetimer
	beq .p3
	cmp.w #2
	bne .cue2
	jsl.l sndqreset
	bra .p3
.cue2:
	dex
	bne .cue1
.p3:
	lda.w p3cue		; third period cue
	beq .cheer
	sec
	sbc.b d7
	bpl .p3a
	lda.w #$0000
.p3a:
	sta.w p3cue
	bne .cheer
	lda.w cuetimer		; another cue plays: try next frame
	beq .p3go
	inc.w p3cue
	bra .cheer
.p3go:
	jsl.l StartSong3
.cheer:
	lda.w cheercnt		; crowd cheers after a goal: every 150 frames
	beq .frame
	lda.b vcount
	sec
	sbc.w cheervc
	cmp.w #150
	bcc .frame
	lda.w #SFXcrowdcheer		; SFXcrowdcheer
	pha
	jsl.l sfx
	dec.w cheercnt
	lda.w cheervc
	clc
	adc.w #150
	sta.w cheervc
.frame:
	jsl.l DoGameFrame
	jsl.l demoread
	bra .gh
.cheat:		;not reached (the bra above skips it): new pad presses L, A, X in a row set the score of controller 1's team to 9
	lda.w padnew1
	beq .gh
	ldx.w cheatpads+2
	stx.w cheatpads
	ldx.w cheatpads+4
	stx.w cheatpads+2
	sta.w cheatpads+4
	lda.w cheatpads
	cmp.w #$20
	bne .gh
	lda.w cheatpads+2
	cmp.w #$80
	bne .gh
	lda.w cheatpads+4
	cmp.w #$40
	bne .gh
	lda.w cont1team
	beq .gh
	dec a
	asl a
	tax
	lda.w #9
	sta.w tmscore,x
	jsl.l printscores1
.gh:		;goalie carrying the puck far from his net: penalty 6
	lda.w position		; goalies on the ice
	ora.w position+2
	beq .lc
	lda.w puckc
	bmi .lc
	asl a
	tax
	lda.w position,x
	bne .lc
	lda.w pucky
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #165		; beyond y 165
	bcs .lc
	stx.b a3
	lda.w #6		; penalty 6
	sta.b d0
	jsl.l AddPenalty2
	lda.w #300		; nopuck 300
	sta.w nopuck,x
	lda.w #$FFFF
	sta.w puckc
.lc:
	lda.w lcplayer		; a line change player waiting
	bmi .pause
	cmp.w puckc
	beq .pause
	asl a
	tax
	stx.b a3
	lda.w pflags,x		; pf2lcm off
	and.w #~pf2lcm&$FFFF
	sta.w pflags,x
	stz.b a2
	jsl.l lcfound2
	lda.w #$0002
	sta.b a2
	jsl.l lcfound2
	lda.w #tmflc		; tmflc off for both teams
	trb.w tmflags
	trb.w tmflags+2
	lda.w #$FFFF
	sta.w lcplayer
.pause:
	lda.w sflags
	bit.w #sfpz
	beq .loop
	jsl.l Pausemode
.loop:
	jmp.w Gameloop
PlayerShortName:		;SNES: mesarea = "<number> <first initial>. <last name>" of roster player d0 (team a2)
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha2:
	lda.b a2,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha2
	ldx.b xsave
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
	jsl.l GetPlayerRecord
	stx.b xsave
	ldx.w #$0000
.pusha3:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .pusha3
	ldx.b xsave
	lda.w #$0000
	sta.b a1+2
	lda.w #mesarea+2		; a1 = mesarea+2
	sta.b a1
	lda.b a0
	clc
	adc.b [a0]
	sta.b a0
	lda.b [a0]
	and.w #$00FF
	sta.b d0
	jsl.l PutDigits2		; number
	lda.w #' '
	sta.b [a1]
	inc.b a1
	stx.b xsave
	ldx.w #$0002
.popa3:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa3
	ldx.b xsave
	lda.b [a0]		; name length
	sta.b d0
	clc
	adc.b a0
	sta.b a2
	lda.b a0+2
	sta.b a2+2
	inc.b a0
	inc.b a0
	lda.b [a0]		; first initial
	inc.b a0
	sta.b [a1]
	inc.b a1
	lda.w #'.'
	sta.b [a1]
	inc.b a1
	lda.w #' '
	sta.b [a1]
	inc.b a1
.skip:
	lda.b [a0]		; skip to the last name
	inc.b a0
	and.w #$00FF
	cmp.w #' '
	bne .skip
.last:
	lda.b [a0]
	inc.b a0
	sta.b [a1]
	inc.b a1
	lda.b a0
	cmp.b a2
	bne .last
	jsl.l MesAreaDone
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
	ldx.w #$0002
.popa2:
	pla
	sta.b a2,x
	dex
	dex
	bpl .popa2
	ldx.b xsave
	stx.b xsave
	ldx.w #$000E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
