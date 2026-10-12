setpads:		;Store which player a pad marker belongs to, so the graphics can show it
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
	lda.w #$0002		; d0 = (2 + d4) * 2 = nibble shift
	clc
	adc.b d4
	asl a
	sta.b d0
	sta.b tmp0
	lda.w #$FFF0
	sta.b d1
.m1:		;d1 = $FFF0 rotated left by d0
	lda.b tmp0
	beq .and
	dec.b tmp0
	asl.b d1
	bcc .m2
	inc.b d1
.m2:
	bra .m1
.and:
	lda.w PadControlBits
	and.b d1
	sta.w PadControlBits
	lda.w SCnum,x
	sta.b d1
.sh:		;d1 = SCnum << d0
	lda.b d0
	beq .or
	dec.b d0
	asl.b d1
	bra .sh
.or:
	lda.w PadControlBits
	ora.b d1
	sta.w PadControlBits
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
