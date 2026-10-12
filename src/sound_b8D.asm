; SPC700 uploads, the sound queue, music cues (keeps ScoutingReportText here too).
; Bank $8D. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8D865A
updatesound:		;move the crowd noise volume (psg noise channel) toward crowdlevel.
		;   SNES: move the crowd volume (asv) toward crowdlevel; send it to the sound driver when it changes (crowdvol)
	ldy.b d7
	lda.b crowdlevel		; target volume crowdlevel * 8 + $200 (max $CFF)
	asl a
	asl a
	asl a
	adc.w #$0200
	cmp.w #$0CFF
	bcc .ip
	lda.w #$0CFF
.ip:
	sta.b tmp0
.step:
	lda.b tmp0
	sec
	sbc.w asv
	lsr a
	lsr a
	lsr a
	lsr a
	bit.w #$0800
	beq .add
	ora.w #$F000
.add:
	clc
	adc.w asv
	sta.w asv
	dey
	bne .step
	sta.b mula
	lda.w #$009D		; scale to 0-$9D, + $80
	sta.b mulb
	jsl.l mulu
	lda.b mulres+2
	adc.w #$0080
	cmp.w crowdvol
	beq .rtl
	sta.w crowdvol
	pha
	jsl.l sfx8F		; send it
.rtl:
	rtl
