; Penalties, scoreboard, ticker, intermission.
; Bank $8F. Each block keeps its ROM address with org; blocks of other modules sit between them.

org $8F83A7
PushRef:		;tell vblank what to display. d0 = ref frame, $40 clears the window. The horizontal ref uses RefMap2
		;   SNES: ref window frame d0 (RefsMap or RefsMapHor, 8 x 7 words) into textmap; d0 $40 erases the window and prefmes
	phx
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .savea
	ldx.b xsave
	lda.b d0
	cmp.w #$40
	bne .draw
	jmp.w .clearit
.draw:
	sta.b mulb
	lda.w #$70
	sta.b mula
	jsl.l mulu16
	sta.b d0
	lda.w #RefsMap
	sta.b a0
	lda.w #RefsMap>>16
	sta.b a0+2
	lda.w #(2*32+2)*2		; textmap offset of the window: row 2, column 2
	sta.b tmp1
	lda.w refchars
	sta.b tmp0
	lda.w sfhormode
	beq .nosfhormode
	lda.w refcharshor
	sta.b tmp0
	lda.w #(15*32+13)*2		; horizontal rink: row 15, column 13
	sta.b tmp1
	lda.w #RefsMapHor
	sta.b a0
	lda.w #RefsMapHor>>16
	sta.b a0+2
.nosfhormode:
	lda.b a0
	clc
	adc.b d0
	sta.b a0
	lda.w #$0008
	sta.b tmp2
.row:
	ldy.w #$0007
.1:
	lda.b [a0]
	clc
	adc.b tmp0
	adc.w charofs
	ldx.b tmp1
	ora.w #$2000
	sta.l textmap,x
	txa
	lsr a
	cmp.b textdirtylo
	bcs .lo
	sta.b textdirtylo
.lo:
	cmp.b textdirtyhi
	bcc .hi
	sta.b textdirtyhi
.hi:
	inc.b a0
	inc.b a0
	inc.b tmp1
	inc.b tmp1
	dey
	bne .1
	lda.b tmp1
	clc
	adc.w #$0032
	sta.b tmp1
	dec.b tmp2
	bne .row
	lda.w #sf2refref
	tsb.w sflags
	bra .ex
.clearit:
	lda.w #$0007
	sta.b d0
	lda.w #$0008
	sta.b d1
	lda.w blankchar
	sta.b d2
	lda.w #$0002
	sta.w printx
	sta.w printy
	lda.w sfhormode
	beq .nosfhormode2
	lda.w #$000D
	sta.w printx
	lda.w #$000F
	sta.w printy
.nosfhormode2:
	jsl.l eraser
	lda.w #sf2refref
	tsb.w sflags
	lda.w #$FFFF
	sta.b d0
	jsl.l prefmes
.ex:
	stx.b xsave
	ldx.w #$0006
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	plx
	rtl
SetHor:		;switch graphics to horizontal ice rink graphics mode. Does not remap the fonts
		;   SNES: switch to the horizontal rink (scoreboard screen): half puck speed, forceblack, sfhormode, StatsReport
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .savea
	ldx.b xsave
	lda.w puckvx
	pha
	asl a
	pla
	ror a
	sta.w puckvx
	lda.w puckvy
	pha
	asl a
	pla
	ror a
	sta.w puckvy
	jsl.l forceblack
	lda.w #$0001
	sta.w sfhormode
	stz.w Hscroll
	lda.w #$FFFF
	sta.w Vscroll
	lda.w #$002E
	sta.w Oldrow
	stz.w vramrow
	jsl.l SprSort
	jsl.l StatsReport
	stx.b xsave
	ldx.w #$001A
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$001A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl
USBoard:		;update score board, including the players in the penalty box and their time remaining. Called from InProgress and SetHor
		;   SNES: printscores1, then each team's penalty box players and their time (.dispen)
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
	ldx.b xsave
	jsl.l printscores1
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$14,$08
	stz.b a2
	jsl.l .dispen
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$08
	lda.w #$0002
	sta.b a2
	jsl.l .dispen
	stx.b xsave
	ldx.w #$000E
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
.dispen:		;penalty box list of team a2: timed players first
	lda.b a2
	beq .noa2
	lda.w #$001A
