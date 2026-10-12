puckbody:		;puck hits player a2. a3 = puck, d0 = distance^2 (from checkpuckcoll .ccx)
		;   SNES: puck (X) hits player a2. d0 = distance^2. A fast high puck knocks a2 down (FallDown), a slower one plays SPAcatch
	lda.w Zpos,x		; puck above 8: always a hit
	sec
	sbc.w #$0008
	beq .low
	bmi .v1
	bvs .low
	bra .hit
.v1:
	bvs .hit
.low:		;low puck: only a hit dead center counts
	lda.b d0
	and.w #$000F
	beq .hit
	jmp.w .rtl
.hit:
	jsl.l a2touchpuck
	lda.w seed		; puck body sound (one of 2)
	and.w #$0001
	clc
	adc.w #SFXpuckbody
	pha
	jsl.l sfx
	stz.w Zvel,x		; Zvel = 0, nopuck(a2) = 8
	ldy.b a2
	lda.w #$0008
	sta.w nopuck,y
	lda.w Xpos,x
	sec
	sbc.w Xpos,y
	sta.b d0
	lda.w Ypos,x
	sec
	sbc.w Ypos,y
	sta.b d1
	bne .0		; centered: use the hot spot
	tya
	jsl.l GetHot
.0:
	lda.w Xvel,x
	sta.b d2
	lda.w Yvel,x
	sta.b d3
	sep #$20		; puck velocity high bytes = offset
	lda.b d0
	sta.w Xvel+1,x
	lda.b d1
	sta.w Yvel+1,x
	rep #$30
	jsl.l puckflip		; puckflip
	lda.w Zpos,x
	sec
	sbc.w #$0008
	beq .rtl
	bmi .v2
	bvc .high
	bra .rtl
.v2:
	bvc .rtl
.high:		;old speed^2 > $3000^2 and puck above 12: FallDown
	lda.b d2
	sta.b mula
	sta.b mulb
	jsl.l muls32
	sta.b d2
	lda.b mulres+2
	sta.b d2+2
	lda.b d3
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d2
	sta.b d2
	lda.b mulres+2
	adc.b d2+2
	sta.b d2+2
	cmp.w #$0900		; $3000^2
	bcc .slow
	lda.w Zpos,x
	sec
	sbc.w #$000C		; Zpos 12
	beq .rtl
	bmi .v3
	bvs .rtl
.fall:
	jmp.w FallDown		; FallDown
.v3:
	bvs .fall
.rtl:
	rtl
.slow:
	ldy.b a2
	lda.w pfalock,y		; pfalock: already in a locked animation
	bne .rtl
	inc a
	sta.w pfalock,y
	lda.w #SPAcatch
	sta.b d1
	ldx.b a2		; exg a2,a3 around SetSPA
	ldy.b a3
	stx.b a3
	sty.b a2
	jsl.l SetSPA
	ldx.b a2
	ldy.b a3
	stx.b a3
	sty.b a2
	rtl
