assshoot:		;Assignment: computer shooting
	lda.w pflags,x
	bit.w #pfna		; pfna
	beq .nna
	and.w #~pfna&$FFFF
	sta.w pflags,x
	bra SetShotMode
.nna:
	lda.w sflags
	bit.w #sfssdir		; sfssdir
	bne .swing
	jmp.w assexit
.swing:		;count down the swing time; then press the shot button (d2 = cbut)
	lda.w temp1,x
	sta.b d0
	stz.b d2
	lda.w temp2b,x
	sec
	sbc.b d7
	sta.w temp2b,x
	bpl ShotMode
	lda.w #cbut
	tsb.b d2
	bra ShotMode
