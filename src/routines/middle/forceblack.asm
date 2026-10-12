forceblack:		;Turn the screen black: default interrupt handlers, mark the sprite tile caches stale and empty the transfer list
	phx
	lda.w #vb2_blank
	sta.b vbint
	lda.w #HBdefault
	sta.b hbint
	lda.b vcount
	pha
	lda.b sprclock
	sec
	sbc.w #$003C
	ldx.w #$0000
.frametime:
	sta.l sprframetime,x
	inx
	inx
	cpx.w #$4C74
	bne .frametime
	ldx.w #$0000
.slottime:
	sta.w sprslottime,x
	inx
	inx
	cpx.w #$0400
	bne .slottime
	pla
.vb:
	cmp.b vcount
	beq .vb
	stz.b DMAListend
	plx
	rtl
