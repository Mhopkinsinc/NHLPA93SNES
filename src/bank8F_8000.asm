; $8F8000-$8F9084  ROM $78000-$79084: BigFontMap, an unused energy bar routine, PerLabels, EASNLogoMap, BigFontIndex; the clock, ref, scoreboard
; and ticker code (showclock, PushRef, SetHor, USBoard, Intermission, NewTicker), clockcont, updatepentime, linebar, the pause and replay
; helpers, the textmap/rink DMA queuers, InitScores, ResetPassWord. Ends before SpriteSet1 (boundary moved from $8F8FFF).
org $8F8000
BigFontMap:		;93G bigfont.map: big font tiles of each character: 76 top-row words, then the 76 bottom-row words (+$98); printbig uses BigFontIndex
	dw $0400,$0401,$0402,$0403,$0404,$0405,$0406,$0407
	dw $0408,$0409,$0408,$0409,$040A,$040B,$040C,$040D
	dw $040E,$040F,$0410,$0411,$0412,$0413,$0414,$0415
	dw $0416,$0417,$0418,$0419,$041A,$041B,$041C,$041D
	dw $041E,$041B,$041F,$0420,$0421,$0422,$0423,$0424
	dw $0425,$0424,$0426,$0427,$0428,$0429,$042A,$042B
	dw $042C,$042D,$042E,$042F,$0430,$0431,$0432,$0433
	dw $0434,$0435,$0436,$0437,$0438,$0439,$043A,$043B
	dw $043C,$043D,$043E,$043F,$0440,$0441,$0442,$0443
	dw $0414,$0444,$0445,$0446,$0447,$0448,$0449,$044A
	dw $044B,$044C,$044D,$044E,$044F,$0450,$0451,$0452
	dw $0453,$0454,$0455,$0456,$0457,$0458,$0459,$045A
	dw $045B,$0458,$045C,$045D,$045E,$045F,$0460,$0461
	dw $0462,$0463,$0464,$0465,$0466,$0467,$0468,$0469
	dw $046A,$046B,$046C,$046D,$0459,$046E,$046F,$0470
	dw $0471,$0472,$0473,$0474,$0475,$0476,$0477,$0478
	dw $0479,$047A,$047B,$047C,$047D,$047E,$047F,$0480
	dw $0481,$0482,$0483,$0484,$0485,$0486,$0487,$0488
	dw $0489,$048A,$048B,$048C,$0442,$048D,$048E,$048F
unusedEnergyBar:		;SNES: no caller found: a 4-character energy bar of d0 (8 levels per character) printed at printx-11, palette by d1
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.loop:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .loop
	ldx.b xsave
	lda.w #$2000
	sta.w printa
	lda.b d0
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	lsr a
	cmp.w #$0020
	bcc .lt
	lda.w #$001F
.lt:
	sta.b d0
	ldy.w #$0002
	lda.w #$0006
	sta.w mesarea
	lda.w #$0003
	sta.b d3
.loop2:
	lda.w #$FFFF
	sta.b d2
	lda.b d0
	bmi .d0neg
	sta.b d2
	cmp.w #$0008
	bcc .d0neg
	lda.w #$0007
	sta.b d2
.d0neg:
	lda.b d2
	sec
	adc.b d1
	and.w #$00FF
	bne .nonzero
	lda.w #$0020
.nonzero:
	sta.w mesarea,y
	iny
	lda.b d0
	sec
	sbc.w #$0008
	sta.b d0
	dec.b d3
	bpl .loop2
	lda.b d1
	beq .nod1
	lda.w #$0C00
	tsb.w printa
.nod1:
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.w printx
	sec
	sbc.w #$000B
	sta.w printx
	lda.w #$4000
	tsb.w printa
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	sep #$20
	lda.w mesarea+5
	ldy.w mesarea+2
	sta.w mesarea+2
	sty.w mesarea+5
	rep #$30
	lda.w mesarea+3
	xba
	sta.w mesarea+3
	lda.w #$4000
	trb.w printa
	stx.b xsave
	ldx.w #$0002
