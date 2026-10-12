puckIChk:		;check for icing of puck penalty. Called from pucknorm
		;   SNES: sets ifcgl once the loose puck crosses the far goal line
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
	bmi .v1
	bvs .rtl
	bra .set
.v1:
	bvs .set
.rtl:
	rtl
.0:
	lda.w #blueline+goalline
	sec
	sbc.w pucky
	beq .set
	bmi .v2
	bvs .set
	bra .rtl
.v2:
	bvs .rtl
.set:
	lda.w #ifcgl		; ifcgl
	tsb.w iflags
	rtl
