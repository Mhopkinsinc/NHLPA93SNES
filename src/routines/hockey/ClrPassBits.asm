ClrPassBits:		;clr the 5 words of bits at a3
		;   SNES: clear passbits
	stz.w passbits
	stz.w passbits+2
	stz.w passbits+4
	stz.w passbits+6
	stz.w passbits+8
	stz.w passbits+10
	stz.w passbits+12
	stz.w passbits+14
	rtl