.noa2:
	sta.b a0
.l1:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .p2
	lda.b a2
	beq .noa22
	lda.w #$0034
.noa22:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	bne .l1
	jsl.l pplpen
	bra .l1
.p2:
	lda.b a2
	beq .noa23
	lda.w #$001A
.noa23:
	sta.b a0
.l2:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .rtl
	lda.b a2
	beq .noa24
	lda.w #$0034
.noa24:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	beq .l2
	jsl.l pplpen
	bra .l2
pplpen:		;Print one penalty box line: player number and time remaining. a2 = team, d0 = roster offset (player*2). Only rows up to y $A are printed; printy += 1. Called from USBoard .dispen
		;   SNES: player number and time left (rows up to y $A)
	lda.w printy
	cmp.w #$000B
	bcs USBoard_rtl
	lda.b a2
	beq .noa2
	lda.w #$0034
.noa2:
	adc.b d0
	tay
	lda.w tmpdst,y
	and.w #$07FF
	sta.b d2
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.b a2
	lda.w tmdata,y
	sta.b a1
	ldy.w #Playerdata
	adc.b [a1],y
	sta.b a1
	lsr.b d0
.find:
	lda.b [a1]
	clc
	adc.b a1
	adc.w #$0008
	sta.b a1
	dec.b d0
	bpl .find
	lda.b a1
	sec
	sbc.w #$0008
	sta.b a1
	lda.b [a1]
	and.w #$00FF
	sta.b d0
	lda.w printx
	pha
	lda.w #mesarea+2
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	jsl.l PutDigits2
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #$0004
	sta.b [a1]
	jsl.l print
	lda.b d2
	sta.b d0
	jsl.l PushTime
	inc.w printx
	jsl.l print
	pla
	sta.w printx
	inc.w printy
	rtl

org $8F86B6
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
InitTicker:		;SNES: start the ticker at the last game of the round (GetShifter) unless one is running, then NewTicker2
	lda.w TickerNum
	bmi .last
	ora.w gamenum
	bne .new
.last:
	jsl.l GetShifter
	lda.b d1
	sta.w TickerNum
	bmi Intermission_rtl
.new:
	jmp.w NewTicker2
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
TickerNext:		;SNES: next ticker game (restart at the last game of the round), NewTicker2
	lda.w TickerNum
	bmi .last
	ora.w gamenum
	bne .new
.last:
	jsl.l GetShifter
	lda.b d1
	sta.w TickerNum
	bmi IntermissionTick_rtl
.new:
	jmp.w NewTicker2

org $8F8858
NewTicker:		;show the next ticker score once the clock is at 8:00 or less. d3 = -1 if not. Called from chkprogress. Falls into NewTicker2
		;   SNES: once the clock is at 8:00 or less, the next ticker score
	lda.w gameclock
	cmp.w #$01E1
	bcc NewTicker2
	rtl
NewTicker2:		;goto next ticker. Return d3 = game, or neg if none left. Falls into CheckGameTickerStatus
		;   SNES: d3 = next ticker game (not the user game, no highlight coming, series not over)
	lda.w OptPlayMode
	beq .rtl
	lda.w TickerNum
	sta.b d3
	bmi .rtl
	dec.w TickerNum
	lda.b d3
	cmp.w gamenum
	beq NewTicker2
	bra NewTicker3
.rtl:
	rtl
