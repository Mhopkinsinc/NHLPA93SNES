limitfo:		;limit face off to 5-20 feet from walls of rink. Checks every player in PenBuf
		;   SNES: keep the face off spot 65 from the blue line for every player in PenBuf
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .savea
	ldx.b xsave
	lda.w #PenBuf
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.loop:
	jsl.l .lf
	inc.b a0
	inc.b a0
	lda.b [a0]
	bne .loop
	stx.b xsave
	ldx.w #$0006
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$0006
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
.lf:		;a0 = PenBuf entry
	lda.b [a0]		; player SCnum*2; blue line +-$58 by pfgoal
	xba
	and.w #$007F
	asl a
	tay
	lda.w #$0058
	sta.b d1
	lda.w pfgoal,y
	bne .0
	lda.w #$FFA8
	sta.b d1
	sec
	sbc.w foy
	bmi .v1
	bvc .ny
	bra .rtl
.v1:
	bvc .rtl
.ny:
	lda.w #$FFBF
	sta.w foy
	bra .sx
.0:
	lda.b d1
	sec
	sbc.w foy
	beq .py
	bmi .v2
	bvs .py
	bra .rtl
.v2:
	bvs .rtl
.py:
	lda.w #$0041
	sta.w foy
.sx:
	lda.w #$0046
	sta.b d0
	lda.w fox
	bpl .1
	lda.w #$FFBA
	sta.b d0
.1:
	lda.b d0
	sta.w fox
.rtl:
	rtl
