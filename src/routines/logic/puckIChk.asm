puckIChk:		;Watch for icing: the loose puck crossing the far goal line
	lda.w iflags
	bit.w #ifok		; ifok and not ifcgl, puck loose
	beq .rtl
	bit.w #ifcgl
	bne .rtl
	lda.w puckc
	bpl .rtl
	lda.w #blueline+goalline		; blueline+goalline
	sta.b d0
	lda.w iflags
	bit.w #ifdir
	bne .0
	lda.w #-(blueline+goalline)
	sec
	sbc.w pucky
	beq .rtl
	bmi .neg
	bvs .rtl
	bra .set
.neg:
	bvs .set
.rtl:
	rtl
.0:
	lda.w #blueline+goalline
	sec
	sbc.w pucky
	beq .set
	bmi .neg1
	bvs .set
	bra .rtl
.neg1:
	bvs .rtl
.set:
	lda.w #ifcgl		; ifcgl
	tsb.w iflags
	rtl
