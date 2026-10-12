CompShoot:		;player a3 shoots (computer controlled player)
		;   SNES: computer player X shoots. Pops the caller (addq #4,sp), temp2b = swing time, assignment ashoot
	pla		; pop the caller
	sep #$20
	pla
	rep #$30
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .ds0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.ds0:
	lda.w #blueline+goalline		; swing time = (blueline+goalline - y)/8, max 20
	sec
	sbc.b d0
	lsr a
	lsr a
	lsr a
	sta.b d1
	cmp.w #$0014
	bcc .lt
	lda.w #$0014
	sta.b d1
.lt:
	stz.w temp2,x
	lda.b d1
	sta.w temp2b,x
	lda.w #ashoot		; ashoot
	sta.b d0
	jmp.w assreplace
