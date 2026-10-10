; $8E8000-$8E900A  ROM $70000-$7100A: Gameloop (hockey93_01, with the DoGameFrame time steps), PlayerShortName, assbench (logic93_2, asstab $B);
; then SpriteSet3 (frame set 3: celebrations), tiles continue to bank8E_D000.
org $8E8000
Gameloop:		;auto: CODE_8E8000 (from StartPer). 93G Gameloop (hockey93_01): wait for a new frame, time steps from d7, clock, music cue timers, crowd cheers, DoGameFrame, demoread, goalie
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
PlayerShortName:		;auto: CODE_8E8182. SNES: mesarea = "<number> <first initial>. <last name>" of roster player d0 (team a2)
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
assbench:		;auto: CODE_8E826B (asstab $B). 93G assbench (logic93_2): player X skates to the bench door and leaves; the new player (newpnum) comes on (setplayer)
	lda.w pfalock,x
	beq .go
	jmp.w .rtl
.go:
	lda.w temp1,x
	cmp.w #100		; temp1 100: at the bench door
	bne .chk
	jmp.w .done
.chk:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #pf2pen		; pf2pen: assexit
	beq .pen
	jml.l assexit
.pen:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp2,x
	lda.w #8
	sta.w temp2b,x
	lda.w #80		; temp4 = bench y +-80, temp3 = bench x -144
	sta.b d0
	lda.w pfteam,x
	bne .zero
	lda.w #-80
	sta.b d0
.zero:		;93G .0
	lda.b d0
	sta.w temp4,x
	lda.w #-144
	sta.w temp3,x
	stz.w temp1,x
.nna:
	lda.w newpnum,x		; same player: just change position
	cmp.w pnum,x
	bne .dec
	jmp.w .nobench
.dec:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .near
	jmp.w .nodec
.near:
	lda.w temp1,x
	adc.w #8
	sta.w temp1,x
	lda.w Ypos,x
	sec
	sbc.w temp4,x
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #41
	bcc .ax
	jmp.w .nodec
.ax:
	lda.w Xpos,x
	sec
	sbc.w temp3,x
	sta.b d0
	sec
	sbc.w #32
	beq .gli0
	bmi .lt
	bvs .gli0
.nd:
	jmp.w .nodec
.lt:
	bvs .nd
.gli0:
	lda.w #SPAglide		; SPAglide (goalie SPAgready)
	sta.b d1
	lda.w position,x
	bne .gli
	lda.w #SPAgready
	sta.b d1
.gli:
	jsl.l SetSPA
	lda.w #1
	sta.w pfnc,x
	lda.w facedir,x
	cmp.w #4
	beq .ok
	inc a
	and.w #$0007
	sta.w facedir,x
.ok:
	stz.w Yvel,x
	lda.w #$F800
	sta.w Xvel,x
	lda.b d0
	sec
	sbc.w #16
	beq .stop
	bmi .lt2
	bvs .stop
	bra .rtl
.lt2:
	bvs .rtl
.stop:
	stz.w Xvel,x
	lda.w facedir,x
	cmp.w #4
	bne .rtl
	lda.w #$F800
	sta.w Xvel,x
	lda.w #2
	sta.w facedir,x
	lda.w #SPAwallleft		; SPAwallleft
	sta.b d1
	jsl.l SetSPA
	lda.w #100
	sta.w temp1,x
	sta.w pfalock,x
.rtl:
	rtl
.done:
	stz.w frame,x
	lda.w pnum,x
	asl a
	sta.b d0
	stz.b a0
	lda.w pfteam,x
	beq .t0
	lda.w #2
	sta.b a0
.t0:
	lda.b a0
	beq .t1
	lda.w #$34
.t1:
	clc
	adc.b d0
	tay
	lda.w #TMPDBENCH		; TMPDBENCH: on the bench
	sta.w tmpdst,y
	lda.w newpnum,x
	sta.b d3
	jsl.l .nobench2
	jml.l setplayer
.nodec:
	lda.w pfnc,x
	bne .rtl
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #EvadePC
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	jml.l skateto
.nobench:
	lda.w pflags,x
	and.w #~pf2unav&$FFFF
	sta.w pflags,x
.nobench2:		;position = newpos (Setplass), newpnum/newpos -1
	lda.w newpos,x
	sta.b d0
	sta.w position,x
	jsl.l Setplass
	lda.w #$FFFF
	sta.w newpnum,x
	sta.w newpos,x
	rtl
SpriteSet3:		;frame set 3 (SPFcelebrate, SPFpump, SPFcup): frames 185-224
	dw 40		; frames
	dw 344		; pieces
	dw 640		; tiles
	dw .pieces-SpriteSet3
	dw .tiles-SpriteSet3
.frames:		;first piece of each frame (+1 entry for the end)
	dw 0,6,16,26,34,48,59,68
	dw 75,82,89,97,105,120,132,140
	dw 147,157,161,167,177,187,195,201
	dw 210,217,222,232,241,247,258,263
	dw 267,276,292,304,311,319,327,333
	dw 344
.pieces:		;x, y, tile, attributes per piece
	incbin "../data/Sprites/set03.pieces"		; $8E8447-$8E89A6
	assert .tiles-.pieces == 4*344
.tiles:		;640 4bpp tiles (32 bytes each)
	incbin "../data/Sprites/set03.chr":0..$664		; $8E89A7-$8E900A