NewTicker3:		;display ticker score for game d3 (a0 = gstruct entry), skip if d3 is negative. Called from chkprogress, Intermission and StartHL2
		;   SNES: the ticker box for game d3: GameLabels round name, period, both teams with scores (TickerTeam)
	lda.b d3
	asl a
	sta.b a0
	tay
	lda.w gsflags,y
	bit.w #$0006
	bne NewTicker2
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$02,$17
	lda.w sflags
	bit.w #$0001
	bne .pj
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$02,$17
.pj:
	lda.w sfhormode
	bne .frame
	lda.w printy
	sec
	sbc.w #$0005
	sta.w printy
.frame:
	lda.w #$001C
	sta.b d0
	lda.w #$0005
	sta.b d1
	jsl.l Framer
	lda.b vcount
	sta.w tickervc
	inc.w printx
	lda.w printy
	sec
	sbc.w #$0004
	sta.w printy
	lda.w printx
	pha
	jsl.l GetShifter
	lda.w #$2400
	sta.w printa
	jsl.l printz
	dw $001C		; printz inline string: length (counts itself), then control bytes / text
	db "                          "
	lda.b $01,s
	sta.w printx
	lda.b d3
	clc
	adc.b d2
	sta.b d0
	lda.w #GameLabels
	sta.b a1
	lda.w #GameLabels>>16
	sta.b a1+2
	jsl.l PrintStringFromList
	lda.b $01,s
	clc
	adc.w #$0015
	sta.w printx
	ldy.b a0
	lda.w gsper,y
	dec a
	sta.b d0
	lda.w #PerLabels
	sta.b a1
	lda.w #PerLabels>>16
	sta.b a1+2
	jsl.l PrintStringFromList
	lda.w #$2000
	sta.w printa
	ldy.b a0
	lda.w gst1,y
	sta.b d0
	lda.w gss1,y
	sta.b d1
	jsl.l TickerTeam
	ldy.b a0
	lda.w gst2,y
	sta.b d0
	lda.w gss2,y
	sta.b d1
	jsl.l TickerTeam
	pla
	rtl
TickerTeam:		;SNES: ticker line: team d0 name (TeamList record) and score d1, one row down
	lda.b $04,s
	sta.w printx
	inc.w printy
	lda.w #TeamList
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	asl.b d0
	asl.b d0
	ldy.b d0
	lda.b [a1],y
	sta.b a1
	lda.w #TeamList>>16
	sta.b a1+2
	ldy.w #Teamname
	lda.b [a1],y
	adc.b a1
	sta.b a1
	jsl.l print
	lda.b $04,s
	clc
	adc.w #$0017
	sta.w printx
	lda.b d1
	sta.b d0
	jsl.l PushNumber
	jml.l print
GameLabels:		;ticker titles, by OptPlayMode and gamelevel
	dw 19
	db "EASN Hockey Night"
	dw 18
	db "EA Cup Qualifier"
	dw 18
	db "EA Cup Qualifier"
	dw 18
	db "EA Cup Qualifier"
	dw 18
	db "EA Cup Qualifier"
	dw 18
	db "EA Cup Qualifier"
	dw 18
	db "EA Cup Qualifier"
	dw 18
	db "EA Cup Qualifier"
	dw 18
	db "EA Cup Qualifier"
	dw 17
	db "EA Quarterfinal"
	dw 17
	db "EA Quarterfinal"
	dw 17
	db "EA Quarterfinal"
	dw 17
	db "EA Quarterfinal"
	dw 18
	db "EA Cup Semifinal"
	dw 18
	db "EA Cup Semifinal"
	dw 14
	db "EA Cup final"

org $8F8C1B
DoHiLights:		;hilites logic: search for hilite game and show hilite. Called from Intermission
		;   SNES: in the playoffs play the highlight of each game of the round that asks for one (gsfhl, StartHL2)
	lda.w OptPlayMode
	beq .rtl
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.top:
	ldy.b a0
	lda.w gsflags,y
	bit.w #$0004
	bne .next
	bit.w #$0002
	beq .next
	and.w #$FFFD
	sta.w gsflags,y
	jsl.l SaveRegsStartHL2
.next:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .top
.rtl:
	rtl

