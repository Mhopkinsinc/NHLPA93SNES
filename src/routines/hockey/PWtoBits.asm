PWtoBits:		;Turn the password characters into the password bits
	jsl.l ClrPassBits
	ldx.w #$0000
.char:
	lda.w #PWrange		; passbits = passbits * PWrange + PassWord[x]
	sta.b d0
	jsl.l SuperMult		; passbits *= d0
	lda.w PassWord,x
	and.w #$00FF
	sta.b d0
	stz.b d0+2
	jsl.l SuperAdd		; passbits += d0
	inx
	cpx.w #pwlength
	bne .char
	rtl
