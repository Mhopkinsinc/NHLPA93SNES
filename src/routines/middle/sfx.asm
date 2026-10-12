sfx:		;play sound effect number. One word passed on stack
		;   SNES: play the sound number pushed before the jsl (it is pulled here). Dropped within 180 frames of sfxmutetime; remembered in lastsfx
	pla		; return address +1 into jmlvector
	inc a
	sta.w jmlvector+1
	sep #$20
	pla
	sta.w jmlvector+3
	rep #$20
	lda.b vcount		; sound effects muted?
	sec
	sbc.w sfxmutetime
	cmp.w #$00B4
	bcc .drop
	pla		; lastsfx = sound number
	sta.w lastsfx
	beq .ret
	jsl.l QueueSound
.ret:		;return through jmlvector
	jml.l jmlvector
.drop:
	pla
	bra .ret
