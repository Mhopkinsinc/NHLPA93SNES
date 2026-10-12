marktexthi:		;SNES: textdirtyhi = max(textdirtyhi, A)
	cmp.b textdirtyhi
	bcc .rtl
	sta.b textdirtyhi
.rtl:
	rtl
