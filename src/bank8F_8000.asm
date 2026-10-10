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
unusedEnergyBar:		;auto: CODE_8F8130. SNES: no caller found: a 4-character energy bar of d0 (8 levels per character) printed at printx-11, palette by d1
	stx.b xsave
	ldx.w #$0000
.l1:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .l1
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.l2:
	lda.b a1,x
	pha
	inx
	inx
	cpx.w #$0004
	bne .l2
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
	bcc .l3
	lda.w #$001F
.l3:
	sta.b d0
	ldy.w #$0002
	lda.w #$0006
	sta.w mesarea
	lda.w #$0003
	sta.b d3
.l4:
	lda.w #$FFFF
	sta.b d2
	lda.b d0
	bmi .l5
	sta.b d2
	cmp.w #$0008
	bcc .l5
	lda.w #$0007
	sta.b d2
.l5:
	lda.b d2
	sec
	adc.b d1
	and.w #$00FF
	bne .l6
	lda.w #$0020
.l6:
	sta.w mesarea,y
	iny
	lda.b d0
	sec
	sbc.w #$0008
	sta.b d0
	dec.b d3
	bpl .l4
	lda.b d1
	beq .l7
	lda.w #$0C00
	tsb.w printa
.l7:
	lda.w #$0191
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.w printx
	sec
	sbc.w #$000B
	sta.w printx
	lda.w #$4000
	tsb.w printa
	lda.w #$0191
	sta.b a1
	lda.w #$0000
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
.l8:
	pla
	sta.b a1,x
	dex
	dex
	bpl .l8
	ldx.b xsave
	stx.b xsave
	ldx.w #$000E
.l9:
	pla
	sta.b d0,x
	dex
	dex
	bpl .l9
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
showclock:		;auto: CODE_8F82A4 (from setvideo). 93G showclock (video93_2): the game clock m:ss at x 3, y $18 (horizontal rink: x $D, y 4; not when gsp = 4); not in replay
	lda.w sflags
	bit.w #sf2replay
	beq .l1
	jmp.w .l4
.l1:
	lda.w #$0007
	sta.w mesarea
	lda.w #$0020
	sta.w mesarea+2
	lda.w gameclock
	sta.b mulb
	lda.w #600
	sta.b mula
	jsl.l divu16
	beq .l2
	adc.w #$0030
	sta.w mesarea+2
.l2:
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
	beq .l3
	lda.w #$000D
	sta.w printx
	lda.w #$0004
	sta.w printy
	lda.w gsp
	cmp.w #$0004
	beq .l4
.l3:
	lda.w #$0191
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	jml.l print
.l4:
	rtl
asseben:		;auto: CODE_8F833F (asstab 9). 93G asseben (logic93_2): player X comes onto the ice from the bench door (SPAwallright), then assexit
	lda.w pfalock,x
	bne .l2
	lda.w pflags,x
	bit.w #$0002
	beq .l3
	and.w #$FFFD
	sta.w pflags,x
	stz.w Xvel,x
	stz.w Yvel,x
	txa
	lsr a
	sec
	sbc.w #$0006
	bmi .l1
	inc a
.l1:
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
.l2:
	rtl
.l3:
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
PushRef:		;auto: CODE_8F83A7. 93G PushRef: ref window frame d0 (RefsMap or RefsMapHor, 8 x 7 words) into textmap; d0 $40 erases the window and prefmes
	phx
	stx.b xsave
	ldx.w #$0000
.l1:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$000C
	bne .l1
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.l2:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0008
	bne .l2
	ldx.b xsave
	lda.b d0
	cmp.w #$40
	bne .l3
	jmp.w .l9
.l3:
	sta.b mulb
	lda.w #$70
	sta.b mula
	jsl.l mulu16
	sta.b d0
	lda.w #RefsMap
	sta.b a0
	lda.w #RefsMap>>16
	sta.b a0+2
	lda.w #$0084
	sta.b tmp1
	lda.w refchars
	sta.b tmp0
	lda.w sfhormode
	beq .l4
	lda.w refcharshor
	sta.b tmp0
	lda.w #$03DA
	sta.b tmp1
	lda.w #RefsMapHor
	sta.b a0
	lda.w #RefsMapHor>>16
	sta.b a0+2