.loop3:
	pla
	sta.b a1,x
	dex
	dex
	bpl .loop3
	ldx.b xsave
	stx.b xsave
	ldx.w #$000E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	rtl
linelist:		;93G linelist (hockey93_11): the line choice names (PrintStringFromList in bank $80): Sc1, Sc2, Chk, Pw1, Pw2, PK1, PK2
	dw 5
	db "Sc1"
	dw 5
	db "Sc2"
	dw 5
	db "Chk"
	dw 5
	db "Pw1"
	dw 5
	db "Pw2"
	dw 5
	db "PK1"
	dw 5
	db "PK2"
PerLabels:		;93G PerLabels: period names (gsp 0-4); $12-$14 are the "st", "nd", "rd" small font tiles
	dw 4
	db "1",$12
	dw 4
	db "2",$13
	dw 4
	db "3",$14
	dw 4
	db "OT"
	dw 7
	db "Final"
EASNLogoMap:		;93G easn.map (small): the 7 x 2 EASN logo tile words for EASNLogo (unusedchars + n)
	dw $0400,$0401,$0402,$0403,$0404,$0405,$0406
	dw $0407,$0408,$0409,$040A,$040B,$040C,$040D
BigFontIndex:		;SNES: big font index of each character $20-$5A (*2 into BigFontMap); negative = one column wide
	db $00,$B7,$00,$00,$00,$00,$00,$BA,$00,$00,$00,$00,$00,$00,$C2,$00
	db $33,$CB,$36,$38,$3A,$3C,$3E,$40,$42,$44,$BB,$00,$00,$00,$00,$48
	db $4A,$00,$02,$04,$06,$08,$0A,$0C,$0E,$F0,$11,$13,$15,$17,$19,$1B
	db $1D,$1F,$21,$23,$25,$27,$29,$2B,$2D,$2F,$31
showclock:		;93G showclock (video93_2): the game clock m:ss at x 3, y $18 (horizontal rink: x $D, y 4; not when gsp = 4); not in replay
	lda.w sflags
	bit.w #sf2replay
	beq .nosf2replay
	jmp.w .rtl
.nosf2replay:
	lda.w #$0007
	sta.w mesarea
	lda.w #$0020
	sta.w mesarea+2
	lda.w gameclock
	sta.b mulb
	lda.w #600
	sta.b mula
	jsl.l divu16
	beq .zero
	adc.w #$0030
	sta.w mesarea+2
.zero:
	lda.w #60
	sta.b mula
	lda.b mulres+2
	sta.b mulb
	jsl.l divu16
	adc.w #$0030
	sta.w mesarea+3
	lda.w #':'
	sta.w mesarea+4
	lda.w #10
	sta.b mula
	lda.b mulres+2
	sta.b mulb
	jsl.l divu16
	adc.w #$0030
	sta.w mesarea+5
	lda.b mulres+2
	adc.w #$0030
	sta.w mesarea+6
	lda.w #$2000
	sta.w printa
	lda.w #$0003
	sta.w printx
	lda.w #$0018
	sta.w printy
	lda.w sfhormode
	beq .nosfhormode
	lda.w #$000D
	sta.w printx
	lda.w #$0004
	sta.w printy
	lda.w gsp
	cmp.w #$0004
	beq .rtl
.nosfhormode:
	lda.w #mesarea
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	jml.l print
.rtl:
	rtl
asseben:		;asstab 9. 93G asseben (logic93_2): player X comes onto the ice from the bench door (SPAwallright), then assexit
	lda.w pfalock,x
	bne .rtl
	lda.w pflags,x
	bit.w #$0002
	beq .nopflags
	and.w #$FFFD
	sta.w pflags,x
	stz.w Xvel,x
	stz.w Yvel,x
	txa
	lsr a
	sec
	sbc.w #$0006
	bmi .neg
	inc a
.neg:
	sta.b mulb
	lda.w #$000E
	sta.b mula
	jsl.l muls16
	sta.w Ypos,x
	lda.w #$FF78
	sta.w Xpos,x
	lda.w #$0002
	sta.w facedir,x
	sta.w pfalock,x
	lda.w #$101A
	sta.b d1
	jml.l SetSPA
