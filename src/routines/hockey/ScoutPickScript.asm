ScoutPickScript:		;SNES: rating nibble d1 against the next (minimum, script) pair at [a1]: the highest qualifying rating picks tmPenmin
	lda.b [a1]
	and.w #$00FF
	sta.b tmp0
	inc.b a1
	lda.b [a1]
	and.w #$00FF
	sta.b tmp1
	inc.b a1
	lda.b d1
	sec
	sbc.b tmp0
	bmi .v1
	bvc .best
.ex1:
	jmp.w ScoutPlayerExit_rtl
.v1:
	bvc .ex1
.best:
	lda.b d1
	sec
	sbc.b d2
	bmi .v2
	bvc .z
.ex2:
	jmp.w ScoutPlayerExit_rtl
.v2:
	bvc .ex2
.z:
	lda.b d2
	beq .take
	lda.b tmp0
	bne .take
	jmp.w ScoutPlayerExit_rtl
.take:
	lda.b d1
	sta.b d2
	ldy.b a2
	lda.b tmp1
	sta.w tmPenmin,y
	rtl