.l4:
	lda.b a0
	clc
	adc.b d0
	sta.b a0
	lda.w #$0008
	sta.b tmp2
.l5:
	ldy.w #$0007
.l6:
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
	bcs .l7
	sta.b textdirtylo
.l7:
	cmp.b textdirtyhi
	bcc .l8
	sta.b textdirtyhi
.l8:
	inc.b a0
	inc.b a0
	inc.b tmp1
	inc.b tmp1
	dey
	bne .l6
	lda.b tmp1
	clc
	adc.w #$0032
	sta.b tmp1
	dec.b tmp2
	bne .l5
	lda.w #sf2refref
	tsb.w sflags
	bra .l11
.l9:
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
	beq .l10
	lda.w #$000D
	sta.w printx
	lda.w #$000F
	sta.w printy
.l10:
	jsl.l eraser
	lda.w #sf2refref
	tsb.w sflags
	lda.w #$FFFF
	sta.b d0
	jsl.l prefmes
.l11:
	stx.b xsave
	ldx.w #$0006
.l12:
	pla
	sta.b a0,x
	dex
	dex
	bpl .l12
	ldx.b xsave
	stx.b xsave
	ldx.w #$000A
.l13:
	pla
	sta.b d0,x
	dex
	dex
	bpl .l13
	ldx.b xsave
	plx
	rtl
SetHor:		;auto: CODE_8F84B5. 93G SetHor: switch to the horizontal rink (scoreboard screen): half puck speed, forceblack, sfhormode, StatsReport
	stx.b xsave
	ldx.w #$0000
.l1:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .l1
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.l2:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$001C
	bne .l2
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
.l3:
	pla
	sta.b a0,x
	dex
	dex
	bpl .l3
	ldx.b xsave
	stx.b xsave
	ldx.w #$001A
.l4:
	pla
	sta.b d0,x
	dex
	dex
	bpl .l4
	ldx.b xsave
	ldx.b a3
	rtl
USBoard:		;auto: CODE_8F852E. 93G USBoard (penalty93_2): printscores1, then each team's penalty box players and their time (.dispen)
	stx.b xsave
	ldx.w #$0000
.l1:
	lda.b d0,x
	pha
	inx
	inx
	cpx.w #$0020
	bne .l1
	ldx.b xsave
	stx.b xsave
	ldx.w #$0000
.l2:
	lda.b a0,x
	pha
	inx
	inx
	cpx.w #$0010
	bne .l2
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
.l3:
	pla
	sta.b a0,x
	dex
	dex
	bpl .l3
	ldx.b xsave
	stx.b xsave
	ldx.w #$001E
.l4:
	pla
	sta.b d0,x
	dex
	dex
	bpl .l4
	ldx.b xsave
	ldx.b a3
.l5:
	rtl
.dispen:		;93G .dispen: penalty box list of team a2: timed players first
	lda.b a2
	beq .l6
	lda.w #$001A
.l6:
	sta.b a0
.l7:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .l9
	lda.b a2
	beq .l8
	lda.w #$0034
.l8:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	bne .l7
	jsl.l pplpen
	bra .l7
.l9:
	lda.b a2
	beq .l10
	lda.w #$001A
.l10:
	sta.b a0
.l11:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .l5
	lda.b a2
	beq .l12
	lda.w #$0034
.l12:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	beq .l11
	jsl.l pplpen
	bra .l11
pplpen:		;auto: CODE_8F85FA. 93G pplpen: one penalty box line: player number and time left (rows up to y $A)
	lda.w printy
	cmp.w #$000B
	bcs USBoard_l5
	lda.b a2
	beq .l1
	lda.w #$0034
.l1:
	adc.b d0
	tay
	lda.w tmpdst,y
	and.w #$07FF
	sta.b d2
	lda.w #$0083
	sta.b a1+2
	ldy.b a2
	lda.w tmdata,y
	sta.b a1
	ldy.w #$0000
	adc.b [a1],y
	sta.b a1
	lsr.b d0
