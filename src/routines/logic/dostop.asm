dostop:		;Player X stops
	lda.w Xvel,x
	bit.w #$8000
	beq .xabs
	eor.w #$FFFF
	inc a
.xabs:
	cmp.w #$1001		; |Xvel| > $1000?
	bcs .set
	lda.w Yvel,x
	bit.w #$8000
	beq .yabs
	eor.w #$FFFF
	inc a
.yabs:
	cmp.w #$1001
	bcc StopNA
.set:		;moving fast: glide (skating backwards) or stop animation
	lda.w #SPAglide		; SPAglide $52C
	sta.b d1
	lda.w pfrev,x		; skating backwards: glide
	bne .setspa
	txa
	lsr a
	cmp.w puckc		; puck carrier: skate stop sound
	bne .stopanim
	lda.w seed+1
	and.w #$0001
	clc
	adc.w #SFXstop
	pha
	jsl.l sfx
.stopanim:
	lda.w #SPAstop		; SPAstop $6E6, pf2aip
	sta.b d1
	sta.w pf2aip,x
.setspa:
	jsl.l SetSPA
StopNA:		;slow player a3 by 150 on each axis, no animation change. Falls in from dostop, also entered from goalieacc and others
		;   SNES: slow player X by $70*d7 on each axis, no animation change
	lda.w #$0070		; $70 per frame
	sta.b mula
	lda.b d7
	sta.b mulb
	jsl.l mulu16		; mulu, mulres = mula*mulb
	lda.w Xvel,x
	bpl .xp
	clc
	adc.b mulres
	sta.w Xvel,x
	bmi .y
	lda.w #$0000
.xp:
	sec
	sbc.b mulres
	sta.w Xvel,x
	bpl .y
	stz.w Xvel,x
.y:
	lda.w Yvel,x
	bpl .yp
	clc
	adc.b mulres
	sta.w Yvel,x
	bmi .rts
	lda.w #$0000
.yp:
	sec
	sbc.b mulres
	sta.w Yvel,x
	bpl .rts
	stz.w Yvel,x
.rts:
	rtl
