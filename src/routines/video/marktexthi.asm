marktexthi:		;Raise the high end of the changed text map area to A
	cmp.b textdirtyhi
	bcc .rtl
	sta.b textdirtyhi
.rtl:
	rtl