org $8F8C72
updatepentime:		;update the time remaining on all penalized players, once a second
		;   SNES: once a second count down the penalty box times of both teams; release players whose time is up
	lda.w #$0020
	trb.w sflags3
	lda.w gmclock
	bne .rtl
	lda.w pentimer
	sec
	sbc.b d7
	sta.w pentimer
	bpl .rtl
	adc.w #$0018
	sta.w pentimer
	lda.w #$0020
	tsb.w sflags3
	jsl.l chkatop
	stz.b a2
	jsl.l .team
	lda.w #$0002
	sta.b a2
.team:		;team a2
	lda.b a2
	beq .noa2
	lda.w #$001A
.noa2:
	sta.b a0
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w #$0002
	sta.b d1
	sta.b d3
.next:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .done
	lda.b a2
	beq .noa22
	lda.w #$0034
.noa22:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	bne .coinpen
	dec.b d1
	bmi .next
	lda.b d0
	sta.b [a1]
	inc.b a1
	inc.b a1
	lda.w tmpdst,y
	dec a
	sta.w tmpdst,y
	bne .cont
	jsl.l RemovePlayerFromList
.cont:
	bra .next
.rtl:
	rtl
.done:
	lda.w mesarea
	sta.b d0
	lda.b d1
	cmp.w #$0001
	beq .chk
	lda.b d1
	bne .n1
	jsl.l .chk
	bra .two
.n1:
	lda.b d1
	cmp.w #$FFFF
	bne .rtl
.two:
	lda.w mesarea+2
	sta.b d0
.chk:		;release player d0 when his time is <= 5 (RemovePlayerFromList)
	lda.b a2
	beq .noa23
	lda.w #$0034
.noa23:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	sec
	sbc.w #$0005
	beq .le5
	bmi .lt
	bvs .le5
	bra .rtl
.lt:
	bvs .rtl
.le5:
	lda.w tmpdst,y
	bne .rtl2
	jsl.l releasepl
.rtl2:
	rtl
.coinpen:
	dec a
	sta.w tmpdst,y
	bit.w #$0800
	bne .coindone
	jmp.w .next
.coindone:
	bit.w #$1000
	bne .clr
	lda.w #$1000
	sta.w tmpdst,y
	jmp.w RemovePlayerFromList
.clr:
	lda.w #$0000
	sta.w tmpdst,y
	jmp.w RemovePlayerFromList
linebar:		;draw the energy bar of line d0 for team a2 at printx/printy (bitmap from the bar map, 16 steps). Called from SetLCmode2
		;   SNES: energy bar of line d0 (getlinee) as 5 small font characters
	jsl.l getlinee
	lda.w printa
	pha
	lda.w #$3000
	sta.w printa
	lda.b d0
	cmp.w #$1000
	bcc .max
	lda.w #$1000
.max:
	sta.b d0
	sta.b mula
	lda.w #$002F
	sta.b mulb
	jsl.l mulu
	lda.b mulres+2
	adc.w #$001D
	sta.w mesarea+2
	sta.w mesarea+3
	sta.w mesarea+4
	sta.w mesarea+5
	sta.w mesarea+6
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.b d0
	sta.b mula
	lda.w #$0054
	sta.b mulb
	jsl.l mulu
	lda.b mulres+2
	inc a
	inc a
	sta.b [a1]
	jsl.l print
	pla
	sta.w printa
	rtl

org $8F902A
InitScores:		;initialize other games scores/period in playoffs. Called from StartGame
		;   SNES: playoff rounds 0-1: random scores so far for the other games of the round (SetScore 1-3 times)
	lda.w OptPlayMode
	beq .rtl
	lda.w gamelevel
	cmp.w #$0002
	bcs .rtl
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.top:
	lda.b d1
	cmp.w gamenum
	beq .next
	ldy.b a0
	lda.w gsflags,y
	bit.w #$0004
	bne .next
	lda.w #$0000
	sta.w gsper,y
	lda.w #$0003
	sta.b d0
	jsl.l randomd0
	bra .1