.l2:
	lda.b [a1]
	clc
	adc.b a1
	adc.w #$0008
	sta.b a1
	dec.b d0
	bpl .l2
	lda.b a1
	sec
	sbc.w #$0008
	sta.b a1
	lda.b [a1]
	and.w #$00FF
	sta.b d0
	lda.w printx
	pha
	lda.w #$0193
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	jsl.l PutDigits2
	lda.w #$0191
	sta.b a1
	lda.w #$0000
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
pushnumber:		;auto: CODE_8F8682. 93G pushnumber: mesarea string of the decimal number d0 (built backward from $1AF)
	lda.w #$01AF
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.b d0
.l1:
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
	bne .l1
	dec.b a1
	dec.b a1
	lda.w #$01AF
	sec
	sbc.b a1
	sta.b [a1]
	rtl
Intermission:		;auto: CODE_8F86B6 (from PeriodOver). 93G Intermission (SNES form): the pause menu screen with the ticker scores of the other games (IntermissionTick), then the highlights
	jsl.l sndqreset
	jsl.l SetupTeamForIntermission
	lda.w #$0000
	ldy.w #$001E
.l1:
	sta.w Xpos,y
	dey
	dey
	bpl .l1
.l2:
	lda.b vcount
	ldy.b vcount+2
	cmp.b vcount
	bne .l2
	sta.w vcountmark
	sty.w vcountmark+2
	lda.w #$0001
	trb.w sflags
	lda.w gsp
	cmp.w #$0004
	beq .l3
	bra .l3
.l3:
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
.l4:
	lda.w #$0000
	ldy.w #$001E
.l5:
	sta.w Xpos,y
	dey
	dey
	bpl .l5
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
	bne .l4
	stz.w demoflag
.l6:
	rtl
InitTicker:		;auto: CODE_8F873F. SNES: start the ticker at the last game of the round (GetShifter) unless one is running, then NewTicker2
	lda.w TickerNum
	bmi .l1
	ora.w gamenum
	bne .l2
.l1:
	jsl.l GetShifter
	lda.b d1
	sta.w TickerNum
	bmi Intermission_l6
.l2:
	jmp.w NewTicker2
StatsScreen:		;auto: CODE_8F8757 (pause menu). SNES: DisplayStats, then wait for A or 60 seconds
	jsl.l DisplayStats
	lda.b vcount
	pha
.l1:
	jsl.l setvideo
	jsl.l ReadPads
	jsl.l getpzjoy
	lda.b d1
	bit.w #$0080
	bne .l2
	lda.b vcount
	sec
	sbc.b $01,s
	cmp.w #$0E10
	bcc .l1
.l2:
	pla
	rtl
IntermissionTick:		;auto: CODE_8F877D (from PauseMenu). SNES: during the intermission show the next ticker score every $150 frames; after the last one the highlights (DoHiLights). A = 0: go on
	lda.w demoflag
	beq .l1
	lda.b vcount
	sec
	sbc.w tickervc
	cmp.w #$0150
	bcc .l2
	jsl.l TickerNext
	lda.w tickerstart
	cmp.w TickerNum
	bne IntermissionTick
	jsl.l DoHiLights
	lda.w #$0008
	trb.w sflags3
.l1:
	rtl
.l2:
	lda.w #$0000
	rtl
TickerNext:		;auto: CODE_8F87A8. SNES: next ticker game (restart at the last game of the round), NewTicker2
	lda.w TickerNum
	bmi .l1
	ora.w gamenum
	bne .l2
.l1:
	jsl.l GetShifter
	lda.b d1
	sta.w TickerNum
	bmi IntermissionTick_l1
.l2:
	jmp.w NewTicker2
KillCrowd:		;auto: CODE_8F87C0. 93G KillCrowd: crowd volume $88 (silence) to the sound driver
	lda.w #$0088
	pha
	jsl.l sfx8F
	rtl
appstring:		;auto: CODE_8F87C9. 93G appstring: append string [a1] to the string [a3]
	lda.w #$0002
	sta.b tmp0
	lda.b [a3]
	sta.b tmp1
