ClampNibble:		;clamp byte d3 to 0-15. Called by setplayer
		;   SNES: clamp A to 0-15
	bit.w #$0080		; negative: 0
	beq .hi
	lda.w #$0000
.hi:
	cmp.w #$000F
	bcc .x
	lda.w #$000F
.x:
	rtl