.rtl:
	rtl
.nopflags:
	lda.w #$0004
	sta.w facedir,x
	lda.w pflags,x
	and.w #$6FFF
	sta.w pflags,x
	stz.w pfnc,x
	stz.w SPA,x
	lda.w #$1000
	sta.w Xvel,x
	jml.l assexit
PushRef:		;93G PushRef: ref window frame d0 (RefsMap or RefsMapHor, 8 x 7 words) into textmap; d0 $40 erases the window and prefmes
	phx
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .pusha
	ldx.b xsave
	lda.b d0
	cmp.w #$40
	bne .d0ne
	jmp.w .join
.d0ne:
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
.loop:
	ldy.w #$0007
.loop2:
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
	bcs .ge
	sta.b textdirtylo
.ge:
	cmp.b textdirtyhi
	bcc .lt
	sta.b textdirtyhi
.lt:
	inc.b a0
	inc.b a0
	inc.b tmp1
	inc.b tmp1
	dey
	bne .loop2
	lda.b tmp1
	clc
	adc.w #$0032
	sta.b tmp1
	dec.b tmp2
	bne .loop
	lda.w #sf2refref
	tsb.w sflags
	bra .join2
.join:
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
.join2:
	stx.b xsave
	ldx.w #$0006
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	plx
	rtl
SetHor:		;93G SetHor: switch to the horizontal rink (scoreboard screen): half puck speed, forceblack, sfhormode, StatsReport
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .pusha
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
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$001A
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
	rtl
USBoard:		;93G USBoard (penalty93_2): printscores1, then each team's penalty box players and their time (.dispen)
	stx.b xsave
	ldx.w #$0000
.pushd:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .pushd
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.pusha:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .pusha
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
.popa:
	pla
	sta.b a0,x
	dex
	dex
	bpl .popa
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.popd:
	pla
	sta.b d0,x
	dex
	dex
	bpl .popd
	ldx.b xsave
	ldx.b a3
.rtl:
	rtl
.dispen:		;93G .dispen: penalty box list of team a2: timed players first
	lda.b a2
	beq .noa2
	lda.w #$001A
.noa2:
	sta.b a0
.loop:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .nonzero
	lda.b a2
	beq .noa22
	lda.w #$0034
.noa22:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	bne .loop
	jsl.l pplpen
	bra .loop
.nonzero:
	lda.b a2
	beq .noa23
	lda.w #$001A
.noa23:
	sta.b a0
.loop2:
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
	beq .loop2
	jsl.l pplpen
	bra .loop2
pplpen:		;93G pplpen: one penalty box line: player number and time left (rows up to y $A)
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
.loop:
	lda.b [a1]
	clc
	adc.b a1
	adc.w #$0008
	sta.b a1
	dec.b d0
	bpl .loop
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
pushnumber:		;93G pushnumber: mesarea string of the decimal number d0 (built backward from $1AF)
	lda.w #mesarea+30
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.b d0
.loop:
	sta.b mulb
	lda.w #$000A
	sta.b mula
	jsl.l divu16
	dec.b a1
	sep #$20
	lda.b mulres+2
	adc.b #$30
	sta.b [a1]
	rep #$30
	lda.b mulres
	bne .loop
	dec.b a1
	dec.b a1
	lda.w #$01AF
	sec
	sbc.b a1
	sta.b [a1]
	rtl
Intermission:		;93G Intermission (SNES form): the pause menu screen with the ticker scores of the other games (IntermissionTick), then the highlights
	jsl.l sndqreset
	jsl.l SetupTeamForIntermission
	lda.w #$0000
	ldy.w #$001E
.loop:
	sta.w Xpos,y
	dey
	dey
	bpl .loop
.loop2:
	lda.b vcount
	ldy.b vcount+2
	cmp.b vcount
	bne .loop2
	sta.w vcountmark
	sty.w vcountmark+2
	lda.w #$0001
	trb.w sflags
	lda.w gsp
	cmp.w #$0004
	beq .gspeq
	bra .gspeq
