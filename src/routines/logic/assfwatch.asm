assfwatch:		;asstab $15. for player who is watching fight
		;   SNES: for a player watching a fight: skate to a spot 80 pixels from the fight
	lda.w pfalock,x
	beq .joy
	jmp.w .rts
.joy:
	lda.w pflags,x
	bit.w #pfjoycon		; joystick controlled
	beq .na
	jmp.w .rts
.na:
	bit.w #pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	stz.w temp1,x
.nna:
	lda.w temp1,x
	sec
	sbc.b d7
	sta.w temp1,x
	bmi .spot
	jmp.w .go
.spot:		;new spot every second
	adc.w #$003C		; +60
	sta.w temp1,x
	lda.w Ypos,x
	sec
	sbc.w yc1
	pha
	lda.w Xpos,x
	sec
	sbc.w xc1
	pha
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b $03,s
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b d0
	lda.b mulres+2
	adc.b d0+2
	sta.b d0+2
	jsl.l sroot		; distance to the fight
	lda.b d0
	bne .d
	lda.w #$0001
.d:
	sta.b d2
	pla
	sta.b d0
	sta.b mulb
	pla
	sta.b d1
	lda.w #$0050		; 80 pixels from the fight
	sta.b mula
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	adc.w xc1
	sta.b d0
	lda.w #$007E		; x within +-$7E
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	bmi .neg
	bvc .cl1
	bra .x0
.neg:
	bvc .x0
.cl1:
	lda.b d3
	sta.b d0
.x0:
	lda.b d3
	eor.w #$FFFF
	inc a
	sta.b d3
	lda.b d0
	sec
	sbc.b d3
	beq .cl2
	bmi .neg1
	bvs .cl2
	bra .x1
.neg1:
	bvs .x1
.cl2:
	lda.b d3
	sta.b d0
.x1:
	lda.b d0
	sta.w temp3,x
	lda.w #$0050
	sta.b mula
	lda.b d1
	sta.b mulb
	jsl.l muls32
	lda.b d2
	sta.b mula
	jsl.l divs
	adc.w yc1
	sta.w temp4,x
.go:
	lda.w temp3,x
	sta.b d0
	lda.w temp4,x
	sta.b d1
	lda.w #rtss		; a0 = rtss
	sta.b a0
	lda.w #rtss>>16
	sta.b a0+2
	lda.w Xvel,x		; halve the velocity while watching
	pha
	asl a
	pla
	ror a
	sta.w Xvel,x
	lda.w Yvel,x
	pha
	asl a
	pla
	ror a
	sta.w Yvel,x
	jsl.l skateto		; d0/d1 = spot, [a0] = arrival routine
	jmp.w check4check
.rts:
	rtl
