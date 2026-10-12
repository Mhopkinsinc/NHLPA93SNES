DecodePW:		;Turn the password into the playoff state
	jsl.l PWtoBits
	jml.l ReadPassBits