.l1:
	lda.b tmp0
	cmp.b [a1]
	beq .l2
	tay
	lda.b [a1],y
	ldy.b tmp1
	sta.b [a3],y
	inc.b tmp0
	inc.b tmp1
	bra .l1
.l2:
	lda.b tmp1
	sta.b [a3]
	rtl
PushTime:		;auto: CODE_8F87EA. 93G PushTime: mesarea string m:ss of the time d0 (seconds)
	lda.w #$01AF
	sta.b a1
	lda.w #$0000
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
	beq .l1
	dec.b a1
	sep #$20
	adc.b #$30
	sta.b [a1]
	rep #$30
.l1:
	dec.b a1
	dec.b a1
	lda.w #$01AF
	sec
	sbc.b a1
	sta.b [a1]
	rtl
NewTicker:		;auto: CODE_8F8858 (from chkprogress). 93G NewTicker: once the clock is at 8:00 or less, the next ticker score
	lda.w gameclock
	cmp.w #$01E1
	bcc NewTicker2
	rtl
NewTicker2:		;auto: CODE_8F8861. 93G NewTicker2/CheckGameTickerStatus: d3 = next ticker game (not the user game, no highlight coming, series not over)
	lda.w OptPlayMode
	beq .l1
	lda.w TickerNum
	sta.b d3
	bmi .l1
	dec.w TickerNum
	lda.b d3
	cmp.w gamenum
	beq NewTicker2
	bra NewTicker3
.l1:
	rtl
NewTicker3:		;auto: CODE_8F887A. 93G NewTicker3: the ticker box for game d3: GameLabels round name, period, both teams with scores (TickerTeam)
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
	bne .l1
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$02,$17
.l1:
	lda.w sfhormode
	bne .l2
	lda.w printy
	sec
	sbc.w #$0005
	sta.w printy
.l2:
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
TickerTeam:		;auto: CODE_8F8960. SNES: ticker line: team d0 name (TeamList record) and score d1, one row down
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
	lda.w #$0083
	sta.b a1+2
	ldy.w #$0004
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
showzam:		;auto: CODE_8F8ABC (from setvideo). 93G showzam role: on the horizontal rink the zamboni sprite ($22D) moves with the time since vcountmark
	lda.b vcount
	ldy.b vcount+2
	cmp.b vcount
	bne showzam
	sbc.w vcountmark
	sta.b tmp0
	tya
	sbc.w vcountmark+2
	bne .l1
	lda.w sfhormode
	beq .l1
	lda.b tmp0
	lsr a
	lsr a
	sta.b sprx
	lda.w #$00C8
	sta.b spry
	lda.w #$022D
	sta.b sprframe
	jsl.l addframe
.l1:
	rtl
waitxsr:		;auto: CODE_8F8AE9. 92G waitxsr: wait d0 frames or until a pad button (d1)
	lda.b d0
	pha
.l1:
	jsl.l Readjoy1
	lda.b d1
	bne .l3
	jsl.l Readjoy2
	lda.b d1
	bne .l3
	jsl.l setvideo
	lda.b vcount
.l2:
	cmp.b vcount
	beq .l2
	jsl.l ReadPads
	pla
	dec a
	pha
	bpl .l1
.l3:
	pla
	rtl
clockcont:		;auto: CODE_8F8B11 (from periodicevents). 93G clockcont (hockey93_01): clock at 0: freezewindow, then clockcont_0
	lda.w gmclock
	ora.w gameclock
	bne .l1
	jsl.l freezewindow
	jmp.w clockcont_0
.l1:
	rtl
clockcont_0:		;auto: CODE_8F8B21 (also from puckfaceoff). 93G clockcont_0: end of period: puck pucknorm; third period winners celebrate (assscore, the Stanley Cup in the final), the game clock stops
	ldx.w #$001C
	stx.b a3
	lda.w #$18
	sta.b d0
	jsl.l assinsert
	lda.w gsp
	cmp.w #$0002
	bcs .l1
	jmp.w .l11
