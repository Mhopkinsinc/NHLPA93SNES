PWtoBits:		;convert password text into passbits
		;   SNES: convert the password text into passbits (ClrPassBits, then SuperMult by PWrange and SuperAdd per character)
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
