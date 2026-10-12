NewTicker:		;Show the next ticker score once the clock is at 8:00 or less
	lda.w gameclock
	cmp.w #$01E1
	bcc NewTicker2
	rtl