.l1:
	lda.w #$0007
	sta.b d0
	ldx.w #$0000
	stx.b a3
	lda.w gamelevel
	cmp.w #$0003
	bne .l6
	lda.b bosgames
	cmp.w #$0007
	beq .l4
	lda.w gamenum
	asl a
	sta.b a0
	tay
	stz.b d3
	lda.w gsflags,y
	bit.w #$0001
	beq .l2
	lda.w #$0010
	sta.b d3
.l2:
	lda.w tmscore
	cmp.w tmscore+2
	bpl .l3
	lda.b d3
	eor.w #$0010
	sta.b d3
.l3:
	lda.b a0
	clc
	adc.b d3
	tay
	lda.w gspotwins,y
	cmp.w #$0003
	bne .l6
.l4:
	lda.w #$0008
	sta.b d0
	lda.w #$000B
	sta.b d2
.l5:
	lda.w pflags,x
	and.w #$FFF7
	sta.w pflags,x
	inx
	inx
	dec.b d2
	bpl .l5
	ldx.w #$0000
	stx.b a3
.l6:
	lda.w #$0005
	sta.b d2
	lda.w tmscore
	cmp.w tmscore+2
	beq .l11
	bpl .l7
	ldx.w #$000C
	stx.b a3
.l7:
	lda.w position,x
	beq .l8
	jsl.l assinsert
	lda.w #$0007
	sta.b d0
.l8:
	inx
	inx
	stx.b a3
	dec.b d2
	bpl .l7
.l9:
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
	bmi .l10
	stz.b crowdlevel
	lda.w #$0003
	sta.w cheercnt
	lda.b vcount
	sec
	sbc.w #$0096
	sta.w cheervc
.l10:
	lda.w #$0004
	sta.b d0
	jml.l AddPenalty2
.l11:
	lda.w gsp
	cmp.w #$0003
	bne .l12
	lda.w OptPlayMode
	beq .l9
.l12:
	lda.w #$0002
	sta.b d0
	jml.l AddPenalty2
DoHiLights:		;auto: CODE_8F8C1B. 92G DoHiLights: in the playoffs play the highlight of each game of the round that asks for one (gsfhl, StartHL2)
	lda.w OptPlayMode
	beq .l3
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.l1:
	ldy.b a0
	lda.w gsflags,y
	bit.w #$0004
	bne .l2
	bit.w #$0002
	beq .l2
	and.w #$FFFD
	sta.w gsflags,y
	jsl.l far8DF888
.l2:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .l1
.l3:
	rtl
assdopen:		;auto: CODE_8F8C4B (asstab $D). 93G assdopen (logic93_2): add player X to the penalty box (PBnum), position -1, frame 0
	lda.w pfalock,x
	bne .l2
	lda.w #$0010
	sta.b d0
	lda.w pfteam,x
	beq .l1
	lda.w #$0001
	sta.b d0
.l1:
	lda.w PBnum
	clc
	adc.b d0
	sta.w PBnum
	lda.w #$FFFF
	sta.w position,x
	stz.w frame,x
.l2:
	rtl
updatepentime:		;auto: CODE_8F8C72. 93G updatepentime: once a second count down the penalty box times of both teams; release players whose time is up
	lda.w #$0020
	trb.w sflags3
	lda.w gmclock
	bne .l5
	lda.w pentimer
	sec
	sbc.b d7
	sta.w pentimer
	bpl .l5
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
	beq .l1
	lda.w #$001A
.l1:
	sta.b a0
	lda.w #$0191
	sta.b a1
	lda.w #$0000
	sta.b a1+2
	lda.w #$0002
	sta.b d1
	sta.b d3
.l2:
	ldy.b a0
	lda.w tmboxlist,y
	inc.b a0
	and.w #$00FF
	sta.b d0
	bit.w #$0080
	bne .l6
	lda.b a2
	beq .l3
	lda.w #$0034
.l3:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	bit.w #$4000
	bne .l13
	dec.b d1
	bmi .l2
	lda.b d0
	sta.b [a1]
	inc.b a1
	inc.b a1
	lda.w tmpdst,y
	dec a
	sta.w tmpdst,y
	bne .l4
	jsl.l RemovePlayerFromList
