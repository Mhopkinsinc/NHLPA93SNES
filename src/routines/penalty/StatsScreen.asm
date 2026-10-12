StatsScreen:		;SNES: DisplayStats, then wait for A or 60 seconds
	jsl.l DisplayStats
	lda.b vcount
	pha
.wait:
	jsl.l setvideo
	jsl.l ReadPads
	jsl.l getpzjoy
	lda.b d1
	bit.w #$0080
	bne .exit
	lda.b vcount
	sec
	sbc.b $01,s
	cmp.w #$0E10
	bcc .wait
.exit:
	pla
	rtl
