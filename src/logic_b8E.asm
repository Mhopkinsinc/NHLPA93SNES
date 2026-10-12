; Player logic and the assignments (asstab).
; Bank $8E. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8E826B
assbench:		;asstab $B. player a3 should goto bench
		;   SNES: player X skates to the bench door and leaves; the new player (newpnum) comes on (setplayer)
	lda.w pfalock,x
	beq .na
	jmp.w .rtl
.na:
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
	bne .0
	lda.w #-80
	sta.b d0
.0:
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
	beq .away
	lda.w #2
	sta.b a0
.away:
	lda.b a0
	beq .t0
	lda.w #$34
.t0:
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

org $8EFE73
assdefo:		;asstab 1. player a3 is defensive player on offense
		;   SNES: defenceman on offence: hold the blue line on his side; adefd when offside, the puck goes back past the line or the other team has it
	lda.w pfalock,x
	beq .clk
	jmp.w .rtl
.clk:
	lda.w gmclock
	beq .bench
	jml.l assnothing		; bank $8F
.bench:
	jsl.l check4bench
	lda.w pflags,x
	bit.w #$0008
	beq .na
	jmp.w .rtl
.na:
	bit.w #$0002
	beq .nna
	and.w #$FFFD
	sta.w pflags,x
	stz.w temp1,x
	stz.w temp2,x
	lda.w #$0008
	sta.w temp2b,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bpl .nodec
	clc
	adc.w aioff,x
	bpl .store
	lda.w #$0000
.store:
	sta.w temp1,x
	lda.w #2		; adefd
	sta.b d0
	ldy.b a2
	lda.w tmflags,y		; offsides: defend
	bit.w #tmfoffside
	beq .on
	jml.l assreplace
.on:
	lda.w pucky
	sta.b d1
	lda.w pfgoal,x
	bne .de1
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.de1:
	lda.b d1		; the puck back behind the blue line
	sec
	sbc.w #$5D
	bmi .lt
	bvc .pc
.def:
	jml.l assreplace
.lt:
	bvc .def
.pc:
	lda.w puckc		; the other team has the puck
	bmi .nodec
	sec
	sbc.w #6
	sta.b d1
	txa
	sec
	sbc.w #12
	eor.b d1
	bpl .nodec
	jml.l assreplace
.nodec:
	lda.w #EvadePC		; EvadePC avoidance; spot x +-80 by side, y 98 (blue line + 5)
	sta.b a0
	lda.w #EvadePC>>16
	sta.b a0+2
	lda.w #80
	sta.b d0
	lda.w position,x
	cmp.w #2
	beq .1
	lda.w #-80
	sta.b d0
.1:
	lda.w #98
	sta.b d1
	lda.w pfgoal,x
	bne .0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.w #-98
	sta.b d1
.0:
	lda.w puckx
	eor.b d0
	bmi .2
	lda.w puckx
	bra .set
.rtl:
	rtl
.2:		;halfway to the puck
	lda.w puckx
	pha
	asl a
	pla
	ror a
	clc
	adc.b d0
.set:
	sta.b d0
	jml.l skateto
unused008E:		;unused, zero fill to the end of the bank
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
	db $00,$00
