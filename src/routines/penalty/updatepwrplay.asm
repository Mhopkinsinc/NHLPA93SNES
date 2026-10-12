updatepwrplay:		;Show the power play box: the time left and the team on the power play
	stz.b a2		; a2 = home, a3 = away
	lda.w #$0002
	sta.b a3
	lda.w tmap
	sec
	sbc.w tmap+2
	sta.b d0
	bne .ne
	jmp.w updatepwrplay_clr
.ne:
	bpl .t0
	lda.w sflags
	bit.w #sf2pwrtm
	bne .upp
	jsl.l updatepwrplay_clr
	lda.w #sf2pwrtm
	tsb.w sflags
	bra .upp
.t0:
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	lda.w sflags
	bit.w #sf2pwrtm
	beq .upp
	jsl.l updatepwrplay_clr
	lda.w #sf2pwrtm
	trb.w sflags
.upp:
	lda.w #sf2pwrplay		; sf2pwrplay; new: tmPwrPlays + 1
	tsb.w sflags
	bne .uppt
	ldx.b a3
	inc.w tmPwrPlays,x
.uppt:
	jsl.l printz
	dw $0012		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19,"   ",$16,$17,$18,$19,$BF,$01,$1A,"   "
	jsl.l GetLowestPen
	jsl.l PushTime
	jsl.l print
	ldx.b a3
	lda.w tmdata,x		; team name (bank $83)
	sta.b a0
	lda.w #TeamList>>16
	sta.b a0+2
	lda.w #mesarea		; a3 = mesarea, length 2
	sta.b a3
	lda.w #mesarea>>16
	sta.b a3+2
	lda.w #$0002
	sta.b [a3]
	jsl.l appendz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$01,$19
	lda.b a0
	ldy.w #$0004
	clc
	adc.b [a0],y
	sta.b a0
	adc.b [a0]
	sta.b a0
	sta.b a1
	lda.b a0+2
	sta.b a1+2
	jsl.l appstring
	lda.b a3
	sta.b a1
	lda.b a3+2
	sta.b a1+2
	jmp.w print
