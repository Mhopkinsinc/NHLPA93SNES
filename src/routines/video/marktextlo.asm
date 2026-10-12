marktextlo:		;SNES: textdirtylo = min(textdirtylo, A)
	cmp.b textdirtylo
	bcs .rtl
	sta.b textdirtylo
.rtl:
	rtl