.l4:
	bra .l2
.l5:
	rtl
.l6:
	lda.w mesarea
	sta.b d0
	lda.b d1
	cmp.w #$0001
	beq .rel
	lda.b d1
	bne .l7
	jsl.l .rel
	bra .l8
.l7:
	lda.b d1
	cmp.w #$FFFF
	bne .l5
.l8:
	lda.w mesarea+2
	sta.b d0
.rel:		;release player d0 when his time is <= 5 (RemovePlayerFromList)
	lda.b a2
	beq .l9
	lda.w #$0034
.l9:
	clc
	adc.b d0
	tay
	lda.w tmpdst,y
	sec
	sbc.w #$0005
	beq .l11
	bmi .l10
	bvs .l11
	bra .l5
.l10:
	bvs .l5
.l11:
	lda.w tmpdst,y
	bne .l12
	jsl.l releasepl
.l12:
	rtl
.l13:
	dec a
	sta.w tmpdst,y
	bit.w #$0800
	bne .l14
	jmp.w .l2
.l14:
	bit.w #$1000
	bne .l15
	lda.w #$1000
	sta.w tmpdst,y
	jmp.w RemovePlayerFromList
.l15:
	lda.w #$0000
	sta.w tmpdst,y
	jmp.w RemovePlayerFromList
linebar:		;auto: CODE_8F8D68 (line change box). 93G linebar: energy bar of line d0 (getlinee) as 5 small font characters
	jsl.l getlinee
	lda.w printa
	pha
	lda.w #$3000
	sta.w printa
	lda.b d0
	cmp.w #$1000
	bcc .l1
	lda.w #$1000
.l1:
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
	lda.w #$0191
	sta.b a1
	lda.w #$0000
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
lcfound:		;auto: CODE_8F8DC7. 93G lcfound (logic93_1): d2 = line choice 0-2: getlchoice; loadTeamStruct, tmline, setpersonel, lcfound2
	ldx.b a3
	ldy.b a2
	lda.b d2
	sta.b d0
	sta.w tmlcchoice,y
	jsl.l getlchoice
	lda.b d0
	bmi .l1
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
.l1:
	rtl
startpause1:		;auto: CODE_8F8E03. 93G startpause1: pause started by controller 1 (sfpj off), startpause
	lda.w #$0002
	trb.w sflags
	jml.l startpause
PauseExit:		;auto: CODE_8F8E0D. 92G PauseExit: restore textmap (textsave), sflags and the rink, printscores1, setvideo
	stz.w cuetimer
	stz.w crowdvol
	jsl.l forceblack
	phx
	ldx.w #$07FE
.l1:
	lda.l textsave,x
	sta.l textmap,x
	dex
	dex
	bpl .l1
	plx
	stz.b textdirtylo
	lda.w #$03FF
	sta.b textdirtyhi
	pla
	sta.w sflags
	pla
	sta.w sfhormode
	bne .l2
	jsl.l ClrHor
.l2:
	lda.w #$0001
	trb.w sflags
	jsl.l printscores1
	jsl.l setvideo
	lda.b vcount
	sta.w lastframevc
	sta.w oldvcount
	rtl
suba4:		;auto: CODE_8F8E54. 93G suba4: replay a4 one frame back (wrap at ReplayBufferStart unless sfwrap), RestoreReplayFrame; d7 = 0 at the end
	lda.b a4
	cmp.w #ReplayBufferStart
	bne .l1
	lda.b a4+2
	cmp.w #ReplayBufferStart>>16
	bne .l1
	lda.w sflags
	bit.w #sfwrap
	beq .l4
	lda.w #ReplayBufferEnd
	sta.b a4
	lda.w #ReplayBufferEnd>>16
	sta.b a4+2
.l1:
	lda.b a4
	sec
	sbc.w #replaysize
	sta.b a4
	lda.b a4+2
	sbc.w #$0000
	sta.b a4+2
	lda.b a4
	cmp.w ReplayBufferPtr
	beq .l2
	jml.l RestoreReplayFrame
