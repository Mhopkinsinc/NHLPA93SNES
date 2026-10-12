assfaceoff:		;asstab $16. players do nothing until faceoff is over
		;   SNES: also starts the goal / period / mid-period music cues
	lda.w pfalock,x
	bne .rts
	lda.w sflags
	bit.w #sf2faceoff		; faceoff over: exit
	beq assexit
	lda.w goalcue		; home goal music cue
	beq .per
	stz.w goalcue
	lda.w #$0001		; hold and clear the sound queue
	sta.b sndlock
	stz.b sndqin
	stz.b sndqout
	jsl.l StartSong1		; home goal music cue
.per:
	lda.w percue		; period start music cue
	beq .mid
	stz.w percue
	lda.w #$0001
	sta.b sndlock
	stz.b sndqin
	stz.b sndqout
	jsl.l StartSong2		; period start music cue
.mid:
	lda.w cuetimer		; no cue playing, clock >= 60 and past midpercue: mid-period cue
	bne .rts
	lda.w gameclock
	cmp.w #$003C
	bcc .rts
	cmp.w midpercue
	bcs .rts
	stz.w midpercue
	jsl.l StartSong5		; mid-period music cue
.rts:
	rtl
