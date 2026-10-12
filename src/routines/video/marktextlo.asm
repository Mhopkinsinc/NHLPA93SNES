marktextlo:		;Lower the low end of the changed text map area to A
	cmp.b textdirtylo
	bcs .rtl
	sta.b textdirtylo
.rtl:
	rtl
