chk4shot:		;Computer player X looks for a shot
	jsl.l chkpk
	bne .npk
	lda.w threat		; threat on the puck carrier
	beq .npk
	lda.w Ypos,x
	bit.w #$8000
	beq .yabs
	eor.w #$FFFF
	inc a
.yabs:
	cmp.w #$00ED		; in front of the net
	bcs .npk
	lda.w seed		; one time in four: clear the puck
	and.w #$0003
	bne .npk
	jmp.w CompShoot
.npk:		;d4 = shot odds ($20-spodds)*16
	lda.w #$0020
	sec
	sbc.w spodds,x
	asl a
	asl a
	asl a
	asl a
	sta.b d4
	lda.w #blueline+goalline		; blueline+goalline
	sta.b d1
	lda.w pfgoal,x
	bne .c0
	lda.w #-(blueline+goalline)
	sta.b d1
.c0:
	lda.b d1
	sec
	sbc.w pucky
	sta.b d1
	pha
	lda.w puckx
	eor.w #$FFFF
	inc a
	sta.b mula
	sta.b mulb
	pha
	jsl.l muls32
	sta.b d0
	lda.b mulres+2
	sta.b d0+2
	lda.b d1
	sta.b mula
	sta.b mulb
	jsl.l muls32
	adc.b d0
	sta.b tmp0
	lda.b mulres+2
	adc.b d0+2
	sta.b tmp1
	pla
	sta.b d0
	pla
	sta.b d1
	lda.b tmp0
	cmp.w #$2711		; distance^2 > 100*100?
	lda.b tmp1
	sbc.w #$0000
	bcs .no1
	lsr.b d4
	lsr.b d4
	lsr.b d4
	lsr.b d4
	jsl.l vtoa
	sta.b d5
	lda.w #$0005
	sta.b d3
	stz.b a1
	cpx.w #$000C
	bcs .co0
	lda.w #$000C
	sta.b a1
.co0:		;each opponent: a defender in the shot line doubles d4; a busy goalie means shoot now
	ldy.b a1
	lda.w position,y
	beq .gl
	lda.w Xpos,y
	sec
	sbc.w puckx
	sta.b d0
	lda.w Ypos,y
	sec
	sbc.w pucky
	sta.b d1
	jsl.l vtoa
	cmp.b d5
	bne .co1
	asl.b d4
	bra .co1
.gl:
	lda.w pf2aip,y
	beq .co1
	stz.b d3
	lda.w #$0001
	sta.b d4
.co1:
	inc.b a1
	inc.b a1
	dec.b d3
	bpl .co0
.no1:
	lda.b d4
	jsl.l randoma
	cmp.w #$0009		; no shot if random(d4) > 8
	bcs .rts
	lda.w pucky
	sta.b d0
	lda.w pfgoal,x
	bne .ds0
	lda.b d0
	eor.w #$FFFF
	inc a
	sta.b d0
.ds0:
	lda.b d0
	bmi .rts
	lda.w #blueline+goalline
	sec
	sbc.b d0
	bmi .rts
	lda.w sflags		; sf2offsig: player is offside
	bit.w #sf2offsig
	bne .rts
	bra CompShoot
.rts:
	rtl
