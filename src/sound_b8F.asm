; SPC700 uploads, the sound queue, music cues (keeps ScoutingReportText here too).
; Bank $8F. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8FFE7B
MusicCue:		;SNES: send driver command A (a music cue): the sound queue becomes just A (sndqueue, out 0, in 2), under sndlock
	pha
	lda.w #$0001
	sta.b sndlock
	pla
	sta.b sndqueue
	stz.b sndqout
	lda.w #$0002
	sta.b sndqin
	stz.b sndlock
	rtl
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