.l2:
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	beq .l3
	jml.l RestoreReplayFrame
.l3:
	lda.b a4
	clc
	adc.w #replaysize
	sta.b a4
	lda.b a4+2
	adc.w #$0000
	sta.b a4+2
.l4:
	jsl.l RestoreReplayFrame
	stz.b d7
	rtl
adda4:		;auto: CODE_8F8EAF. 93G adda4: replay a4 one frame on unless it reaches ReplayBufferPtr; d7 = 0 at the end
	stz.b d7
	lda.w sflags
	bit.w #sf2drec
	beq .l1
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
	bne .l1
	lda.b tmp1
	cmp.w ReplayBufferPtr+2
	bne .l1
	rtl
.l1:
	lda.b a4
	cmp.w ReplayBufferPtr
	bne .l2
	lda.b a4+2
	cmp.w ReplayBufferPtr+2
	bne .l2
	rtl
.l2:
	jsl.l RestoreReplayFrame
	jml.l adda43
QueueTextDMA:		;auto: CODE_8F8EF7. SNES: DMAList entry for the changed textmap words (textdirtylo..textdirtyhi) to vram
	lda.b textdirtylo
	bmi .l1
	ldy.b DMAListend
	sta.w DMAList+dmavram,y
	asl a
	adc.w #textmap
	sta.w DMAList,y
	lda.w #textmap>>16
	sta.w DMAList+dmabank,y
	lda.b textdirtyhi
	beq .l1
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
.l1:
	rtl
QueueBackmapDMA:		;auto: CODE_8F8F28. SNES: DMAList entry for backmap ($800 bytes) to vram $400
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
ShowRinkRows:		;auto: CODE_8F8F4A (from setvideo). 93G show_rink role: DMAList entries for the IceRinkMap rows that Vscroll brought on screen (Oldrow, vramrow)
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
	bne .l1
	jmp.w .l7
.l1:
	bpl .l3
	stx.w Oldrow
	eor.w #$FFFF
	inc a
	cmp.w #$0019
	bcs .l2
	sta.b tmp1
	lda.w vramrow
	sec
	sbc.b tmp1
	and.w #$001F
	sta.w vramrow
	sta.b tmp2
	bra .l4
.l2:
	lda.w #$001D
	sta.b tmp1
	stz.w vramrow
	stz.b tmp2
	bra .l4
.l3:
	stx.w Oldrow
	cmp.w #$0019
	bcs .l2
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
.l4:
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
.l5:
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
	bne .l6
	lda.w #$0400
.l6:
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
	bne .l5
.l7:
	sty.b DMAListend
	rtl
jdtab8F:		;93G jdtab: buttons r,l,d,u -> direction 0-7, 8 = none (checksso)
	db 8,0,4,8,6,7,5,8,2,1,3,8,8,8,8,8
InitScores:		;auto: CODE_8F902A (from StartGame). 93G InitScores: playoff rounds 0-1: random scores so far for the other games of the round (SetScore 1-3 times)
	lda.w OptPlayMode
	beq .l5
	lda.w gamelevel
	cmp.w #$0002
	bcs .l5
	jsl.l GetShifter
	lda.b d1
	asl a
	sta.b a0
.l1:
	lda.b d1
	cmp.w gamenum
	beq .l4
	ldy.b a0
	lda.w gsflags,y
	bit.w #$0004
	bne .l4
	lda.w #$0000
	sta.w gsper,y
	lda.w #$0003
	sta.b d0
	jsl.l randomd0
	bra .l3
.l2:
	jsl.l SetScore
.l3:
	dec.b d0
	bpl .l2
.l4:
	dec.b a0
	dec.b a0
	dec.b d1
	bpl .l1
.l5:
	rtl
ResetPassWord:		;auto: CODE_8F9073. 92G ResetPassWord: PassWord = 16 blanks ($1E) with bit 7 clear
	sep #$30
	stz.w PassWord
	ldy.b #$0F
	lda.b #$1E
.l1:
	sta.w PassWord,y
	dey
	bne .l1
	rep #$30
	rtl
