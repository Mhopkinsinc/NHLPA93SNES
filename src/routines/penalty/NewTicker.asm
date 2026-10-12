NewTicker:		;show the next ticker score once the clock is at 8:00 or less. d3 = -1 if not. Called from chkprogress. Falls into NewTicker2
		;   SNES: once the clock is at 8:00 or less, the next ticker score
	lda.w gameclock
	cmp.w #$01E1
	bcc NewTicker2
	rtl