.gspeq:
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
.loop3:
	lda.w #$0000
	ldy.w #$001E
.loop4:
	sta.w Xpos,y
	dey
	dey
	bpl .loop4
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
	bne .loop3
	stz.w demoflag
.rtl:
	rtl
InitTicker:		;SNES: start the ticker at the last game of the round (GetShifter) unless one is running, then NewTicker2
	lda.w TickerNum
	bmi .TickerNumneg
	ora.w gamenum
	bne .goNewTicker2
.TickerNumneg:
	jsl.l GetShifter
	lda.b d1
	sta.w TickerNum
	bmi Intermission_rtl
.goNewTicker2:
	jmp.w NewTicker2
StatsScreen:		;SNES: DisplayStats, then wait for A or 60 seconds
	jsl.l DisplayStats
	lda.b vcount
	pha
.loop:
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
	bcc .loop
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
	bcc .lt
	jsl.l TickerNext
	lda.w tickerstart
	cmp.w TickerNum
	bne IntermissionTick
	jsl.l DoHiLights
	lda.w #$0008
	trb.w sflags3
.rtl:
	rtl
.lt:
	lda.w #$0000
	rtl
TickerNext:		;SNES: next ticker game (restart at the last game of the round), NewTicker2
	lda.w TickerNum
	bmi .TickerNumneg
	ora.w gamenum
	bne .goNewTicker2
.TickerNumneg:
	jsl.l GetShifter
	lda.b d1
	sta.w TickerNum
	bmi IntermissionTick_rtl
.goNewTicker2:
	jmp.w NewTicker2
KillCrowd:		;93G KillCrowd: crowd volume $88 (silence) to the sound driver
	lda.w #$0088
	pha
	jsl.l sfx8F
	rtl
appstring:		;93G appstring: append string [a1] to the string [a3]
	lda.w #$0002
	sta.b tmp0
	lda.b [a3]
	sta.b tmp1
.loop:
	lda.b tmp0
	cmp.b [a1]
	beq .tmp0eq
	tay
	lda.b [a1],y
	ldy.b tmp1
	sta.b [a3],y
	inc.b tmp0
	inc.b tmp1
	bra .loop
.tmp0eq:
	lda.b tmp1
	sta.b [a3]
	rtl
PushTime:		;93G PushTime: mesarea string m:ss of the time d0 (seconds)
	lda.w #mesarea+30
	sta.b a1
	lda.w #mesarea>>16
	sta.b a1+2
	lda.b d0
	sta.b mulb
	lda.w #$000A
	sta.b mula
	jsl.l divu16
	dec.b a1
	sep #$20
	lda.b mulres+2
	adc.b #$30
	sta.b [a1]
	rep #$30
	lda.w #$0006
	sta.b mula
	jsl.l divu16
	dec.b a1
	sep #$20
	lda.b mulres+2
	adc.b #$30
	sta.b [a1]
	dec.b a1
	lda.b #$3A
	sta.b [a1]
	rep #$30
	lda.w #$000A
	sta.b mula
	jsl.l divu16
	dec.b a1
	sep #$20
	lda.b mulres+2
	adc.b #$30
	sta.b [a1]
	rep #$30
	lda.b mulres
	beq .nomulres
	dec.b a1
	sep #$20
	adc.b #$30
	sta.b [a1]
	rep #$30
.nomulres:
	dec.b a1
	dec.b a1
	lda.w #$01AF
	sec
	sbc.b a1
	sta.b [a1]
	rtl
NewTicker:		;93G NewTicker: once the clock is at 8:00 or less, the next ticker score
	lda.w gameclock
	cmp.w #$01E1
	bcc NewTicker2
	rtl
NewTicker2:		;93G NewTicker2/CheckGameTickerStatus: d3 = next ticker game (not the user game, no highlight coming, series not over)
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
NewTicker3:		;93G NewTicker3: the ticker box for game d3: GameLabels round name, period, both teams with scores (TickerTeam)
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
	bne .sflags
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$02,$17
.sflags:
	lda.w sfhormode
	bne .sfhormode
	lda.w printy
	sec
	sbc.w #$0005
	sta.w printy
