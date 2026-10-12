sfx8F:		;Queue the sound number pushed before the call, unless sound effects are muted for now. Also sends the crowd volume
	pla		; return address +1 into jmlvector
	inc a
	sta.w jmlvector+1
	sep #$20
	pla
	sta.w jmlvector+3
	rep #$20
	lda.b vcount
	sec
	sbc.w sfxmutetime
	cmp.w #$00B4
	bcc .muted
	pla		; the sound (0 = none)
	beq .ret
	jsl.l QueueSound
.ret:
	jml.l jmlvector
.muted:
	pla
	bra .ret
