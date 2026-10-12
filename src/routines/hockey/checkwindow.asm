checkwindow:		;set hpos and vpos according to how screen should follow puck
		;   SNES: set Hpos/Vpos so the screen follows the puck (or xc1/yc1 when sfslock)
	lda.w yc1
	sta.b d2
	lda.w xc1
	sta.b d3
	lda.w sflags		; sfslock: use xc1/yc1
	bit.w #sfslock
	bne .dd
	ldx.w #puckobj		; follow the puck, or its carrier with yleader
	lda.w puckc
	bmi .ok
	asl a
	tax
	lda.w pfgoal,x		; carrier goes up: yleader up to 50, else down to -50
	beq .gd
	lda.w yleader
	adc.b impactstep
	sta.w yleader
	sec
	sbc.w #$0032
	bmi .v1
	bvc .ylmax
	bra .ok
.v1:
	bvc .ok
.ylmax:
	lda.w #$0032
	sta.w yleader
	bra .ok
.gd:
	lda.w yleader
	sec
	sbc.b impactstep
	sta.w yleader
	sec
	sbc.w #$FFCE
	beq .ylmin
	bmi .vl
	bvs .ylmin
	bra .ok
.vl:
	bvs .ok
.ylmin:
	lda.w #$FFCE
	sta.w yleader
.ok:		;d2 = Ypos + Yvel/128 + yleader, d3 = Xpos
	lda.w Yvel,x
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0100
	beq .sy
	ora.w #$FE00
.sy:
	clc
	adc.w Ypos,x
	clc
	adc.w yleader
	sta.b d2
	sta.w yc1
	lda.w Xpos,x
	sta.b d3
	sta.w xc1
.dd:
	lda.b d2		; |target - Vpos| > 10: scroll
	sec
	sbc.w Vpos
	sta.b d0
	sec
	sbc.w #$FFF6
	bmi .v3
	bvs .up
	bra .1
.v3:
	bvs .1
.up:
	lda.b d2
	sec
	sbc.w #$FFF6
	sta.b d1
	sec
	sbc.w #$FF39
	beq .yslimd
	bmi .v4
	bvs .yslimd
	bra .2
.v4:
	bvs .2
.yslimd:
	lda.w #$FF39
	sta.b d1
	bra .2
.1:
	lda.b d0
	sec
	sbc.w #$000A
	beq .2x
	bmi .v5
	bvc .down
	bra .2x
.v5:
	bvc .2x
.down:
	lda.b d2
	sec
	sbc.w #$000A
	sta.b d1
	sec
	sbc.w #$0100
	bmi .v6
	bvc .yslimu
	bra .2
.v6:
	bvc .2
.yslimu:
	lda.w #$0100
	sta.b d1
.2:		;Vpos += (target - Vpos) / 8 (at least 1)
	lda.b d1
	sec
	sbc.w Vpos
	beq .2x
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .s2
	ora.w #$E000
.s2:
	cmp.w #$0000
	bne .v2
	inc a
.v2:
	clc
	adc.w Vpos
	sta.w Vpos
.2x:
	lda.b d3		; |target - Hpos| > 40: scroll
	sec
	sbc.w Hpos
	sta.b d0
	sec
	sbc.w #$FFD8
	bmi .v7
	bvs .left
	bra .3
.v7:
	bvs .3
.left:
	lda.b d3
	sec
	sbc.w #$FFD8
	sta.b d1
	sec
	sbc.w #$FFC4
	bmi .v8
	bvs .xslimn
	bra .4
.v8:
	bvs .4
.xslimn:
	lda.w #$FFC4
	sta.b d1
	bra .4
.3:
	lda.b d0
	sec
	sbc.w #$0028
	beq .rtl
	bmi .v9
	bvc .right
	bra .rtl
.v9:
	bvc .rtl
.right:
	lda.b d3
	sec
	sbc.w #$0028
	sta.b d1
	sec
	sbc.w #$003C
	beq .4
	bmi .v10
	bvc .xslim
	bra .4
.v10:
	bvc .4
.xslim:
	lda.w #$003C
	sta.b d1
.4:		;Hpos += (target - Hpos) / 8 (at least 1)
	lda.b d1
	sec
	sbc.w Hpos
	beq .rtl
	lsr a
	lsr a
	lsr a
	bit.w #$1000
	beq .s4
	ora.w #$E000
.s4:
	cmp.w #$0000
	bne .h2
	inc a
.h2:
	clc
	adc.w Hpos
	sta.w Hpos
.rtl:
	rtl