.sfhormode:
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
	jsl.l pushnumber
	jml.l print
GameLabels:		;SNES GameLabels (93G GameLabels): the ticker round names by playoff game (EASN Hockey Night for the regular season)
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
showzam:		;93G showzam role: on the horizontal rink the zamboni sprite ($22D) moves with the time since vcountmark
	lda.b vcount
	ldy.b vcount+2
	cmp.b vcount
	bne showzam
	sbc.w vcountmark
	sta.b tmp0
	tya
	sbc.w vcountmark+2
	bne .rtl
	lda.w sfhormode
	beq .rtl
	lda.b tmp0
	lsr a
	lsr a
	sta.b sprx
	lda.w #$00C8
	sta.b spry
	lda.w #$022D
	sta.b sprframe
	jsl.l addframe
.rtl:
	rtl
waitxsr:		;92G waitxsr: wait d0 frames or until a pad button (d1)
	lda.b d0
	pha
.loop:
	jsl.l Readjoy1
	lda.b d1
	bne .exit
	jsl.l Readjoy2
	lda.b d1
	bne .exit
	jsl.l setvideo
	lda.b vcount
.loop2:
	cmp.b vcount
	beq .loop2
	jsl.l ReadPads
	pla
	dec a
	pha
	bpl .loop
.exit:
	pla
	rtl
clockcont:		;93G clockcont (hockey93_01): clock at 0: freezewindow, then clockcont_0
	lda.w gmclock
	ora.w gameclock
	bne .rtl
	jsl.l freezewindow
	jmp.w clockcont_0
.rtl:
	rtl
clockcont_0:		;93G clockcont_0: end of period: puck pucknorm; third period winners celebrate (assscore, the Stanley Cup in the final), the game clock stops
	ldx.w #$001C
	stx.b a3
	lda.w #$18
	sta.b d0
	jsl.l assinsert
	lda.w gsp
	cmp.w #$0002
	bcs .gspge
	jmp.w .join
.gspge:
	lda.w #$0007
	sta.b d0
	ldx.w #$0000
	stx.b a3
	lda.w gamelevel
	cmp.w #$0003
	bne .gamelevelne
	lda.b bosgames
	cmp.w #$0007
	beq .bosgameseq
	lda.w gamenum
	asl a
	sta.b a0
	tay
	stz.b d3
	lda.w gsflags,y
	bit.w #$0001
	beq .nogsflags
	lda.w #$0010
	sta.b d3
.nogsflags:
	lda.w tmscore
	cmp.w tmscore+2
	bpl .tmscorepos
	lda.b d3
	eor.w #$0010
	sta.b d3
.tmscorepos:
	lda.b a0
	clc
	adc.b d3
	tay
	lda.w gspotwins,y
	cmp.w #$0003
	bne .gamelevelne
.bosgameseq:
	lda.w #$0008
	sta.b d0
	lda.w #$000B
	sta.b d2
.loop:
	lda.w pflags,x
	and.w #$FFF7
	sta.w pflags,x
	inx
	inx
	dec.b d2
	bpl .loop
	ldx.w #$0000
	stx.b a3
.gamelevelne:
	lda.w #$0005
	sta.b d2
	lda.w tmscore
	cmp.w tmscore+2
	beq .join
	bpl .loop2
	ldx.w #$000C
	stx.b a3
.loop2:
	lda.w position,x
	beq .noposition
	jsl.l assinsert
	lda.w #$0007
	sta.b d0
.noposition:
	inx
	inx
	stx.b a3
	dec.b d2
	bpl .loop2
.loop3:
	jsl.l ClearPenaltyBuffer
	lda.b crowdlevel
	clc
	adc.w #$03E8
	sta.b crowdlevel
	lda.w #$0040
	sta.w gmclock
	tsb.w gmode
	lda.w tmscore
	cmp.w tmscore+2
	bmi .tmscoreneg
	stz.b crowdlevel
	lda.w #$0003
	sta.w cheercnt
	lda.b vcount
	sec
	sbc.w #$0096
	sta.w cheervc
