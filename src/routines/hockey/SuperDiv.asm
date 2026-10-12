SuperDiv:		;5 words at a3 divided by 1 word (d0).
		;   SNES: passbits (128 bits) / d0: quotient in passbits, remainder in d0. Shift-subtract over 128 bits with the divisor in mula+0..+16 and the remainder in
		;   mulres+0..+14
	phx		; remainder = passbits, divisor = d0 << 128
	ldx.w #$000E
.init:
	lda.w passbits,x
	sta.b mulres,x
	stz.b mula,x
	dex
	dex
	bpl .init
	lda.b d0
	sta.b mula+16
	ldx.w #$0080
.loop:
	lsr.b mula+16
	ror.b mula+14
	ror.b mula+12
	ror.b mula+10
	ror.b mula+8
	ror.b mula+6
	ror.b mula+4
	ror.b mula+2
	ror.b mula
	asl.w passbits		; shift the dividend left
	rol.w passbits+2
	rol.w passbits+4
	rol.w passbits+6
	rol.w passbits+8
	rol.w passbits+10
	rol.w passbits+12
	rol.w passbits+14
	lda.b mulres		; remainder >= divisor: subtract, quotient bit 1
	cmp.b mula
	lda.b mulres+2
	sbc.b mula+2
	lda.b mulres+4
	sbc.b mula+4
	lda.b mulres+6
	sbc.b mula+6
	lda.b mulres+8
	sbc.b mula+8
	lda.b mulres+10
	sbc.b mula+10
	lda.b mulres+12
	sbc.b mula+12
	lda.b mulres+14
	sbc.b mula+14
	lda.w #$0000
	sbc.b mula+16
	bcc .next
	lda.b mulres
	sbc.b mula
	sta.b mulres
	lda.b mulres+2
	sbc.b mula+2
	sta.b mulres+2
	lda.b mulres+4
	sbc.b mula+4
	sta.b mulres+4
	lda.b mulres+6
	sbc.b mula+6
	sta.b mulres+6
	lda.b mulres+8
	sbc.b mula+8
	sta.b mulres+8
	lda.b mulres+10
	sbc.b mula+10
	sta.b mulres+10
	lda.b mulres+12
	sbc.b mula+12
	sta.b mulres+12
	lda.b mulres+14
	sbc.b mula+14
	sta.b mulres+14
	inc.w passbits
.next:
	dex
	beq .done
	jmp.w .loop
.done:
	plx
	lda.b mulres
	sta.b d0
	clc
	rtl
