clockcont:		;monitor period clock and initiate various clock activated events
		;   SNES: clock at 0: freezewindow, then clockcont_0
	lda.w gmclock
	ora.w gameclock
	bne .rtl
	jsl.l freezewindow
	jmp.w clockcont_0
.rtl:
	rtl