.tmscoreneg:
	lda.w #$0004
	sta.b d0
	jml.l AddPenalty2
.join:
	lda.w gsp
	cmp.w #$0003
	bne .gspne
	lda.w OptPlayMode
	beq .loop3
.gspne:
	lda.w #$0002
	sta.b d0
	jml.l AddPenalty2
DoHiLights:		;92G DoHiLights: in the playoffs play the highlight of each game of the round that asks for one (gsfhl, StartHL2)
	lda.w OptPlayMode
	beq .rtl
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.loop:
	ldy.b a0
	lda.w gsflags,y
	bit.w #$0004
	bne .gsflags
	bit.w #$0002
	beq .gsflags
	and.w #$FFFD
	sta.w gsflags,y
	jsl.l far8DF888
.gsflags:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .loop
.rtl:
	rtl
assdopen:		;asstab $D. 93G assdopen (logic93_2): add player X to the penalty box (PBnum), position -1, frame 0
	lda.w pfalock,x
	bne .rtl
	lda.w #$0010
	sta.b d0
	lda.w pfteam,x
	beq .nopfteam
	lda.w #$0001
	sta.b d0
.nopfteam:
	lda.w PBnum
	clc
	adc.b d0
	sta.w PBnum
	lda.w #$FFFF
	sta.w position,x
	stz.w frame,x
.rtl:
	rtl
updatepentime:		;93G updatepentime: once a second count down the penalty box times of both teams; release players whose time is up
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
.loop:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .nonzero
	lda.b a2
	beq .noa22
	lda.w #$0034
.noa22:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	bne .tmpdst2
	dec.b d1
	bmi .loop
	lda.b d0
	sta.b [a1]
	inc.b a1
	inc.b a1
	lda.w tmpdst,y
	dec a
	sta.w tmpdst,y
	bne .tmpdst
	jsl.l RemovePlayerFromList
.tmpdst:
	bra .loop
.rtl:
	rtl
.nonzero:
	lda.w mesarea
	sta.b d0
	lda.b d1
	cmp.w #$0001
	beq .rel
	lda.b d1
	bne .d1
	jsl.l .rel
	bra .join
.d1:
	lda.b d1
	cmp.w #$FFFF
	bne .rtl
.join:
	lda.w mesarea+2
	sta.b d0
.rel:		;release player d0 when his time is <= 5 (RemovePlayerFromList)
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
	beq .notmpdst
	bmi .neg
	bvs .notmpdst
	bra .rtl
.neg:
	bvs .rtl
.notmpdst:
	lda.w tmpdst,y
	bne .rtl2
	jsl.l releasepl
.rtl2:
	rtl
.tmpdst2:
	dec a
	sta.w tmpdst,y
	bit.w #$0800
	bne .nonzero2
	jmp.w .loop
.nonzero2:
	bit.w #$1000
	bne .nonzero3
	lda.w #$1000
	sta.w tmpdst,y
	jmp.w RemovePlayerFromList
.nonzero3:
	lda.w #$0000
	sta.w tmpdst,y
	jmp.w RemovePlayerFromList
linebar:		;93G linebar: energy bar of line d0 (getlinee) as 5 small font characters
	jsl.l getlinee
	lda.w printa
	pha
	lda.w #$3000
	sta.w printa
	lda.b d0
	cmp.w #$1000
	bcc .d0lt
	lda.w #$1000
.d0lt:
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
lcfound:		;93G lcfound (logic93_1): d2 = line choice 0-2: getlchoice; loadTeamStruct, tmline, setpersonel, lcfound2
	ldx.b a3
	ldy.b a2
	lda.b d2
	sta.b d0
	sta.w tmlcchoice,y
	jsl.l getlchoice
	lda.b d0
	bmi .rtl
	lda.w pflags,x
	and.w #$DFFF
	ora.w #$0008
	sta.w pflags,x
	jsl.l loadTeamStruct
	ldy.b a2
	lda.w tmflags,y
	and.w #$FFF7
	sta.w tmflags,y
	lda.b d0
	sta.w tmline,y
	jsl.l setpersonel
	jml.l lcfound2
