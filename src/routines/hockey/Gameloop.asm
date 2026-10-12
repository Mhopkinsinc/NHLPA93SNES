Gameloop:		;Main game loop: wait for a frame, run the clock, music and crowd, one frame of game logic, the demo,
		;   line changes and pause
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