.0:
	jsl.l SetScore
.1:
	dec.b d0
	bpl .0
.next:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .top
.rtl:
	rtl

org $8FD68C
PrintStringFromList:		;print string d0 of the String list a1 with printsmall
		;   SNES: print string d0 of the list [a1]
	lda.b d0
	bne .skip
	jml.l print
.skip:
	lda.b [a1]
	clc
	adc.b a1
	sta.b a1
	dec.b d0
	bra PrintStringFromList

org $8FD793
AdvanceStringPtr:		;Return a1 = string d0 of the String list a1
		;   SNES: a1 = string d0 of the list [a1]
	bra .cnt
.next:
	lda.b a1
	clc
	adc.b [a1]
	sta.b a1
.cnt:
	dec.b d0
	bpl .next
	rtl
AttribMenuSkater:		;SNES: player attribute menu (ShowGoalBox): 15-byte item strings, the rating bit mask and column, $FFFF ends
	dw 15
	db "   Status   ]"
	dw $0000,$0000		; bit mask, rating column
	dw 15
	db "[  Overall  ]"
	dw $1F3A,$000A		; bit mask, rating column
	dw 15
	db "[  Energy   ]"
	dw $0000,$0002		; bit mask, rating column
	dw 15
	db "[  Agility  ]"
	dw $1000,$000A		; bit mask, rating column
	dw 15
	db "[   Speed   ]"
	dw $0800,$000A		; bit mask, rating column
	dw 15
	db "[  Handed   ]"
	dw $0040,$0004		; bit mask, rating column
	dw 15
	db "[Off. Aware.]"
	dw $0400,$000A		; bit mask, rating column
	dw 15
	db "[Def. Aware.]"
	dw $0200,$000A		; bit mask, rating column
	dw 15
	db "[Shot Power ]"
	dw $0100,$000A		; bit mask, rating column
	dw 15
	db "[Shot  Accur]"
	dw $0010,$000A		; bit mask, rating column
	dw 15
	db "[Pass  Accur]"
	dw $0002,$000A		; bit mask, rating column
	dw 15
	db "[Stick Handl]"
	dw $0020,$000A		; bit mask, rating column
	dw 15
	db "[  Weight   ]"
	dw $2000,$0006		; bit mask, rating column
	dw 15
	db "[ Endurance ]"
	dw $0008,$000A		; bit mask, rating column
	dw 15
	db "[Aggression ]"
	dw $0001,$000A		; bit mask, rating column
	dw 15
	db "[ Checking  ]"
	dw $0080,$000A		; bit mask, rating column
	dw 15
	db "[  Fighting  "
	dw $0040,$0008		; bit mask, rating column
	dw $FFFF		; end
AttribMenuGoalie:		;SNES: goalie attribute menu
	dw 15
	db "   Status   ]"
	dw $0000,$0000		; bit mask, rating column
	dw 15
	db "[  Overall  ]"
	dw $1B0F,$000A		; bit mask, rating column
	dw 15
	db "[  Agility  ]"
	dw $1000,$000A		; bit mask, rating column
	dw 15
	db "[   Speed   ]"
	dw $0800,$000A		; bit mask, rating column
	dw 15
	db "[Glove Hand ]"
	dw $0040,$0004		; bit mask, rating column
	dw 15
	db "[Def. Aware.]"
	dw $0200,$000A		; bit mask, rating column
	dw 15
	db "[Puck Cont. ]"
	dw $0100,$000A		; bit mask, rating column
	dw 15
	db "[Stick Right]"
	dw $0008,$000A		; bit mask, rating column
	dw 15
	db "[Stick Left ]"
	dw $0004,$000A		; bit mask, rating column
	dw 15
	db "[Glove Right]"
	dw $0002,$000A		; bit mask, rating column
	dw 15
	db "[Glove Left ]"
	dw $0001,$000A		; bit mask, rating column
	dw 15
	db "[   Weight   "
	dw $2000,$0006		; bit mask, rating column
	dw $FFFF		; end