.rtl:
	rtl
startpause1:		;93G startpause1: pause started by controller 1 (sfpj off), startpause
	lda.w #$0002
	trb.w sflags
	jml.l startpause
PauseExit:		;92G PauseExit: restore textmap (textsave), sflags and the rink, printscores1, setvideo
	stz.w cuetimer
	stz.w crowdvol
	jsl.l forceblack
	phx
	ldx.w #$07FE
.loop:
	lda.l textsave,x
	sta.l textmap,x
	dex
	dex
	bpl .loop
	plx
	stz.b textdirtylo
	lda.w #$03FF
	sta.b textdirtyhi
	pla
	sta.w sflags
	pla
	sta.w sfhormode
	bne .nonzero
	jsl.l ClrHor
.nonzero:
	lda.w #$0001
	trb.w sflags
	jsl.l printscores1
	jsl.l setvideo
	lda.b vcount
	sta.w lastframevc
	sta.w oldvcount
	rtl
suba4:		;93G suba4: replay a4 one frame back (wrap at ReplayBufferStart unless sfwrap), RestoreReplayFrame; d7 = 0 at the end
	lda.b a4
	cmp.w #ReplayBufferStart
	bne .a4ne
	lda.b a4+2
	cmp.w #ReplayBufferStart>>16
	bne .a4ne
	lda.w sflags
	bit.w #sfwrap
	beq .nosfwrap
	lda.w #ReplayBufferEnd
	sta.b a4
	lda.w #ReplayBufferEnd>>16
	sta.b a4+2
.a4ne:
	lda.b a4
	sec
	sbc.w #replaysize
	sta.b a4
	lda.b a4+2
	sbc.w #$0000
	sta.b a4+2
	lda.b a4
	cmp.w ReplayBufferPtr
	beq .a4eq
	jml.l RestoreReplayFrame
.a4eq:
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	beq .a4eq2
	jml.l RestoreReplayFrame
.a4eq2:
	lda.b a4
	clc
	adc.w #replaysize
	sta.b a4
	lda.b a4+2
	adc.w #$0000
	sta.b a4+2
.nosfwrap:
	jsl.l RestoreReplayFrame
	stz.b d7
	rtl
adda4:		;93G adda4: replay a4 one frame on unless it reaches ReplayBufferPtr; d7 = 0 at the end
	stz.b d7
	lda.w sflags
	bit.w #sf2drec
	beq .nosf2drec
	lda.b a4+2
	pha
	lda.b a4
	pha
	jsl.l adda43
	lda.b a4
	sta.b tmp0
	lda.b a4+2
	sta.b tmp1
	pla
	sta.b a4
	pla
	sta.b a4+2
	lda.b tmp0
	cmp.w ReplayBufferPtr
	bne .nosf2drec
	lda.b tmp1
	cmp.w ReplayBufferPtr+2
	bne .nosf2drec
	rtl
.nosf2drec:
	lda.b a4
	cmp.w ReplayBufferPtr
	bne .a4ne
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	bne .a4ne
	rtl
.a4ne:
	jsl.l RestoreReplayFrame
	jml.l adda43
QueueTextDMA:		;SNES: DMAList entry for the changed textmap words (textdirtylo..textdirtyhi) to vram
	lda.b textdirtylo
	bmi .rtl
	ldy.b DMAListend
	sta.w DMAList+dmavram,y
	asl a
	adc.w #textmap
	sta.w DMAList,y
	lda.w #textmap>>16
	sta.w DMAList+dmabank,y
	lda.b textdirtyhi
	beq .rtl
	sec
	sbc.b textdirtylo
	inc a
	asl a
	sta.w DMAList+dmalen,y
	lda.w #$FFFF
	sta.b textdirtylo
	stz.b textdirtyhi
	tya
	clc
	adc.w #dmasize
	sta.b DMAListend
.rtl:
	rtl
