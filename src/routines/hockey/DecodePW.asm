DecodePW:		;translate char password in PassWord to variables used in game
		;   SNES: translate the password in PassWord to game variables: PWtoBits, then ReadPassBits
	jsl.l PWtoBits
	jml.l ReadPassBits
