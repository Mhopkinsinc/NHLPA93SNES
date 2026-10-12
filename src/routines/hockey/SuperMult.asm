SuperMult:		;password bits *= d0
	phx
	ldx.w #$000E
.copy:
	lda.w passbits,x		; copy passbits, clear passbits
	sta.b mulres,x
	stz.w passbits,x
	dex
	dex
	bpl .copy
	lda.b d0
	sta.b mula
.loop:
	lsr.b mula
	bcc .noadd
	lda.w passbits
	clc
	adc.b mulres
	sta.w passbits
	lda.w passbits+2
	adc.b mulres+2
	sta.w passbits+2
	lda.w passbits+4
	adc.b mulres+4
	sta.w passbits+4
	lda.w passbits+6
	adc.b mulres+6
	sta.w passbits+6
	lda.w passbits+8
	adc.b mulres+8
	sta.w passbits+8
	lda.w passbits+10
	adc.b mulres+10
	sta.w passbits+10
	lda.w passbits+12
	adc.b mulres+12
	sta.w passbits+12
	lda.w passbits+14
	adc.b mulres+14
	sta.w passbits+14
.noadd:
	asl.b mulres
	rol.b mulres+2
	rol.b mulres+4
	rol.b mulres+6
	rol.b mulres+8
	rol.b mulres+10
	rol.b mulres+12
	rol.b mulres+14
	lda.b mula
	bne .loop
	plx
	clc
	rtl
