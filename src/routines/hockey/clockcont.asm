clockcont:		;When the clock runs out, freeze the view and end the period
	lda.w gmclock
	ora.w gameclock
	bne .rtl
	jsl.l freezewindow
	jmp.w clockcont_0
.rtl:
	rtl
