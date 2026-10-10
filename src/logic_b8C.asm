; logic_b8C: 93G logic93_1..logic93_5: player logic and the assignments (asstab).
; Bank $8C. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8CFD83
chk4pass:		;player a3 looks for good pass (computer controlled) (93G logic93_3)
		;   SNES: computer player X looks for a good pass: a random team mate, onside, ahead of the blue line rule, no opponent in the lane; then dopass and
		;   assexit
	lda.w threat		; no threat: pass only now and then (spodds)
	bne .dp0
	lda.w #16
	clc
	adc.w spodds,x
	jsl.l randoma
	cmp.w #9
	bcc .dp0
	jmp.w .rtl
.dp0:
	lda.w #6
	jsl.l randoma
	sta.b d0
	cpx.w #12		; team mates of the away team are 6-11
	bcc .dp1
	lda.b d0
	clc
	adc.w #6
	sta.b d0
.dp1:
	lda.w position,x		; not the goalie: only outside the slot
	beq .bl
	lda.w puckx
	bit.w #$8000
	beq .ax
	eor.w #$FFFF
	inc a
.ax:
	cmp.w #41
	bcs .bl
	lda.w pucky
	bit.w #$8000
	beq .ay
	eor.w #$FFFF
	inc a
.ay:
	cmp.w #205
	bcc .bl
	jmp.w .rtl
.bl:
	asl.b d0		; not to himself
	cpx.b d0
	bne .b1
	jmp.w .rtl
.b1:
	ldy.b d0
	sty.b a0
	lda.w position,y		; not to the goalie or an illegal player
	bne .b2
	jmp.w .rtl
.b2:
	bpl .b3
	jmp.w .rtl
.b3:
	lda.w pflags,y		; not unavailable or locked
	and.w #$1000
	ora.w pfalock,y
	beq .b4
	jmp.w .rtl
.b4:
	lda.w Ypos,y
	sta.b d0
	lda.w Ypos,x
	sta.b d1
	lda.w pfgoal,x
	bne .f0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
	lda.b d1
	eor.w #$FFFF
	inc a
	sta.b d1
.f0:
	lda.w gmode		; offsides: no pass across the blue line
	bit.w #gmoffs
	beq .oko
	lda.b d0
	sec
	sbc.w #88
	sta.b tmp0
	lda.b d1
	sec
	sbc.w #88
	eor.b tmp0
	bpl .oko
	jmp.w .rtl
.oko:
	lda.b d0		; beyond the blue line, or not more than 15 back
	sec
	sbc.w #88
	beq .le
	bmi .lt
	bvs .le
	bra .ok
.lt:
	bvs .ok
.le:
	lda.b d0
	sec
	sbc.b d1
	sta.b d0
	sec
	sbc.w #-15
	bmi .lt2
	bvc .ok
.no:
	jmp.w .rtl
.lt2:
	bvc .no
.ok:
	lda.w Ypos,y		; passdir, d2 = distance squared
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	pha
	jsl.l vtoa
	sta.w passdir
	pla
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d2
	lda.b mulres+2
	sta.b d2+2
	pla
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d2
	sta.b d2
	lda.b mulres+2
	adc.b d2+2
	sta.b d2+2
	lda.w #5		; the 6 opponents
	sta.b d3
	stz.b a1
	cpx.w #12
	bcs .co0
	lda.w #12
	sta.b a1
.co0:
	ldy.b a1
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b tmp0
	lda.b mulres+2
	sta.b tmp1
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b tmp0
	sta.b tmp0
	lda.b mulres+2
	adc.b tmp1
	sta.b tmp1
	lda.b d2
	cmp.b tmp0
	lda.b d2+2
	sbc.b tmp1
	bcc .co1
	jsl.l vtoa		; nearer opponent in the lane: no pass
	cmp.w passdir
	beq .rtl
.co1:
	inc.b a1
	inc.b a1
	dec.b d3
	bpl .co0
	jsl.l dopass		; 93G dopass, bank $8F: 93G dopass
	lda.w position,x
	beq .rtl
	pla		; drop the return address (3 bytes): assexit returns for the caller
	sep #$20
	pla
	rep #$30
	jml.l assexit
.rtl:
	rtl
unusedFF8C:		;unused, $FF fill to the end of the bank
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
	db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
