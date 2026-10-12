ClearSprites:		;Move every sprite off screen and start a new sprite frame
	clc
	ldx.w #$0000
	ldy.w #$0008
.loop:
	lda.w #$E0E0
	sta.w Satt,x
	stz.w Satt+2,x
	sta.w Satt+$4,x
	stz.w Satt+$6,x
	sta.w Satt+$8,x
	stz.w Satt+$A,x
	sta.w Satt+$C,x
	stz.w Satt+$E,x
	sta.w Satt+$10,x
	stz.w Satt+$12,x
	sta.w Satt+$14,x
	stz.w Satt+$16,x
	sta.w Satt+$18,x
	stz.w Satt+$1A,x
	sta.w Satt+$1C,x
	stz.w Satt+$1E,x
	sta.w Satt+$20,x
	stz.w Satt+$22,x
	sta.w Satt+$24,x
	stz.w Satt+$26,x
	sta.w Satt+$28,x
	stz.w Satt+$2A,x
	sta.w Satt+$2C,x
	stz.w Satt+$2E,x
	sta.w Satt+$30,x
	stz.w Satt+$32,x
	sta.w Satt+$34,x
	stz.w Satt+$36,x
	sta.w Satt+$38,x
	stz.w Satt+$3A,x
	sta.w Satt+$3C,x
	stz.w Satt+$3E,x
	txa
	adc.w #$0040
	tax
	dey
	bne .loop
.hiclear:
	stz.w Satt,x
	inx
	inx
	cpx.w #$0220
	bne .hiclear
	stz.b sprcount
	inc.b sprclock
	lda.b sprnodraw
	beq .nosprnodraw
	stz.b sprnodraw
	lda.b sprslotlife
	cmp.w #$0003
	bcc .nosprnodraw
	dec.b sprslotlife
.nosprnodraw:
	lda.b sprbigslot
	sta.b sprbigslotend
	lda.b sprslot
	sta.b sprslotend
	rtl
