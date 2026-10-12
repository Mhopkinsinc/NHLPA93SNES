Intermission:		;end of period junk (zamboni/stats). Opens the pause menu screen (item list by period, +5 in playoffs), shows the ticker scores of the other games, then the highlights.
		;   Start on either pad cuts it short. Called from PeriodOver
		;   SNES: the pause menu screen with the ticker scores of the other games (IntermissionTick), then the highlights
	jsl.l sndqreset
	jsl.l SetupTeamForIntermission
	lda.w #$0000
	ldy.w #$001E
.0:
	sta.w Xpos,y
	dey
	dey
	bpl .0
.vc:
	lda.b vcount
	ldy.b vcount+2
	cmp.b vcount
	bne .vc
	sta.w vcountmark
	sty.w vcountmark+2
	lda.w #$0001
	trb.w sflags
	lda.w gsp
	cmp.w #$0004
	beq .ss
	bra .ss
.ss:
	lda.w #$0708
	sta.b pausetimer
	lda.w #$0001
	sta.w demoflag
	lda.b vcount
	sec
	sbc.w #$0150
	sta.w tickervc
	jsl.l InitTicker
	lda.w TickerNum
	sta.w tickerstart
.top:
	lda.w #$0000
	ldy.w #$001E
.clr:
	sta.w Xpos,y
	dey
	dey
	bpl .clr
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0C
	lda.w #$0016
	sta.b d0
	lda.w #$0007
	sta.b d1
	jsl.l Framer
	jsl.l printscores1
	lda.w #$0002
	trb.w sflags
	jsl.l PauseMenu
	bne .top
	stz.w demoflag
.rtl:
	rtl
