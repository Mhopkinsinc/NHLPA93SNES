assfight:		;Assignment: fighting
	lda.w pfalock,x
	beq .go
	jmp.w .rts
.go:
	lda.w Pencntdwn		; fight over
	bpl .chkna
	jml.l assnothing
.chkna:
	lda.w pflags,x
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	jsl.l getpde
	lda.w fightagg,x		; getpde * fightagg / $1000
	sta.b d1
	sta.b mula
	lda.b d0
	sta.b mulb
	jsl.l mulu16		; mulu, mulres = mula*mulb
	xba
	and.w #$00FF
	lsr a
	lsr a
	lsr a
	lsr a
	cmp.w #$0006
	bcs .s
	lda.w #$0005
.s:		;temp3 = strength (min 5)
	sta.w temp3,x
	stz.w temp2,x
	stz.w temp2b,x
	lda.w #$FFFF		; temp4 = banner timer
	sta.w temp4,x
	lda.w facedir,x
	cmp.w #$0002		; one player shows the banner
	bne .nna
	lda.w #$005A
	sta.w temp4,x
.nna:		;keep the fighter within x -$6F..$6F
	lda.w Xpos,x
	sec
	sbc.w #$006F
	beq .left
	bmi .neg
	bvc .clampr
	bra .left
.neg:
	bvc .left
.clampr:
	stz.w Xvel,x
	lda.w #$006F
	sta.w Xpos,x
.left:
	lda.w Xpos,x
	sec
	sbc.w #$FF91
	bmi .neg1
	bvs .clampl
	bra .nna2
.neg1:
	bvs .nna2
.clampl:
	stz.w Xvel,x
	lda.w #$FF91
	sta.w Xpos,x
.nna2:		;temp4 = banner timer (no banner on the SNES)
	lda.w temp4,x
	sec
	sbc.b d7
	sta.w temp4,x
	lda.w temp3,x
	bpl .fight
	jmp.w .rts
.fight:
	lda.w impactp,x		; a0 = opponent; xc1 = half way between the fighters
	asl a
	sta.b a0
	tay
	lda.w Xpos,x
	adc.w Xpos,y
	pha
	asl a
	pla
	ror a
	sta.w xc1
	lda.w pflags,x
	bit.w #pfjoycon		; joystick: no computer punch
	bne .j
	lda.w pf2aip,x		; set pf2aip, test the old value
	pha
	lda.w #$0001
	sta.w pf2aip,x
	pla
	bne .j
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Xvel,x
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vx1
	ora.w #$FF00
.vx1:
	clc
	adc.b d0
	sta.b d0
	lda.w Xvel,y
	xba
	and.w #$00FF
	bit.w #$0080
	beq .vx2
	ora.w #$FF00
.vx2:
	sta.b d1
	lda.b d0
	sec
	sbc.b d1
	sta.b d0
	bit.w #$8000
	beq .inrange
	eor.w #$FFFF
	inc a
.inrange:
	cmp.w #$0019		; computer punches only within 25 pixels
	bcs .j
	lda.w #$0008
	sta.b d0
	jsl.l randomd0
	lda.b d0
	cmp.w #$0003
	bcc .p
	and.w #$0001
	sta.b d0
.p:		;choose the punch type from .al
	asl.b d0
	lda.w #.al
	sta.b a1
	lda.w #.al>>16
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	sta.b d1
	jsl.l SetSPA
.j:
	jsl.l chkhit
	lda.w SPA,x
	cmp.w #SPAfheld		; held: still pushed
	beq .njc
	cmp.w #SPAfight		; ready: no push
	beq .jc
	lda.w pflags,x
	bit.w #pfjoycon
	bne .jc
.njc:		;push toward the fight spot (xc1+-10)
	lda.w xc1
	clc
	adc.w #$000A
	sta.b d0
	lda.w facedir,x
	cmp.w #$0002
	bne .0
	lda.b d0
	sec
	sbc.w #$0014
	sta.b d0
.0:
	lda.b d0
	sec
	sbc.w Xpos,x
	sta.b mula
	lda.w #$0023		; 35 toward the spot, 5 away from it
	sta.b mulb
	lda.w facedir,x
	sec
	sbc.w #$0004
	eor.b mula
	bmi .mul
	lda.w #$0005
	sta.b mulb
.mul:
	jsl.l muls16
	sta.b d0
	clc
	adc.w Xvel,x
	sta.w Xvel,x
.jc:		;Yvel = (yc1-Ypos)*256, +-$1000
	lda.w yc1
	sec
	sbc.w Ypos,x
	xba
	and.w #$FF00
	sta.b d1
	sec
	sbc.w #$1000
	bmi .neg2
	bvc .y1
	bra .y2
.neg2:
	bvc .y2
.y1:
	lda.w #$1000
	sta.b d1
.y2:
	lda.b d1
	sec
	sbc.w #$F000
	beq .y3
	bmi .neg3
	bvs .y3
	bra .sety
.neg3:
	bvs .sety
.y3:
	lda.w #$F000
	sta.b d1
.sety:
	lda.b d1
	sta.w Yvel,x
.rts:
	rtl
.al:		;punch animations SPAfhigh, SPAflow, SPAfgrab
	dw SPAfhigh,SPAflow,SPAfgrab
