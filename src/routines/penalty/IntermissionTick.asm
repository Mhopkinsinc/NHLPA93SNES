IntermissionTick:		;During the intermission, show the next ticker score from time to time, then the highlights
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
