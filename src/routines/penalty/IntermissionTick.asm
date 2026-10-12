IntermissionTick:		;SNES: during the intermission show the next ticker score every $150 frames; after the last one the highlights (DoHiLights). A = 0: go on
	lda.w demoflag
	beq .rtl
	lda.b vcount
	sec
	sbc.w tickervc
	cmp.w #$0150
	bcc .wait
	jsl.l TickerNext
	lda.w tickerstart
	cmp.w TickerNum
	bne IntermissionTick
	jsl.l DoHiLights
	lda.w #$0008
	trb.w sflags3
.rtl:
	rtl
.wait:
	lda.w #$0000
	rtl