PositionNames:		;SNES: position names LD, RD, LW, C, RW
	dw 4
	db "LD"
	dw 4
	db "RD"
	dw 4
	db "LW"
	dw 3
	db "C"
	dw 4
	db "RW"
releasepl:		;player's penalty time is up so let him out (if appropriate). a2 = team, d0 = player*2. Called from ProcessPenaltyList
		;   SNES: player d0 leaves the penalty box: the next free object of team a2 comes on (tmap+1, priolist position), setplayer
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .savea
	ldx.b xsave
	ldy.b a2
	ldx.w tmsort,y
	dex
	dex
.find:
	inx
	inx
	lda.w position,x
	bpl .find
	lda.b d0
	lsr a
	sta.b d3
	ldy.b a2
	lda.w tmap,y
	sta.b d1
	inc a
	sta.w tmap,y
	lda.w #$0001
	tsb.w tmflags
	tsb.w tmflags+2
	lda.w #priolist
	sta.b a0
	lda.w #priolist>>16
	sta.b a0+2
	lda.w tmgoalie,y
	bpl .tmgoaliepos
	inc.b a0
.tmgoaliepos:
	ldy.b d1
	lda.b [a0],y
	and.w #$00FF
	sta.w position,x
	stx.b a3
	jsl.l Setplass
	jsl.l setplayer
	lda.w pflags,x
	ora.w #$1000
	sta.w pflags,x
	stx.b xsave
	ldx.w #$000E
.resta:
	pla
	sta.b a0,x
	dex
	dex
	bpl .resta
	ldx.b xsave
	stx.b xsave
	ldx.w #$000E
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	ldx.b a3
	rtl

org $8FDAFC
RemovePlayerFromList:		;remove the entry before a0 from a penalty box list by shifting the rest down (list ends with a negative byte). Return a0 = removed slot. Called from PenGoalStuff
		;   ProcessPenaltyList
		;   SNES: remove entry a0 from the penalty box list (tmboxlist) by shifting the rest down
	lda.w #$FFFF
	sta.b d2
.loop:
	inc.b d2
	lda.b a0
	clc
	adc.b d2
	tay
	sep #$20
	lda.w tmboxlist,y
	sta.w tmboxlist-1,y
	rep #$30
	bit.w #$0080
	beq .loop
	dec.b a0
	rtl

org $8FDBF9
loadTeamStruct:		;return a2 = team struct of player a3, a1 = the other team's struct. Called from ChkShotStat and updateplayers
		;   SNES: a2 = team of player X, a1 = the other team
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .rtl
	stz.b a1
	lda.w #$0002
	sta.b a2
.rtl:
	rtl

org $8FE00A
SetupTeamForIntermission:		;reset the bench, then for each team refill energy and pick the starting line: Pw1 (3) for the team with more players on ice, PK1 (5) for the team with fewer
		;   else 0. Called from Intermission
		;   SNES: ResetBench; both teams re-energized, line 0 (3/5 when a team is a man short or up)
	jsl.l ResetBench
	stz.b a2
	lda.w #$0002
	sta.b a3
	jsl.l .team
	stz.b a3
	lda.w #$0002
	sta.b a2
.team:		;team a2 (a3 = the other)
	jsl.l reenergizeteam
	ldx.b a3
	ldy.b a2
	stz.w tmline,x
	lda.w OptLine
	bne .rtl
	lda.w tmap,x
	sec
	sbc.w tmap,y
	sta.b d0
	beq .rtl
	lda.w #$0003
	sta.w tmline,x
	lda.b d0
	bpl .rtl
	lda.w #$0005
	sta.w tmline,x
.rtl:
	rtl

org $8FE2F9
ClearPenaltyBuffer:		;clear PenBuf. Also called from clockcont
		;   SNES: clear the 32 words of the penalty list (PenBuf)
	lda.w #$001F
	sta.b d0
	lda.w #PenBuf
	sta.b a0
	lda.w #$0000
	sta.b a0+2
