p_music_vblank:		;vblank sound handler: every other frame send the next queued sound command (sndqueue) to APUIO0 and a counter to
		;   APUIO1; waits out sndsettle after a sample upload
	lda.w sndsettle		; wait after the sample upload
	bne .settle
	sep #$30
	lda.b sndlock
	bne .done
	lda.b vcount		; every other frame
	lsr a
	bcc .done
	ldx.b sndqout
	cpx.b sndqin
	beq .done
	lda.b sndqueue,x
	sta.w APUIO0
	inc.b sndptr		; sndptr (low byte) doubles as the command counter here
	lda.b sndptr
	sta.w APUIO1
	txa
	inc a
	inc a
	and.b #$0F
	sta.b sndqout
.done:
	rep #$30
	rtl
.settle:
	dec.w sndsettle
	rtl
