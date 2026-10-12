goalieacc:		;goalie gets acc. in direction d0. Turns facedir one step toward d0 (92 set it directly)
		;   SNES: turns facedir one step toward d0, then playeracc
	lda.w #SPAgready		; SPAgready (2)
	sta.b d1
	lda.b d0
	and.w #$000F
	sta.b d0
	cmp.w #$0008		; 8 = no direction
	bcc .d1
	cmp.w #$0009		; 9 = stop
	bne .cgl
	lda.w Xvel,x
	ora.w Yvel,x
	beq .cgl
	jmp.w StopNA		; moving: slow down
.cgl:		;no direction: ready stance unless an animation is in progress
	lda.w pf2aip,x
	bne .rts
	jmp.w SetSPA
.rts:
	rtl
.d1:		;d0 = wanted direction: step facedir one eighth toward it
	sec
	sbc.w facedir,x
	sta.b d0
	beq .spa
	eor.w #$FFFF
	inc a
	and.w #$0004		; one step (+1/-1) toward d0
	lsr a
	dec a
	clc
	adc.w facedir,x
	and.w #$0007
	sta.b d0
	sta.w facedir,x
.spa:
	lda.w #SPAgskate		; SPAgskate $3F8
	sta.b d1
	jsl.l SetSPA
	lda.w facedir,x
	sta.b d2
	jml.l playeracc		; d2 = facedir, bank $8F (d2 = direction)
