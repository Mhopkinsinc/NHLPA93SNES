waitxsr:		;special version of waitx for zamboni crossing
		;   SNES: wait d0 frames or until a pad button (d1)
	lda.b d0
	pha
.wait:
	jsl.l Readjoy1
	lda.b d1
	bne .exit
	jsl.l Readjoy2
	lda.b d1
	bne .exit
	jsl.l setvideo
	lda.b vcount
.vb:
	cmp.b vcount
	beq .vb
	jsl.l ReadPads
	pla
	dec a
	pha
	bpl .wait
.exit:
	pla
	rtl
