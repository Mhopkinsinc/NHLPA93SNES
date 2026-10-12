vb2:		;vblank used for palfades only no dmas (vbint target).
		;   SNES: vblank for fades only, no dma. INIDISP from brightness, then vb2_main
	sep #$20
	lda.b brightness
	sta.w INIDISP
vb2_main:		;common vblank tail: vcount, sound tick (p_music_vblank), brightness fades (cramfade), rti
	rep #$30
	inc.b vcount
	bne .tick
	inc.b vcount+2
.tick:
	jsl.l p_music_vblank		; sound tick
	stz.b hcount		; clear the IRQ count every frame
	lda.b fadeout
	beq .fadein
	lda.b brightness
	beq .fadeoutdone
	lda.b vcount
	bit.w #$0003		; every 4th frame
	bne .fadein
	dec.b brightness
	bra .fadein
.fadeoutdone:
	stz.b fadeout
.fadein:
	lda.b fadein
	beq .exit
	cmp.w #$0001		; 1 = fading in, >1 = delay first
	bne .fadeindelay
	lda.b brightness
	cmp.w #$000F		; full brightness
	beq .fadeindone
	lda.b vcount
	bit.w #$0003
	bne .exit
	inc.b brightness
	bra .exit
.fadeindelay:
	dec.b fadein
	bra .exit
.fadeindone:
	stz.b fadein
.exit:
	ply
	plx
	pla
	stz.b vbactive		; vblank done
	rti