.loop:
	lda.w #$0000
	sta.b [a0]
	inc.b a0
	inc.b a0
	dec.b d0
	bpl .loop
	rtl

org $8FF58D
StatsReport:		;SNES: clear the text screen, send 28 rows of HorRinkMap (32 columns each) to vram $0418 and, 8 columns
		;   in, to $0800, then USBoard
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$00,$00
	lda.w #$0020
	sta.b d0
	lda.w #$001D
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $FF,$00,$00
	lda.w #$0418
	sta.w VMADDL
	lda.w #$001C
	sta.b tmp0
	ldx.w #$0000
.row:
	ldy.w #$0020
.col:
	lda.l HorRinkMap,x
	sta.w VMDATAL
	inx
	inx
	dey
	bne .col
	txa
	clc
	adc.w #$0020
	tax
	dec.b tmp0
	bne .row
	lda.w #$0800
	sta.w VMADDL
	lda.w #$001C
	sta.b tmp0
	ldx.w #$0000
.row2:
	ldy.w #$0020
.col2:
	lda.l HorRinkMap+$10,x
	sta.w VMDATAL
	inx
	inx
	dey
	bne .col2
	txa
	clc
	adc.w #$0020
	tax
	dec.b tmp0
	bne .row2
	jmp.w USBoard

org $8FF63D
prefmes:		;print message for penalty d0 (negative clears it). Vertical mode: framed under the ref. Horizontal mode: one centered line on row $B
		;   SNES: print the message of penalty d0 (negative clears it). Vertical: framed under the ref at y $A, centred by its length; horizontal (sfhormode):
		;   ClearPenaltyMessage, one centred line at x $11, y $B. Saves d0-d2, a1
	stx.b xsave
	ldx.w #$0000
.save:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .save
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.savea1:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .savea1
	ldx.b xsave
	lda.w sfhormode
	beq .nosfhormode
	jmp.w .hor
.nosfhormode:
	lda.b d0
	bpl .d0pos
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$00,$0A
	lda.w #$000D
	sta.b d0
	lda.w #$0003
	sta.b d1
	lda.w blankchar
	sta.b d2
	jsl.l eraser
	jmp.w .ex
.d0pos:
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0A
	ldy.b d0
	lda.w #PenaltyList
	sta.b a1
	lda.w #PenaltyList>>16
.skip:
	sta.b a1+2
	lda.b [a1],y
	clc
	adc.b a1
	inc a
	inc a
	sta.b a1
	lda.b [a1]
	dec a
	dec a
	sta.b d0
	beq .ex
	inc a
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	bpl .pos
	stz.w printx
.pos:
	lda.b [a1]
	sta.b d0
	tay
	dec.b a1
	lda.b [a1],y
	inc.b a1
	and.w #$00FF
	bne .nonzero
	dec.b d0
.nonzero:
	lda.w #$0003
	sta.b d1
	jsl.l Framer
	dec.w printy
	dec.w printy
	inc.w printx
	jsl.l print
	bra .ex
.hor:
	jsl.l ClearPenaltyMessage
	lda.b d0
	bmi .ex
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$11,$0B
	lda.w #PenaltyList
	sta.b a1
	lda.w #PenaltyList>>16
.skip2:
	sta.b a1+2
	ldy.b d0
	lda.b [a1],y
	clc
	adc.b a1
	inc a
	inc a
	sta.b a1
	lda.b [a1]
	lsr a
	sta.b d0
	lda.w printx
	sec
	sbc.b d0
	sta.w printx
	jsl.l print
.ex:
	stx.b xsave
	ldx.w #$0002
.resta1:
	pla
	sta.b a1,x
	dex
	dex
	bpl .resta1
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.restore:
	pla
	sta.b d0,x
	dex
	dex
	bpl .restore
	ldx.b xsave
	rtl
