Findhittype:		;Swing type of player X for direction d0: forehand or backhand
	lda.b d0
	eor.w #$FFFF
	inc a
	clc
	adc.w facedir,x
	and.w #$0007
	sta.b d0
	lda.w attribute,x
	bit.w #$0800
	beq .noattribute
	phx
	ldx.b d0
	lda.l .xflip,x		; x flip: backhand for d0 4-7
	plx
	and.w #$00FF
	rtl
.noattribute:
	phx
	ldx.b d0
	lda.l .noflip,x		; backhand for d0 1-4
	plx
	and.w #$00FF
	rtl
.xflip:		;x flip: 1 = backhand for d0 4-7 (%11110000); its last 5 bytes start .noflip
	db $00,$00,$00
.noflip:		;1 = backhand for d0 1-4
	db $00,$01,$01,$01,$01,$00,$00,$00