QueueBackmapDMA:		;SNES: DMAList entry for backmap ($800 bytes) to vram $400
	ldy.b DMAListend
	lda.w #backmap
	sta.w DMAList,y
	lda.w #backmap>>16
	sta.w DMAList+dmabank,y
	lda.w #$0800
	sta.w DMAList+dmalen,y
	lda.w #$0400
	sta.w DMAList+dmavram,y
	tya
	clc
	adc.w #dmasize
	sta.b DMAListend
	rtl
ShowRinkRows:		;93G show_rink role: DMAList entries for the IceRinkMap rows that Vscroll brought on screen (Oldrow, vramrow)
	ldy.b DMAListend
	lda.w Vscroll
	clc
	adc.w #$0170
	lsr a
	lsr a
	lsr a
	tax
	sec
	sbc.w Oldrow
	bne .nonzero
	jmp.w .join2
.nonzero:
	bpl .pos
	stx.w Oldrow
	eor.w #$FFFF
	inc a
	cmp.w #$0019
	bcs .loop
	sta.b tmp1
	lda.w vramrow
	sec
	sbc.b tmp1
	and.w #$001F
	sta.w vramrow
	sta.b tmp2
	bra .join
.loop:
	lda.w #$001D
	sta.b tmp1
	stz.w vramrow
	stz.b tmp2
	bra .join
.pos:
	stx.w Oldrow
	cmp.w #$0019
	bcs .loop
	sta.b tmp1
	adc.w vramrow
	and.w #$001F
	sta.w vramrow
	adc.w #$001D
	sec
	sbc.b tmp1
	and.w #$001F
	sta.b tmp2
	txa
	clc
	adc.w #$001D
	sec
	sbc.b tmp1
	tax
.join:
	txa
	asl a
	asl a
	asl a
	asl a
	asl a
	sta.b tmp0
	asl a
	adc.b tmp0
	adc.w #IceRinkMap
	sta.b tmp0
	lda.b tmp2
	asl a
	asl a
	asl a
	asl a
	asl a
	adc.w #$0400
	sta.b tmp2
	ldx.b tmp1
.loop2:
	lda.w #IceRinkMap>>16
	sta.w DMAList+dmabank,y
	sta.w DMAList+dmasize+dmabank,y
	lda.b tmp2
	sta.w DMAList+dmavram,y
	clc
	adc.w #$0400
	sta.w DMAList+dmasize+dmavram,y
	sec
	sbc.w #$03E0
	cmp.w #$0800
	bne .ne
	lda.w #$0400
.ne:
	sta.b tmp2
	lda.b tmp0
	sta.w DMAList,y
	clc
	adc.w #$0040
	sta.w DMAList+dmasize+dmasrc,y
	adc.w #$0020
	sta.b tmp0
	lda.w #$0040
	sta.w DMAList+dmalen,y
	lsr a
	sta.w DMAList+dmasize+dmalen,y
	tya
	adc.w #$000E
	tay
	dex
	bne .loop2
.join2:
	sty.b DMAListend
	rtl
jdtab8F:		;93G jdtab: buttons r,l,d,u -> direction 0-7, 8 = none (checksso)
	db 8,0,4,8,6,7,5,8,2,1,3,8,8,8,8,8
InitScores:		;93G InitScores: playoff rounds 0-1: random scores so far for the other games of the round (SetScore 1-3 times)
	lda.w OptPlayMode
	beq .rtl
	lda.w gamelevel
	cmp.w #$0002
	bcs .rtl
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.loop:
	lda.b d1
	cmp.w gamenum
	beq .d1eq
	ldy.b a0
	lda.w gsflags,y
	bit.w #$0004
	bne .d1eq
	lda.w #$0000
	sta.w gsper,y
	lda.w #$0003
	sta.b d0
	jsl.l randomd0
	bra .join
.loop2:
	jsl.l SetScore
.join:
	dec.b d0
	bpl .loop2
.d1eq:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .loop
.rtl:
	rtl
ResetPassWord:		;92G ResetPassWord: PassWord = 16 blanks ($1E) with bit 7 clear
	sep #$30
	stz.w PassWord
	ldy.b #$0F
	lda.b #$1E
.loop:
	sta.w PassWord,y
	dey
	bne .loop
	rep #$30
	rtl
