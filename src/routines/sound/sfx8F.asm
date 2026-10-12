sfx8F:		;SNES: bank $8F copy of sfx: queue the sound pushed before the jsl (0 = none) unless within 180 frames of sfxmutetime; no lastsfx; returns through jmlvector. Also sends the
		;   crowd volume (KillCrowd, updatesound)
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
